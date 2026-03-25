import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../../features/quran/data/surah_model.dart';
import '../../features/quran/data/ayat_model.dart';

// Juz per surah (static, never changes)
const Map<int, int> surahJuzMap = {
  1: 1,  2: 1,  3: 3,  4: 4,  5: 6,  6: 7,  7: 8,  8: 9,  9: 10, 10: 11,
  11: 11,12: 12,13: 13,14: 13,15: 14,16: 14,17: 15,18: 15,19: 16,20: 16,
  21: 17,22: 17,23: 18,24: 18,25: 18,26: 19,27: 19,28: 20,29: 20,30: 21,
  31: 21,32: 21,33: 21,34: 22,35: 22,36: 22,37: 23,38: 23,39: 23,40: 24,
  41: 24,42: 25,43: 25,44: 25,45: 25,46: 26,47: 26,48: 26,49: 26,50: 26,
  51: 26,52: 27,53: 27,54: 27,55: 27,56: 27,57: 27,58: 28,59: 28,60: 28,
  61: 28,62: 28,63: 28,64: 28,65: 28,66: 28,67: 29,68: 29,69: 29,70: 29,
  71: 29,72: 29,73: 29,74: 29,75: 29,76: 29,77: 29,78: 30,79: 30,80: 30,
  81: 30,82: 30,83: 30,84: 30,85: 30,86: 30,87: 30,88: 30,89: 30,90: 30,
  91: 30,92: 30,93: 30,94: 30,95: 30,96: 30,97: 30,98: 30,99: 30,100:30,
  101:30,102:30,103:30,104:30,105:30,106:30,107:30,108:30,109:30,110:30,
  111:30,112:30,113:30,114:30,
};

class QuranApiService {
  final ApiClient _client;
  QuranApiService(this._client);

  /// Fetch all 114 surahs via backend (backend proxies to alquran.cloud + caches)
  Future<List<Surah>> fetchSurahList() async {
    final res = await _client.dio.get('/quran/surahs');
    final list = res.data['data'] as List;
    return list.map((e) => Surah(
      number: e['number'] as int,
      nameArabic: e['name'] as String,
      nameLatin: e['englishName'] as String,
      nameTranslation: e['englishNameTranslation'] as String,
      ayatCount: e['numberOfAyahs'] as int,
      type: (e['revelationType'] as String) == 'Meccan' ? 'Makkiyah' : 'Madaniyah',
      juz: surahJuzMap[e['number'] as int] ?? 1,
    )).toList();
  }

  /// Fetch ayat list: arabic (uthmani) + translation + audio via backend
  Future<List<Ayat>> fetchSurahAyat(int surahNumber) async {
    final res = await _client.dio.get(
      '/quran/surahs/$surahNumber/editions/quran-uthmani,id.indonesian,ar.alafasy',
    );
    final editions = res.data['data'] as List;

    final uthmani    = (editions[0]['ayahs'] as List);
    final indonesian = (editions[1]['ayahs'] as List);
    final alafasy    = (editions[2]['ayahs'] as List);

    return List.generate(uthmani.length, (i) {
      return Ayat(
        surahNumber: surahNumber,
        number: uthmani[i]['numberInSurah'] as int,
        arabic: uthmani[i]['text'] as String,
        translation: indonesian[i]['text'] as String,
        audioUrl: alafasy[i]['audio'] as String?,
      );
    });
  }

  /// Fetch tajweed text via backend
  Future<List<String>> fetchTajweedTexts(int surahNumber) async {
    final res = await _client.dio.get(
      '/quran/surahs/$surahNumber/edition/quran-tajweed',
    );
    final ayahs = res.data['data']['ayahs'] as List;
    return ayahs.map((e) => e['text'] as String).toList();
  }

  /// Fetch tafsir (Indonesian – Muntakhab) via backend (alquran.cloud)
  Future<List<String>> fetchTafsir(int surahNumber) async {
    final res = await _client.dio.get(
      '/quran/surahs/$surahNumber/edition/id.muntakhab',
    );
    final ayahs = res.data['data']['ayahs'] as List;
    return ayahs.map((e) => e['text'] as String).toList();
  }

  // ─── QuranAPI.dev (secondary source) ──────────────────────────────────────

  /// Fetch daftar qari yang tersedia (5 qari)
  Future<Map<String, String>> fetchReciters() async {
    final res = await _client.dio.get('/quran/reciters');
    final data = res.data['data'] as Map<String, dynamic>;
    return data.map((k, v) => MapEntry(k, v as String));
  }

  /// Fetch audio full-surah dari 5 qari
  Future<Map<String, ReciterAudio>> fetchSurahAudio(int surahNumber) async {
    final res = await _client.dio.get('/quran/surahs/$surahNumber/audio');
    final data = res.data['data'] as Map<String, dynamic>;
    return data.map((k, v) => MapEntry(k, ReciterAudio.fromJson(v)));
  }

  /// Fetch audio per-ayat dari 5 qari
  Future<Map<String, ReciterAudio>> fetchVerseAudio(int surahNumber, int ayah) async {
    final res = await _client.dio.get('/quran/surahs/$surahNumber/ayat/$ayah/audio');
    final data = res.data['data'] as Map<String, dynamic>;
    return data.map((k, v) => MapEntry(k, ReciterAudio.fromJson(v)));
  }

