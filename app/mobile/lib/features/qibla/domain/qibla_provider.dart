import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../features/prayer/domain/prayer_provider.dart';
import '../../../features/prayer/data/prayer_remote_service.dart';

// ─── Qibla bearing (via backend API) ─────────────────────────────────────────

final qiblaBearingProvider = FutureProvider<double>((ref) async {
  final position = await ref.watch(locationProvider.future);
  final service = ref.read(prayerRemoteServiceProvider);
  final data = await service.getQiblaDirection(position.latitude, position.longitude);
  return (data['qibla_direction'] as num).toDouble();
});

/// Distance from user location to Kaaba in km.
final qiblaDistanceProvider = FutureProvider<double>((ref) async {
  final position = await ref.watch(locationProvider.future);
  const kaabaLat = 21.4225;
  const kaabaLng = 39.8262;
  const r = 6371.0; // Earth radius km
  final lat1 = position.latitude * pi / 180;
  final lat2 = kaabaLat * pi / 180;
  final dLat = (kaabaLat - position.latitude) * pi / 180;
  final dLng = (kaabaLng - position.longitude) * pi / 180;
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return r * c;
});

// ─── Compass heading from magnetometer ────────────────────────────────────────

/// Raw compass heading in degrees [0, 360), north = 0.
final compassHeadingProvider = StreamProvider<double>((ref) {
  final controller = StreamController<double>();

  final sub = magnetometerEventStream(
    samplingPeriod: SensorInterval.normalInterval,
  ).listen((MagnetometerEvent event) {
    // Simple 2D approximation (device flat / portrait)
    double heading = atan2(event.y, event.x) * (180 / pi);
    heading = (heading + 360) % 360;
    controller.add(heading);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
