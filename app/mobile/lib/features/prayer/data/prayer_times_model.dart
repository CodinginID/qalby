import 'package:flutter/material.dart';

class PrayerTimesModel {
  final String locationName;
  final DateTime fajr;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  const PrayerTimesModel({
    required this.locationName,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  static const List<String> prayerNames = [
    'Subuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya',
  ];

  static const List<IconData> prayerIcons = [
    Icons.bedtime_outlined,
    Icons.wb_sunny_outlined,
    Icons.wb_cloudy_outlined,
    Icons.wb_twilight_outlined,
    Icons.nightlight_outlined,
  ];

  List<DateTime> get times => [fajr, dhuhr, asr, maghrib, isha];

  /// Returns (index, name, time) of the next prayer. null if after Isya.
  ({int index, String name, DateTime time})? get nextPrayer {
    final now = DateTime.now();
    for (int i = 0; i < times.length; i++) {
      if (times[i].isAfter(now)) {
        return (index: i, name: prayerNames[i], time: times[i]);
      }
    }
    return null;
  }

  /// Returns the index of the last completed prayer (-1 if none today yet).
  int get currentPrayerIndex {
    final now = DateTime.now();
    int last = -1;
    for (int i = 0; i < times.length; i++) {
      if (times[i].isBefore(now)) last = i;
    }
    return last;
  }
}
