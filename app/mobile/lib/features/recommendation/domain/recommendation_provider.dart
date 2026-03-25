import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/recommendation_remote_service.dart';

/// Daftar kategori rekomendasi dari backend
final recommendationCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.read(recommendationRemoteServiceProvider);
  return await service.getCategories();
});

/// Rekomendasi berdasarkan kategori
final recommendationByCategoryProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, category) async {
  final service = ref.read(recommendationRemoteServiceProvider);
  return await service.getByCategory(category);
});
