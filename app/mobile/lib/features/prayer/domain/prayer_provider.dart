import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/prayer_times_model.dart';
import '../data/prayer_remote_service.dart';

// ─── Location ─────────────────────────────────────────────────────────────────

final locationProvider = FutureProvider<Position>((ref) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Layanan lokasi tidak aktif. Aktifkan GPS terlebih dahulu.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Izin lokasi ditolak. Izinkan akses lokasi untuk melihat waktu sholat.');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    throw Exception('Izin lokasi diblokir. Buka Pengaturan untuk mengizinkan akses lokasi.');
  }

  return await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
  );
});

// ─── Prayer Times (via backend API) ─────────────────────────────────────────

final prayerTimesProvider = FutureProvider<PrayerTimesModel>((ref) async {
  final position = await ref.watch(locationProvider.future);
  final service = ref.read(prayerRemoteServiceProvider);

  final data = await service.getPrayerTimes(position.latitude, position.longitude);

  // aladhan API returns timings as { "Fajr": "04:30", "Dhuhr": "11:45", ... }
  final timings = data['timings'] as Map<String, dynamic>;

  DateTime parseTime(String key) {
    final timeStr = timings[key] as String;
    // Format: "HH:mm" or "HH:mm (WIB)" — strip timezone label
    final clean = timeStr.split(' ').first;
    final parts = clean.split(':');
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  return PrayerTimesModel(
    locationName: '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}',
    fajr: parseTime('Fajr'),
    dhuhr: parseTime('Dhuhr'),
    asr: parseTime('Asr'),
    maghrib: parseTime('Maghrib'),
    isha: parseTime('Isha'),
  );
});

// ─── Qibla direction (via backend API) ──────────────────────────────────────

final qiblaProvider = FutureProvider<double>((ref) async {
  final position = await ref.watch(locationProvider.future);
  final service = ref.read(prayerRemoteServiceProvider);
  final data = await service.getQiblaDirection(position.latitude, position.longitude);
  return (data['qibla_direction'] as num).toDouble();
});

// ─── Countdown to next prayer ─────────────────────────────────────────────────

final prayerCountdownProvider = StreamProvider<Duration>((ref) {
  final asyncTimes = ref.watch(prayerTimesProvider);
  final prayerTimes = asyncTimes.value;
  if (prayerTimes == null) return const Stream.empty();

  final next = prayerTimes.nextPrayer;
  if (next == null) return Stream.value(Duration.zero);

  return Stream.periodic(const Duration(seconds: 1), (_) {
    final remaining = next.time.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  });
});

// ─── Notification preferences ─────────────────────────────────────────────────

const _kPrefKeyPrefix = 'notif_prayer_';

class NotificationPrefsNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() {
    Future.microtask(_loadFromPrefs);
    // Default: all enabled
    return {for (final name in PrayerTimesModel.prayerNames) name: true};
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final loaded = <String, bool>{};
    for (final name in PrayerTimesModel.prayerNames) {
      loaded[name] = prefs.getBool('$_kPrefKeyPrefix$name') ?? true;
    }
    state = loaded;
  }

  Future<void> toggle(String prayerName) async {
    final newValue = !(state[prayerName] ?? true);
    state = {...state, prayerName: newValue};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_kPrefKeyPrefix$prayerName', newValue);
  }

  bool isEnabled(String prayerName) => state[prayerName] ?? true;
}

final notificationPrefsProvider =
    NotifierProvider<NotificationPrefsNotifier, Map<String, bool>>(
  NotificationPrefsNotifier.new,
);
