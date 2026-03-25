import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  static const _storage = FlutterSecureStorage();
  static const _jwtKey = 'jwt_token';

  /// Sign in with Google → return Google ID token (dikirim ke backend)
  Future<String?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null; // user cancel
      final auth = await account.authentication;
      return auth.idToken;
    } catch (e) {
      // ignore: avoid_print
      print('[AuthService] signInWithGoogle error: $e');
      return null;
    }
  }

  /// Silent sign-in saat JWT expired — tidak tampilkan picker
  Future<String?> silentSignIn() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account == null) return null;
      final auth = await account.authentication;
      return auth.idToken;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveToken(String token) =>
      _storage.write(key: _jwtKey, value: token);

  Future<String?> getToken() => _storage.read(key: _jwtKey);

  Future<void> clearToken() => _storage.delete(key: _jwtKey);

  Future<void> signOut() async {
    await Future.wait([
      _googleSignIn.signOut(),
      clearToken(),
    ]);
  }
}

final authServiceProvider = Provider<AuthService>((_) => AuthService());