  /// Fetch tafsir per-ayat (Ibn Kathir, Maarif Ul Quran, Tazkirul Quran)
  Future<VerseTafsir> fetchVerseTafsir(int surahNumber, int ayah) async {
    final res = await _client.dio.get('/quran/surahs/$surahNumber/ayat/$ayah/tafsir');
    return VerseTafsir.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  /// Fetch tafsir seluruh surah
  Future<SurahTafsir> fetchSurahTafsir(int surahNumber) async {
    final res = await _client.dio.get('/quran/surahs/$surahNumber/tafsir');
    return SurahTafsir.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  /// Fetch data lengkap surah dari QuranAPI.dev (arabic1, arabic2, english, audio)
  Future<SurahFull> fetchSurahFull(int surahNumber) async {
    final res = await _client.dio.get('/quran/surahs/$surahNumber/full');
    return SurahFull.fromJson(res.data['data'] as Map<String, dynamic>);
  }
}

// ─── Models untuk QuranAPI.dev data ─────────────────────────────────────────

class ReciterAudio {
  final String reciter;
  final String url;
  final String originalUrl;

  const ReciterAudio({required this.reciter, required this.url, required this.originalUrl});

  factory ReciterAudio.fromJson(Map<String, dynamic> j) => ReciterAudio(
    reciter: j['reciter'] as String,
    url: j['url'] as String,
    originalUrl: j['originalUrl'] as String? ?? j['url'] as String,
  );
}

class TafsirEntry {
  final String author;
  final String? groupVerse;
  final String content;

  const TafsirEntry({required this.author, this.groupVerse, required this.content});

  factory TafsirEntry.fromJson(Map<String, dynamic> j) => TafsirEntry(
    author: j['author'] as String,
    groupVerse: j['groupVerse'] as String?,
    content: j['content'] as String,
  );
}

class VerseTafsir {
  final String surahName;
  final int surahNo;
  final int ayahNo;
  final List<TafsirEntry> tafsirs;

  const VerseTafsir({required this.surahName, required this.surahNo, required this.ayahNo, required this.tafsirs});

  factory VerseTafsir.fromJson(Map<String, dynamic> j) => VerseTafsir(
    surahName: j['surahName'] as String,
    surahNo: j['surahNo'] as int,
    ayahNo: j['ayahNo'] as int,
    tafsirs: (j['tafsirs'] as List).map((e) => TafsirEntry.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

class SurahTafsir {
  final String surahName;
  final int totalVerse;
  /// Nested: tafsirs[ayahIndex] = List<TafsirEntry>
  final List<List<TafsirEntry>> tafsirs;

  const SurahTafsir({required this.surahName, required this.totalVerse, required this.tafsirs});

  factory SurahTafsir.fromJson(Map<String, dynamic> j) => SurahTafsir(
    surahName: j['surahName'] as String,
    totalVerse: j['totalVerse'] as int,
    tafsirs: (j['tafsirs'] as List).map((ayahTafsirs) =>
      (ayahTafsirs as List).map((e) => TafsirEntry.fromJson(e as Map<String, dynamic>)).toList(),
    ).toList(),
  );
}

class SurahFull {
  final String surahName;
  final String surahNameArabic;
  final String surahNameArabicLong;
  final String surahNameTranslation;
  final String revelationPlace;
  final int totalAyah;
  final int surahNo;
  final Map<String, ReciterAudio> audio;
  final List<String> arabic1; // dengan harakat
  final List<String> arabic2; // tanpa harakat
  final List<String> english;

  const SurahFull({
    required this.surahName,
    required this.surahNameArabic,
    required this.surahNameArabicLong,
    required this.surahNameTranslation,
    required this.revelationPlace,
    required this.totalAyah,
    required this.surahNo,
    required this.audio,
    required this.arabic1,
    required this.arabic2,
    required this.english,
  });

  factory SurahFull.fromJson(Map<String, dynamic> j) {
    final audioMap = <String, ReciterAudio>{};
    final audioRaw = j['audio'] as Map<String, dynamic>? ?? {};
    for (final entry in audioRaw.entries) {
      audioMap[entry.key] = ReciterAudio.fromJson(entry.value as Map<String, dynamic>);
    }

    return SurahFull(
      surahName: j['surahName'] as String,
      surahNameArabic: j['surahNameArabic'] as String? ?? '',
      surahNameArabicLong: j['surahNameArabicLong'] as String? ?? '',
      surahNameTranslation: j['surahNameTranslation'] as String? ?? '',
      revelationPlace: j['revelationPlace'] as String? ?? '',
      totalAyah: j['totalAyah'] as int? ?? 0,
      surahNo: j['surahNo'] as int? ?? 0,
      audio: audioMap,
      arabic1: (j['arabic1'] as List?)?.map((e) => e as String).toList() ?? [],
      arabic2: (j['arabic2'] as List?)?.map((e) => e as String).toList() ?? [],
      english: (j['english'] as List?)?.map((e) => e as String).toList() ?? [],
    );
  }
}

final quranApiServiceProvider = Provider<QuranApiService>(
  (ref) => QuranApiService(ref.read(apiClientProvider)),
);
