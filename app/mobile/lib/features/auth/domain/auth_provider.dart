import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/app_user.dart';
import '../data/auth_service.dart';
import '../data/auth_remote_service.dart';

class AuthNotifier extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    final authService = ref.read(authServiceProvider);

    // 1. Cek JWT tersimpan — jika ada, verifikasi ke backend
    final token = await authService.getToken();
    if (token != null) {
      try {
        return await ref.read(authRemoteServiceProvider).getProfile();
      } catch (_) {
        // JWT expired/invalid — coba silent Google sign-in
        await authService.clearToken();
      }
    }

    // 2. Silent Google sign-in (jika user sudah pernah login)
    final idToken = await authService.silentSignIn();
    if (idToken == null) return null;

    try {
      final result =
          await ref.read(authRemoteServiceProvider).verifyToken(idToken);
      await authService.saveToken(result.token);
      return result.user;
    } catch (_) {
      return null;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncLoading();
    final authService = ref.read(authServiceProvider);

    final idToken = await authService.signInWithGoogle();
    if (idToken == null) {
      state = const AsyncData(null);
      return false;
    }

    try {
      final result =
          await ref.read(authRemoteServiceProvider).verifyToken(idToken);
      await authService.saveToken(result.token);
      state = AsyncData(result.user);
      return true;
    } catch (_) {
      state = const AsyncData(null);
      return false;
    }
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
    state = const AsyncData(null);
  }
}

final authProvider =
    AsyncNotifierProvider<AuthNotifier, AppUser?>(AuthNotifier.new);

/// True jika user sudah login
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).value != null;
});
