class AppConfig {
  /// Inject via --dart-define=API_BASE_URL=http://192.168.x.x:8000/api/v1
  /// Defaults:
  ///   Android emulator → 10.0.2.2 (localhost mesin host)
  ///   iOS simulator / physical device → sesuaikan
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/v1',
  );
}
