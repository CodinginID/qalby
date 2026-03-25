import '../../features/playlist/data/playlist_model.dart';

class DummyPlaylists {
  DummyPlaylists._();

  static List<Playlist> get initial => [
        Playlist(
          id: 'pl_1',
          name: 'Juz Amma Harian',
          description: 'Target hafal Juz 30 dalam 30 hari',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          totalPracticed: 4,
          items: [
            PlaylistItem(id: 'i1', surahNumber: 114, surahName: 'An-Nas',    surahNameArabic: 'النَّاس',     ayatStart: 1, ayatEnd: 6,  order: 0),
            PlaylistItem(id: 'i2', surahNumber: 113, surahName: 'Al-Falaq',  surahNameArabic: 'الْفَلَق',    ayatStart: 1, ayatEnd: 5,  order: 1),
            PlaylistItem(id: 'i3', surahNumber: 112, surahName: 'Al-Ikhlas', surahNameArabic: 'الْإِخْلَاص', ayatStart: 1, ayatEnd: 4,  order: 2),
            PlaylistItem(id: 'i4', surahNumber: 111, surahName: 'Al-Masad',  surahNameArabic: 'الْمَسَد',    ayatStart: 1, ayatEnd: 5,  order: 3),
            PlaylistItem(id: 'i5', surahNumber: 110, surahName: 'An-Nasr',   surahNameArabic: 'النَّصْر',    ayatStart: 1, ayatEnd: 3,  order: 4),
            PlaylistItem(id: 'i6', surahNumber: 109, surahName: 'Al-Kafirun',surahNameArabic: 'الْكَافِرُون',ayatStart: 1, ayatEnd: 6,  order: 5),
            PlaylistItem(id: 'i7', surahNumber: 108, surahName: 'Al-Kautsar',surahNameArabic: 'الْكَوْثَر',  ayatStart: 1, ayatEnd: 3,  order: 6),
          ],
        ),
        Playlist(
          id: 'pl_2',
          name: 'Al-Fatihah & Pendek',
          description: 'Dasar hafalan untuk sholat sehari-hari',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          totalPracticed: 1,
          items: [
            PlaylistItem(id: 'i8',  surahNumber: 1,   surahName: 'Al-Fatihah', surahNameArabic: 'الْفَاتِحَة', ayatStart: 1, ayatEnd: 7,  order: 0),
            PlaylistItem(id: 'i9',  surahNumber: 112, surahName: 'Al-Ikhlas',  surahNameArabic: 'الْإِخْلَاص', ayatStart: 1, ayatEnd: 4,  order: 1),
            PlaylistItem(id: 'i10', surahNumber: 103, surahName: 'Al-Asr',     surahNameArabic: 'الْعَصْر',    ayatStart: 1, ayatEnd: 3,  order: 2),
          ],
        ),
        Playlist(
          id: 'pl_3',
          name: 'Surah Pilihan',
          description: 'Koleksi surah yang sering dibaca',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          totalPracticed: 0,
          items: [
            PlaylistItem(id: 'i11', surahNumber: 105, surahName: 'Al-Fil',    surahNameArabic: 'الْفِيل',   ayatStart: 1, ayatEnd: 5, order: 0),
            PlaylistItem(id: 'i12', surahNumber: 106, surahName: 'Quraisy',   surahNameArabic: 'قُرَيْش',   ayatStart: 1, ayatEnd: 4, order: 1),
            PlaylistItem(id: 'i13', surahNumber: 108, surahName: 'Al-Kautsar',surahNameArabic: 'الْكَوْثَر', ayatStart: 1, ayatEnd: 3, order: 2),
          ],
        ),
      ];
}
