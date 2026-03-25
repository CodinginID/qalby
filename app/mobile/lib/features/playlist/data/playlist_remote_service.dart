import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import 'playlist_model.dart';

class PlaylistRemoteService {
  final ApiClient _client;
  PlaylistRemoteService(this._client);

  Future<List<Playlist>> getPlaylists() async {
    final res = await _client.dio.get('/playlists');
    final list = res.data['data'] as List;
    return list.map((e) => _playlistFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Playlist> createPlaylist(String name, String description) async {
    final res = await _client.dio.post('/playlists', data: {
      'name': name,
      'description': description,
    });
    return _playlistFromJson(res.data['data']);
  }

  Future<Playlist> updatePlaylist(String id, {String? name, String? description}) async {
    final res = await _client.dio.put('/playlists/$id', data: {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });
    return _playlistFromJson(res.data['data']);
  }

  Future<void> deletePlaylist(String id) async {
    await _client.dio.delete('/playlists/$id');
  }

  Future<PlaylistItem> addItem(String playlistId, PlaylistItem item) async {
    final res = await _client.dio.post('/playlists/$playlistId/items', data: {
      'surah_id': item.surahNumber,
      'surah_name': item.surahName,
      'surah_name_arabic': item.surahNameArabic,
      'ayat_start': item.ayatStart,
      'ayat_end': item.ayatEnd,
    });
    return _itemFromJson(res.data['data']);
  }

  Future<void> reorderItems(String playlistId, List<String> itemIds) async {
    await _client.dio.put('/playlists/$playlistId/items/reorder', data: {
      'item_ids': itemIds,
    });
  }

  Future<void> deleteItem(String playlistId, String itemId) async {
    await _client.dio.delete('/playlists/$playlistId/items/$itemId');
  }

  // ── JSON parsers ────────────────────────────────────────────────────────────

  static Playlist _playlistFromJson(Map<String, dynamic> j) => Playlist(
        id: j['id'] as String,
        name: j['name'] as String,
        description: j['description'] as String? ?? '',
        items: (j['items'] as List? ?? []).map((i) => _itemFromJson(i as Map<String, dynamic>)).toList(),
        createdAt: _parseDate(j['created_at']),
      );

  static PlaylistItem _itemFromJson(Map<String, dynamic> j) => PlaylistItem(
        id: j['item_id'] as String,
        surahNumber: j['surah_id'] as int,
        surahName: j['surah_name'] as String,
        surahNameArabic: j['surah_name_arabic'] as String? ?? '',
        ayatStart: j['ayat_start'] as int,
        ayatEnd: j['ayat_end'] as int,
        order: j['order'] as int,
      );

  static DateTime _parseDate(dynamic raw) {
    if (raw == null) return DateTime.now();
    if (raw is String) return DateTime.tryParse(raw) ?? DateTime.now();
    return DateTime.now();
  }
}

final playlistRemoteServiceProvider = Provider<PlaylistRemoteService>(
  (ref) => PlaylistRemoteService(ref.read(apiClientProvider)),
);
