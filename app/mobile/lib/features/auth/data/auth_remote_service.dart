import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import 'app_user.dart';

class AuthRemoteService {
  final ApiClient _client;
  AuthRemoteService(this._client);

  /// Kirim Google ID token ke backend → backend verifikasi + return JWT & user
  Future<({String token, AppUser user})> verifyToken(String idToken) async {
    final res = await _client.dio.post(
      '/auth/verify-token',
      data: {'id_token': idToken},
    );
    final data = res.data['data'] as Map<String, dynamic>;
    return (
      token: data['token'] as String,
      user: AppUser.fromJson(data['user'] as Map<String, dynamic>),
    );
  }

  /// Ambil profil user dari backend menggunakan JWT yang sudah tersimpan
  Future<AppUser> getProfile() async {
    final res = await _client.dio.get('/auth/profile');
    return AppUser.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  /// Update profil user
  Future<AppUser> updateProfile({
    String? displayName,
    String? photoUrl,
    String? fcmToken,
  }) async {
    final res = await _client.dio.put('/auth/profile', data: {
      if (displayName != null) 'display_name': displayName,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (fcmToken != null) 'fcm_token': fcmToken,
    });
    return AppUser.fromJson(res.data['data'] as Map<String, dynamic>);
  }
}

final authRemoteServiceProvider = Provider<AuthRemoteService>(
  (ref) => AuthRemoteService(ref.read(apiClientProvider)),
);
