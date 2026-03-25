import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../playlist/data/playlist_model.dart';

class PracticeRemoteService {
  final ApiClient _client;
  PracticeRemoteService(this._client);

  /// Simpan sesi latihan yang sudah selesai ke backend
  Future<void> saveSession(PracticeSession session) async {
    // 1. Buat session baru di backend
    final createRes = await _client.dio.post('/practice/sessions', data: {
      'playlist_id': session.playlist.id,
    });
    final sessionId = createRes.data['data']['id'] as String;

    // 2. Update session dengan progress + mark ended
    final itemsProgress = session.playlist.items.map((item) {
      return {
        'item_id': item.id,
        'repetitions': session.repetitions[item.id] ?? 0,
        'status': session.completedIds.contains(item.id) ? 'done' : 'not_started',
      };
    }).toList();

    await _client.dio.put('/practice/sessions/$sessionId', data: {
      'items_progress': itemsProgress,
      'notes': '',
      'ended': true,
    });
  }

  /// Ambil riwayat sesi latihan (max 20, terbaru dulu)
  Future<List<Map<String, dynamic>>> getSessions() async {
    final res = await _client.dio.get('/practice/sessions');
    final list = res.data['data'] as List;
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  /// Ambil statistik latihan (total sessions, repetitions, completed items)
  Future<Map<String, dynamic>> getStats() async {
    final res = await _client.dio.get('/practice/stats');
    return res.data['data'] as Map<String, dynamic>;
  }
}

final practiceRemoteServiceProvider = Provider<PracticeRemoteService>(
  (ref) => PracticeRemoteService(ref.read(apiClientProvider)),
);
