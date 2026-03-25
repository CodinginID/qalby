import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../../../features/prayer/data/prayer_times_model.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'adzan_channel';
  static const _channelName = 'Adzan & Waktu Sholat';
  static const _channelDesc = 'Notifikasi pengingat waktu sholat';

  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    // Try to set to Jakarta timezone; fall back to UTC if not found
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    // Request Android 13+ notification permission
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> scheduleAdzanNotifications(
    PrayerTimesModel prayerTimes,
    Map<String, bool> enabledMap,
  ) async {
    await init();
    await _plugin.cancelAll();

    final times = prayerTimes.times;
    final names = PrayerTimesModel.prayerNames;

    for (int i = 0; i < names.length; i++) {
      final enabled = enabledMap[names[i]] ?? true;
      if (!enabled) continue;

      final scheduledTime = times[i];
      if (scheduledTime.isBefore(DateTime.now())) continue;

      await _plugin.zonedSchedule(
        i,
        'Waktu ${names[i]}',
        'Saatnya melaksanakan sholat ${names[i]}',
        tz.TZDateTime.from(scheduledTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.high,
            priority: Priority.high,
            sound: const RawResourceAndroidNotificationSound('adzan'),
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            sound: 'adzan.aiff',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }
}
