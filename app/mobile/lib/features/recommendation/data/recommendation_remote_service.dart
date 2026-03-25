import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

class RecommendationRemoteService {
  final ApiClient _client;
  RecommendationRemoteService(this._client);

  /// Ambil daftar kategori rekomendasi
  Future<List<Map<String, dynamic>>> getCategories() async {
    final res = await _client.dio.get('/recommendations');
    final list = res.data['data'] as List;
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  /// Ambil rekomendasi berdasarkan kategori
  Future<Map<String, dynamic>> getByCategory(String category) async {
    final res = await _client.dio.get('/recommendations/$category');
    return res.data['data'] as Map<String, dynamic>;
  }
}

final recommendationRemoteServiceProvider = Provider<RecommendationRemoteService>(
  (ref) => RecommendationRemoteService(ref.read(apiClientProvider)),
);
