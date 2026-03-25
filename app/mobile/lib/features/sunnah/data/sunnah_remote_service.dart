import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

class SunnahRemoteService {
  final ApiClient _client;
  SunnahRemoteService(this._client);

  /// Ambil daftar sunnah dari backend
  Future<List<Map<String, dynamic>>> getSunnahList() async {
    final res = await _client.dio.get('/sunnah');
    final list = res.data['data'] as List;
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  /// Ambil statistik sunnah user
  Future<Map<String, dynamic>> getStats() async {
    final res = await _client.dio.get('/sunnah/stats');
    return res.data['data'] as Map<String, dynamic>;
  }

  /// Ambil log sunnah hari ini dari backend
  Future<Set<String>> getTodayLogs() async {
    final today = _today();
    final res = await _client.dio.get('/sunnah/logs', queryParameters: {'date': today});
    final list = res.data['data'] as List;
    return list.map((e) => e['sunnah_id'] as String).toSet();
  }

  /// Log sunnah selesai hari ini
  Future<void> logSunnah(String sunnahId) async {
    await _client.dio.post('/sunnah/logs', data: {
      'sunnah_id': sunnahId,
      'date': _today(),
    });
  }

  /// Hapus log (un-check)
  Future<void> deleteLog(String sunnahId) async {
    // Ambil log id dulu, lalu hapus
    final today = _today();
    final res = await _client.dio.get('/sunnah/logs', queryParameters: {'date': today});
    final list = res.data['data'] as List;
    final log = list.firstWhere(
      (e) => e['sunnah_id'] == sunnahId,
      orElse: () => null,
    );
    if (log != null) {
      await _client.dio.delete('/sunnah/logs/${log['id']}');
    }
  }

  String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

final sunnahRemoteServiceProvider = Provider<SunnahRemoteService>(
  (ref) => SunnahRemoteService(ref.read(apiClientProvider)),
);
