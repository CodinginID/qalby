import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/playlist_model.dart';
import '../data/playlist_remote_service.dart';
import '../../auth/domain/auth_provider.dart';

// ── Playlist List ──────────────────────────────────────────────────────────────

class PlaylistsNotifier extends Notifier<List<Playlist>> {
  @override
  List<Playlist> build() {
    Future.microtask(() => _loadFromApi(initial: true));
    return [];
  }

  PlaylistRemoteService get _service => ref.read(playlistRemoteServiceProvider);

  Future<void> _loadFromApi({bool initial = false}) async {
    if (!ref.read(isLoggedInProvider)) {
      if (initial) ref.read(playlistsIsLoadingProvider.notifier).setLoading(false);
      return;
    }
    try {
      state = await _service.getPlaylists();
    } catch (_) {}
    if (initial) {
      ref.read(playlistsIsLoadingProvider.notifier).setLoading(false);
    }
  }

  Future<void> refresh() => _loadFromApi();

  Future<bool> create(String name, String description) async {
    try {
      final playlist = await _service.createPlaylist(name, description);
      state = [playlist, ...state];
      return true;
    } catch (_) {
      ref.read(playlistErrorProvider.notifier).set('Gagal membuat playlist. Periksa koneksi.');
      return false;
    }
  }

  Future<void> delete(String id) async {
    final backup = [...state];
    state = state.where((p) => p.id != id).toList();
    try {
      await _service.deletePlaylist(id);
    } catch (_) {
      state = backup;
      ref.read(playlistErrorProvider.notifier).set('Gagal menghapus playlist. Periksa koneksi.');
    }
  }

  Future<void> updateName(String id, String name, String description) async {
    state = state.map((p) {
      if (p.id != id) return p;
      return p.copyWith(name: name, description: description);
    }).toList();
    try {
      await _service.updatePlaylist(id, name: name, description: description);
    } catch (_) {
      await _loadFromApi();
    }
  }

  Future<bool> addItem(String playlistId, PlaylistItem item) async {
    try {
      final savedItem = await _service.addItem(playlistId, item);
      state = state.map((p) {
        if (p.id != playlistId) return p;
        return p.copyWith(items: [...p.items, savedItem]);
      }).toList();
      return true;
    } catch (_) {
      ref.read(playlistErrorProvider.notifier).set('Gagal menambah ayat. Periksa koneksi.');
      return false;
    }
  }

  Future<void> removeItem(String playlistId, String itemId) async {
    final backup = [...state];
    state = state.map((p) {
      if (p.id != playlistId) return p;
      final newItems = p.items.where((i) => i.id != itemId).toList();
      for (var i = 0; i < newItems.length; i++) {
        newItems[i] = newItems[i].copyWith(order: i);
      }
      return p.copyWith(items: newItems);
    }).toList();
    try {
      await _service.deleteItem(playlistId, itemId);
    } catch (_) {
      state = backup;
    }
  }

  Future<void> reorderItems(String playlistId, int oldIndex, int newIndex) async {
    final backup = [...state];
    state = state.map((p) {
      if (p.id != playlistId) return p;
      final items = [...p.items];
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
      for (var i = 0; i < items.length; i++) {
        items[i] = items[i].copyWith(order: i);
      }
      return p.copyWith(items: items);
    }).toList();
    try {
      final playlist = state.firstWhere((p) => p.id == playlistId);
      await _service.reorderItems(playlistId, playlist.items.map((i) => i.id).toList());
    } catch (_) {
      state = backup;
    }
  }

  void markPracticed(String playlistId) {
    state = state.map((p) {
      if (p.id != playlistId) return p;
      return p.copyWith(totalPracticed: p.totalPracticed + 1);
    }).toList();
  }
}

final playlistsProvider =
    NotifierProvider<PlaylistsNotifier, List<Playlist>>(PlaylistsNotifier.new);

/// True hanya selama initial load pertama — dipakai Skeletonizer di PlaylistListPage
class PlaylistsLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void setLoading(bool value) => state = value;
}

final playlistsIsLoadingProvider =
    NotifierProvider<PlaylistsLoadingNotifier, bool>(PlaylistsLoadingNotifier.new);

/// Last error message from playlist operations — UI listens and shows SnackBar.
class PlaylistErrorNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? value) => state = value;
  void clear() => state = null;
}

final playlistErrorProvider =
    NotifierProvider<PlaylistErrorNotifier, String?>(PlaylistErrorNotifier.new);

final playlistByIdProvider = Provider.family<Playlist?, String>((ref, id) {
  final playlists = ref.watch(playlistsProvider);
  try {
    return playlists.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
});

// ── Practice Session ───────────────────────────────────────────────────────────

class PracticeNotifier extends Notifier<PracticeSession?> {
  @override
  PracticeSession? build() => null;

  void start(Playlist playlist) {
    state = PracticeSession(
      playlist: playlist,
      currentIndex: 0,
      repetitions: {},
      completedIds: {},
      startTime: DateTime.now(),
    );
  }

  void incrementRepetition() {
    if (state == null) return;
    final s = state!;
    final id = s.currentItem.id;
    final newReps = Map<String, int>.from(s.repetitions);
    newReps[id] = (newReps[id] ?? 0) + 1;
    state = s.copyWith(repetitions: newReps);
  }

  void decrementRepetition() {
    if (state == null) return;
    final s = state!;
    final id = s.currentItem.id;
    final newReps = Map<String, int>.from(s.repetitions);
    final current = newReps[id] ?? 0;
    if (current > 0) newReps[id] = current - 1;
    state = s.copyWith(repetitions: newReps);
  }

  void markDone() {
    if (state == null) return;
    final s = state!;
    final newDone = Set<String>.from(s.completedIds)..add(s.currentItem.id);
    state = s.copyWith(completedIds: newDone);
  }

  void next() {
    if (state == null || state!.isLast) return;
    state = state!.copyWith(currentIndex: state!.currentIndex + 1);
  }

  void previous() {
    if (state == null || state!.isFirst) return;
    state = state!.copyWith(currentIndex: state!.currentIndex - 1);
  }

  void goTo(int index) {
    if (state == null) return;
    final total = state!.playlist.items.length;
    if (index < 0 || index >= total) return;
    state = state!.copyWith(currentIndex: index);
  }

  void reset() => state = null;
}

final practiceProvider =
    NotifierProvider<PracticeNotifier, PracticeSession?>(PracticeNotifier.new);
