import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/sunnah_data.dart';
import '../../auth/domain/auth_provider.dart';
import '../../sunnah/data/sunnah_remote_service.dart';

class SunnahTrackerNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    Future.microtask(_loadFromApi);
    return {};
  }

  SunnahRemoteService get _service => ref.read(sunnahRemoteServiceProvider);

  Future<void> _loadFromApi() async {
    if (!ref.read(isLoggedInProvider)) return;
    try {
      state = await _service.getTodayLogs();
    } catch (_) {
      // Tetap gunakan state kosong jika offline / belum login
    }
  }

  Future<void> toggle(String itemId) async {
    if (!ref.read(isLoggedInProvider)) {
      // Guest: toggle locally only
      if (state.contains(itemId)) {
        state = {...state}..remove(itemId);
      } else {
        state = {...state, itemId};
      }
      return;
    }
    if (state.contains(itemId)) {
      // Optimistic un-check
      state = {...state}..remove(itemId);
      try {
        await _service.deleteLog(itemId);
      } catch (_) {
        // Rollback
        state = {...state, itemId};
      }
    } else {
      // Optimistic check
      state = {...state, itemId};
      try {
        await _service.logSunnah(itemId);
      } catch (_) {
        // Rollback
        state = {...state}..remove(itemId);
      }
    }
  }

  bool isChecked(String itemId) => state.contains(itemId);

  double get progressPercent {
    if (SunnahData.items.isEmpty) return 0;
    return state.length / SunnahData.items.length;
  }
}

final sunnahTrackerProvider =
    NotifierProvider<SunnahTrackerNotifier, Set<String>>(
  SunnahTrackerNotifier.new,
);
