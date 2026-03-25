import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

class PrayerRemoteService {
  final ApiClient _client;
  PrayerRemoteService(this._client);

  /// Get prayer times from backend (backend proxies to aladhan.com)
  Future<Map<String, dynamic>> getPrayerTimes(double lat, double lng, {String? date}) async {
    final res = await _client.dio.get('/prayer/times', queryParameters: {
      'lat': lat,
      'lng': lng,
      if (date != null) 'date': date,
    });
    return res.data['data'] as Map<String, dynamic>;
  }

  /// Get qibla direction from backend
  Future<Map<String, dynamic>> getQiblaDirection(double lat, double lng) async {
    final res = await _client.dio.get('/prayer/qibla', queryParameters: {
      'lat': lat,
      'lng': lng,
    });
    return res.data['data'] as Map<String, dynamic>;
  }

  /// Create a prayer reminder on backend
  Future<Map<String, dynamic>> createReminder({
    required String prayerName,
    int offsetMinutes = 0,
  }) async {
    final res = await _client.dio.post('/prayer/reminders', data: {
      'prayer_name': prayerName,
      'offset_minutes': offsetMinutes,
    });
    return res.data['data'] as Map<String, dynamic>;
  }

  /// Get all reminders from backend
  Future<List<Map<String, dynamic>>> getReminders() async {
    final res = await _client.dio.get('/prayer/reminders');
    final list = res.data['data'] as List;
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  /// Delete a reminder
  Future<void> deleteReminder(String reminderId) async {
    await _client.dio.delete('/prayer/reminders/$reminderId');
  }
}

final prayerRemoteServiceProvider = Provider<PrayerRemoteService>(
  (ref) => PrayerRemoteService(ref.read(apiClientProvider)),
);
