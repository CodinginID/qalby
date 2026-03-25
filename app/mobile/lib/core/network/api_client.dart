import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_config.dart';

class ApiErrorNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? value) => state = value;
  void clear() => state = null;
}

final apiErrorProvider =
    NotifierProvider<ApiErrorNotifier, String?>(ApiErrorNotifier.new);

class ApiClient {
  late final Dio dio;
  final void Function(String)? onNetworkError;
  static const _storage = FlutterSecureStorage();
  static const _jwtKey = 'jwt_token';

  ApiClient({this.onNetworkError}) {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: _jwtKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // JWT invalid/expired — hapus token, user perlu login ulang
          await _storage.delete(key: _jwtKey);
        }
        onNetworkError?.call(_errorMessage(error));
        return handler.next(error);
      },
    ));
  }

  String _errorMessage(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Koneksi timeout. Periksa jaringan Anda.';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Tidak ada koneksi internet.';
    }
    final status = error.response?.statusCode;
    if (status != null && status >= 500) return 'Server sedang bermasalah.';
    return 'Terjadi kesalahan jaringan.';
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(
      onNetworkError: (msg) => ref.read(apiErrorProvider.notifier).set(msg),
    ));
