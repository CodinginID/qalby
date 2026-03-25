import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/surah_model.dart';
import '../data/ayat_model.dart';
import '../../../core/data/dummy_quran.dart';
import '../../../core/services/quran_api_service.dart';

// ─── Surah list ───────────────────────────────────────────────────────────────
// Fetches all 114 surahs from API; falls back to dummy on error.

final surahListAsyncProvider = FutureProvider<List<Surah>>((ref) async {
  try {
    return await ref.read(quranApiServiceProvider).fetchSurahList();
  } catch (_) {
    return DummyQuran.surahs;
  }
});

// Synchronous search over async list — safe to call from UI
final surahSearchProvider = Provider.family<List<Surah>, String>((ref, query) {
  final asyncSurahs = ref.watch(surahListAsyncProvider);
  final surahs = asyncSurahs.value ?? DummyQuran.surahs;
  if (query.isEmpty) return surahs;
  final q = query.toLowerCase();
  return surahs.where((s) =>
      s.nameLatin.toLowerCase().contains(q) ||
      s.nameArabic.contains(q) ||
      s.number.toString() == q).toList();
});

final surahByNumberProvider = Provider.family<Surah?, int>((ref, number) {
  final asyncSurahs = ref.watch(surahListAsyncProvider);
  final surahs = asyncSurahs.value ?? DummyQuran.surahs;
  try {
    return surahs.firstWhere((s) => s.number == number);
  } catch (_) {
    return null;
  }
});

// ─── Ayat list ────────────────────────────────────────────────────────────────
// Fetches Arabic (uthmani) + Indonesian translation + audio URL.

final ayatListProvider = FutureProvider.family<List<Ayat>, int>((ref, surahNumber) async {
  try {
    return await ref.read(quranApiServiceProvider).fetchSurahAyat(surahNumber);
  } catch (_) {
    return DummyQuran.getAyat(surahNumber);
  }
});

// ─── Tajweed texts ────────────────────────────────────────────────────────────
// Loaded lazily when user enables tajweed mode.

final tajweedProvider = FutureProvider.family<List<String>, int>((ref, surahNumber) async {
  return await ref.read(quranApiServiceProvider).fetchTajweedTexts(surahNumber);
});

// ─── Tafsir ───────────────────────────────────────────────────────────────────
// Loaded lazily when user opens Tafsir tab.

final tafsirProvider = FutureProvider.family<List<String>, int>((ref, surahNumber) async {
  return await ref.read(quranApiServiceProvider).fetchTafsir(surahNumber);
});

// Backward-compat alias used in practice/add-ayat pages
final ayatListCompatProvider = Provider.family<List<Ayat>, int>((ref, surahNumber) {
  return ref.watch(ayatListProvider(surahNumber)).value ??
      DummyQuran.getAyat(surahNumber);
});

// ─── QuranAPI.dev providers (secondary source) ──────────────────────────────

/// Daftar 5 qari yang tersedia
final recitersProvider = FutureProvider<Map<String, String>>((ref) async {
  return await ref.read(quranApiServiceProvider).fetchReciters();
});

/// Audio full-surah dari 5 qari
final surahAudioProvider =
    FutureProvider.family<Map<String, ReciterAudio>, int>((ref, surahNumber) async {
  return await ref.read(quranApiServiceProvider).fetchSurahAudio(surahNumber);
});

/// Audio per-ayat dari 5 qari — param = "surahNo:ayahNo"
final verseAudioProvider =
    FutureProvider.family<Map<String, ReciterAudio>, ({int surah, int ayah})>((ref, param) async {
  return await ref.read(quranApiServiceProvider).fetchVerseAudio(param.surah, param.ayah);
});

/// Tafsir per-ayat (Ibn Kathir, Maarif Ul Quran, Tazkirul Quran)
final verseTafsirProvider =
    FutureProvider.family<VerseTafsir, ({int surah, int ayah})>((ref, param) async {
  return await ref.read(quranApiServiceProvider).fetchVerseTafsir(param.surah, param.ayah);
});

/// Tafsir seluruh surah
final surahTafsirProvider =
    FutureProvider.family<SurahTafsir, int>((ref, surahNumber) async {
  return await ref.read(quranApiServiceProvider).fetchSurahTafsir(surahNumber);
});

/// Data lengkap surah (arabic1, arabic2, english, audio 5 qari)
final surahFullProvider =
    FutureProvider.family<SurahFull, int>((ref, surahNumber) async {
  return await ref.read(quranApiServiceProvider).fetchSurahFull(surahNumber);
});
