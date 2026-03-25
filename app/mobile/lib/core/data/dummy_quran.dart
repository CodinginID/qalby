import '../../features/quran/data/surah_model.dart';
import '../../features/quran/data/ayat_model.dart';

class DummyQuran {
  DummyQuran._();

  static const List<Surah> surahs = [
    Surah(number: 1,   nameArabic: 'الْفَاتِحَة',    nameLatin: 'Al-Fatihah',    nameTranslation: 'Pembukaan',       ayatCount: 7,   type: 'Makkiyah', juz: 1),
    Surah(number: 2,   nameArabic: 'الْبَقَرَة',      nameLatin: 'Al-Baqarah',    nameTranslation: 'Sapi Betina',     ayatCount: 286, type: 'Madaniyah', juz: 1),
    Surah(number: 3,   nameArabic: 'آلِ عِمْرَان',    nameLatin: 'Ali Imran',     nameTranslation: 'Keluarga Imran',  ayatCount: 200, type: 'Madaniyah', juz: 3),
    Surah(number: 4,   nameArabic: 'النِّسَاء',       nameLatin: 'An-Nisa\'',     nameTranslation: 'Wanita',          ayatCount: 176, type: 'Madaniyah', juz: 4),
    Surah(number: 5,   nameArabic: 'الْمَائِدَة',     nameLatin: 'Al-Ma\'idah',   nameTranslation: 'Hidangan',        ayatCount: 120, type: 'Madaniyah', juz: 6),
    Surah(number: 6,   nameArabic: 'الْأَنْعَام',     nameLatin: 'Al-An\'am',     nameTranslation: 'Binatang Ternak', ayatCount: 165, type: 'Makkiyah', juz: 7),
    Surah(number: 7,   nameArabic: 'الْأَعْرَاف',     nameLatin: 'Al-A\'raf',     nameTranslation: 'Tempat Tertinggi',ayatCount: 206, type: 'Makkiyah', juz: 8),
    Surah(number: 8,   nameArabic: 'الْأَنْفَال',     nameLatin: 'Al-Anfal',      nameTranslation: 'Rampasan Perang', ayatCount: 75,  type: 'Madaniyah', juz: 9),
    Surah(number: 9,   nameArabic: 'التَّوْبَة',      nameLatin: 'At-Taubah',     nameTranslation: 'Pertobatan',      ayatCount: 129, type: 'Madaniyah', juz: 10),
    Surah(number: 10,  nameArabic: 'يُونُس',          nameLatin: 'Yunus',         nameTranslation: 'Nabi Yunus',      ayatCount: 109, type: 'Makkiyah', juz: 11),
    Surah(number: 18,  nameArabic: 'الْكَهْف',        nameLatin: 'Al-Kahf',       nameTranslation: 'Gua',             ayatCount: 110, type: 'Makkiyah', juz: 15),
    Surah(number: 19,  nameArabic: 'مَرْيَم',         nameLatin: 'Maryam',        nameTranslation: 'Maryam',          ayatCount: 98,  type: 'Makkiyah', juz: 16),
    Surah(number: 36,  nameArabic: 'يس',              nameLatin: 'Ya-Sin',        nameTranslation: 'Ya Sin',          ayatCount: 83,  type: 'Makkiyah', juz: 22),
    Surah(number: 55,  nameArabic: 'الرَّحْمَن',      nameLatin: 'Ar-Rahman',     nameTranslation: 'Yang Maha Pemurah',ayatCount: 78, type: 'Madaniyah', juz: 27),
    Surah(number: 56,  nameArabic: 'الْوَاقِعَة',     nameLatin: 'Al-Waqi\'ah',   nameTranslation: 'Hari Kiamat',     ayatCount: 96,  type: 'Makkiyah', juz: 27),
    Surah(number: 67,  nameArabic: 'الْمُلْك',        nameLatin: 'Al-Mulk',       nameTranslation: 'Kerajaan',        ayatCount: 30,  type: 'Makkiyah', juz: 29),
    Surah(number: 78,  nameArabic: 'النَّبَأ',        nameLatin: 'An-Naba\'',     nameTranslation: 'Berita Besar',    ayatCount: 40,  type: 'Makkiyah', juz: 30),
    Surah(number: 99,  nameArabic: 'الزَّلْزَلَة',    nameLatin: 'Az-Zalzalah',   nameTranslation: 'Kegoncangan',     ayatCount: 8,   type: 'Madaniyah', juz: 30),
    Surah(number: 100, nameArabic: 'الْعَادِيَات',    nameLatin: 'Al-\'Adiyat',   nameTranslation: 'Kuda Perang',     ayatCount: 11,  type: 'Makkiyah', juz: 30),
    Surah(number: 101, nameArabic: 'الْقَارِعَة',     nameLatin: 'Al-Qari\'ah',   nameTranslation: 'Hari Kiamat',     ayatCount: 11,  type: 'Makkiyah', juz: 30),
    Surah(number: 102, nameArabic: 'التَّكَاثُر',     nameLatin: 'At-Takatsur',   nameTranslation: 'Bermegah-megahan',ayatCount: 8,   type: 'Makkiyah', juz: 30),
    Surah(number: 103, nameArabic: 'الْعَصْر',        nameLatin: 'Al-\'Asr',      nameTranslation: 'Masa',            ayatCount: 3,   type: 'Makkiyah', juz: 30),
    Surah(number: 104, nameArabic: 'الْهُمَزَة',      nameLatin: 'Al-Humazah',    nameTranslation: 'Pengumpat',       ayatCount: 9,   type: 'Makkiyah', juz: 30),
    Surah(number: 105, nameArabic: 'الْفِيل',         nameLatin: 'Al-Fil',        nameTranslation: 'Gajah',           ayatCount: 5,   type: 'Makkiyah', juz: 30),
    Surah(number: 106, nameArabic: 'قُرَيْش',         nameLatin: 'Quraisy',       nameTranslation: 'Suku Quraisy',    ayatCount: 4,   type: 'Makkiyah', juz: 30),
    Surah(number: 107, nameArabic: 'الْمَاعُون',      nameLatin: 'Al-Ma\'un',     nameTranslation: 'Barang Berguna',  ayatCount: 7,   type: 'Makkiyah', juz: 30),
    Surah(number: 108, nameArabic: 'الْكَوْثَر',      nameLatin: 'Al-Kautsar',    nameTranslation: 'Nikmat Yang Banyak',ayatCount: 3, type: 'Makkiyah', juz: 30),
    Surah(number: 109, nameArabic: 'الْكَافِرُون',    nameLatin: 'Al-Kafirun',    nameTranslation: 'Orang-orang Kafir',ayatCount: 6,  type: 'Makkiyah', juz: 30),
    Surah(number: 110, nameArabic: 'النَّصْر',        nameLatin: 'An-Nasr',       nameTranslation: 'Pertolongan',     ayatCount: 3,   type: 'Madaniyah', juz: 30),
    Surah(number: 111, nameArabic: 'الْمَسَد',        nameLatin: 'Al-Masad',      nameTranslation: 'Sabut',           ayatCount: 5,   type: 'Makkiyah', juz: 30),
    Surah(number: 112, nameArabic: 'الْإِخْلَاص',     nameLatin: 'Al-Ikhlas',     nameTranslation: 'Kemurnian Iman',  ayatCount: 4,   type: 'Makkiyah', juz: 30),
    Surah(number: 113, nameArabic: 'الْفَلَق',        nameLatin: 'Al-Falaq',      nameTranslation: 'Waktu Subuh',     ayatCount: 5,   type: 'Makkiyah', juz: 30),
    Surah(number: 114, nameArabic: 'النَّاس',         nameLatin: 'An-Nas',        nameTranslation: 'Manusia',         ayatCount: 6,   type: 'Makkiyah', juz: 30),
  ];

  static const Map<int, List<Ayat>> ayatBySurah = {
    // Al-Fatihah
    1: [
      Ayat(surahNumber: 1, number: 1, arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ', translation: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.'),
      Ayat(surahNumber: 1, number: 2, arabic: 'اَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَۙ', translation: 'Segala puji bagi Allah, Tuhan seluruh alam,'),
      Ayat(surahNumber: 1, number: 3, arabic: 'الرَّحْمٰنِ الرَّحِيْمِۙ', translation: 'Yang Maha Pengasih, Maha Penyayang,'),
      Ayat(surahNumber: 1, number: 4, arabic: 'مٰلِكِ يَوْمِ الدِّيْنِۗ', translation: 'Pemilik hari pembalasan.'),
      Ayat(surahNumber: 1, number: 5, arabic: 'اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِيْنُۗ', translation: 'Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami mohon pertolongan.'),
      Ayat(surahNumber: 1, number: 6, arabic: 'اِهْدِنَا الصِّرَاطَ الْمُسْتَقِيْمَۙ', translation: 'Tunjukilah kami jalan yang lurus,'),
      Ayat(surahNumber: 1, number: 7, arabic: 'صِرَاطَ الَّذِيْنَ اَنْعَمْتَ عَلَيْهِمْ ەۙ غَيْرِ الْمَغْضُوْبِ عَلَيْهِمْ وَلَا الضَّاۤلِّيْنَ', translation: '(yaitu) jalan orang-orang yang telah Engkau beri nikmat kepadanya; bukan (jalan) mereka yang dimurkai, dan bukan (pula jalan) mereka yang sesat.'),
    ],
    // Al-Ikhlas
    112: [
      Ayat(surahNumber: 112, number: 1, arabic: 'قُلْ هُوَ اللّٰهُ اَحَدٌۚ', translation: 'Katakanlah (Muhammad), "Dialah Allah, Yang Maha Esa.'),
      Ayat(surahNumber: 112, number: 2, arabic: 'اَللّٰهُ الصَّمَدُۚ', translation: 'Allah tempat meminta segala sesuatu.'),
      Ayat(surahNumber: 112, number: 3, arabic: 'لَمْ يَلِدْ وَلَمْ يُوْلَدْۙ', translation: '(Allah) tidak beranak dan tidak pula diperanakkan.'),
      Ayat(surahNumber: 112, number: 4, arabic: 'وَلَمْ يَكُنْ لَّهٗ كُفُوًا اَحَدٌ', translation: 'Dan tidak ada sesuatu yang setara dengan Dia."'),
    ],
    // Al-Falaq
    113: [
      Ayat(surahNumber: 113, number: 1, arabic: 'قُلْ اَعُوْذُ بِرَبِّ الْفَلَقِۙ', translation: 'Katakanlah, "Aku berlindung kepada Tuhan yang menguasai subuh (fajar),'),
      Ayat(surahNumber: 113, number: 2, arabic: 'مِنْ شَرِّ مَا خَلَقَۙ', translation: 'dari kejahatan (makhluk yang) Dia ciptakan,'),
      Ayat(surahNumber: 113, number: 3, arabic: 'وَمِنْ شَرِّ غَاسِقٍ اِذَا وَقَبَۙ', translation: 'dan dari kejahatan malam apabila telah gelap gulita,'),
      Ayat(surahNumber: 113, number: 4, arabic: 'وَمِنْ شَرِّ النَّفّٰثٰتِ فِى الْعُقَدِۙ', translation: 'dan dari kejahatan (perempuan-perempuan) penyihir yang meniup pada buhul-buhul (talinya),'),
      Ayat(surahNumber: 113, number: 5, arabic: 'وَمِنْ شَرِّ حَاسِدٍ اِذَا حَسَدَ', translation: 'dan dari kejahatan orang yang dengki apabila dia dengki."'),
    ],
    // An-Nas
    114: [
      Ayat(surahNumber: 114, number: 1, arabic: 'قُلْ اَعُوْذُ بِرَبِّ النَّاسِۙ', translation: 'Katakanlah, "Aku berlindung kepada Tuhannya manusia,'),
      Ayat(surahNumber: 114, number: 2, arabic: 'مَلِكِ النَّاسِۙ', translation: 'Raja manusia,'),
      Ayat(surahNumber: 114, number: 3, arabic: 'اِلٰهِ النَّاسِۙ', translation: 'Sembahan manusia,'),
      Ayat(surahNumber: 114, number: 4, arabic: 'مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِۙ', translation: 'dari kejahatan (bisikan) setan yang bersembunyi,'),
      Ayat(surahNumber: 114, number: 5, arabic: 'الَّذِيْ يُوَسْوِسُ فِيْ صُدُوْرِ النَّاسِۙ', translation: 'yang membisikkan (kejahatan) ke dalam dada manusia,'),
      Ayat(surahNumber: 114, number: 6, arabic: 'مِنَ الْجِنَّةِ وَالنَّاسِ', translation: 'dari (golongan) jin dan manusia."'),
    ],
    // Al-Kautsar
    108: [
      Ayat(surahNumber: 108, number: 1, arabic: 'اِنَّآ اَعْطَيْنٰكَ الْكَوْثَرَۗ', translation: 'Sungguh, Kami telah memberimu (Muhammad) nikmat yang banyak.'),
      Ayat(surahNumber: 108, number: 2, arabic: 'فَصَلِّ لِرَبِّكَ وَانْحَرْۗ', translation: 'Maka laksanakanlah shalat karena Tuhanmu, dan berkurbanlah (sebagai ibadah dan mendekatkan diri kepada Allah).'),
      Ayat(surahNumber: 108, number: 3, arabic: 'اِنَّ شَانِئَكَ هُوَ الْاَبْتَرُ', translation: 'Sungguh, orang-orang yang membencimu dialah yang terputus (dari rahmat Allah).'),
    ],
    // Al-Asr
    103: [
      Ayat(surahNumber: 103, number: 1, arabic: 'وَالْعَصْرِۙ', translation: 'Demi masa,'),
      Ayat(surahNumber: 103, number: 2, arabic: 'اِنَّ الْاِنْسَانَ لَفِيْ خُسْرٍۙ', translation: 'sungguh, manusia berada dalam kerugian,'),
      Ayat(surahNumber: 103, number: 3, arabic: 'اِلَّا الَّذِيْنَ اٰمَنُوْا وَعَمِلُوا الصّٰلِحٰتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ', translation: 'kecuali orang-orang yang beriman dan mengerjakan kebajikan serta saling menasihati untuk kebenaran dan saling menasihati untuk kesabaran.'),
    ],
    // Al-Fil
    105: [
      Ayat(surahNumber: 105, number: 1, arabic: 'اَلَمْ تَرَ كَيْفَ فَعَلَ رَبُّكَ بِاَصْحٰبِ الْفِيْلِۗ', translation: 'Tidakkah engkau (Muhammad) perhatikan bagaimana Tuhanmu telah bertindak terhadap pasukan bergajah?'),
      Ayat(surahNumber: 105, number: 2, arabic: 'اَلَمْ يَجْعَلْ كَيْدَهُمْ فِيْ تَضْلِيْلٍۙ', translation: 'Bukankah Dia telah menjadikan tipu daya mereka itu sia-sia?'),
      Ayat(surahNumber: 105, number: 3, arabic: 'وَاَرْسَلَ عَلَيْهِمْ طَيْرًا اَبَابِيْلَۙ', translation: 'dan Dia mengirimkan kepada mereka burung yang berbondong-bondong,'),
      Ayat(surahNumber: 105, number: 4, arabic: 'تَرْمِيْهِمْ بِحِجَارَةٍ مِّنْ سِجِّيْلٍۙ', translation: 'yang melempari mereka dengan batu dari tanah liat yang dibakar,'),
      Ayat(surahNumber: 105, number: 5, arabic: 'فَجَعَلَهُمْ كَعَصْفٍ مَّأْكُوْلٍ', translation: 'sehingga mereka dijadikan-Nya seperti daun-daun yang dimakan (ulat).'),
    ],
    // Al-Kafirun
    109: [
      Ayat(surahNumber: 109, number: 1, arabic: 'قُلْ يٰٓاَيُّهَا الْكٰفِرُوْنَۙ', translation: 'Katakanlah (Muhammad), "Wahai orang-orang kafir!'),
      Ayat(surahNumber: 109, number: 2, arabic: 'لَآ اَعْبُدُ مَا تَعْبُدُوْنَۙ', translation: 'Aku tidak akan menyembah apa yang kamu sembah,'),
      Ayat(surahNumber: 109, number: 3, arabic: 'وَلَآ اَنْتُمْ عٰبِدُوْنَ مَآ اَعْبُدُۚ', translation: 'dan kamu bukan penyembah apa yang aku sembah,'),
      Ayat(surahNumber: 109, number: 4, arabic: 'وَلَآ اَنَا۠ عَابِدٌ مَّا عَبَدتُّمْۙ', translation: 'dan aku tidak pernah menjadi penyembah apa yang kamu sembah,'),
      Ayat(surahNumber: 109, number: 5, arabic: 'وَلَآ اَنْتُمْ عٰبِدُوْنَ مَآ اَعْبُدُۗ', translation: 'dan kamu tidak pernah (pula) menjadi penyembah apa yang aku sembah.'),
      Ayat(surahNumber: 109, number: 6, arabic: 'لَكُمْ دِيْنُكُمْ وَلِيَ دِيْنِ', translation: 'Untukmu agamamu, dan untukku agamaku."'),
    ],
    // An-Nasr
    110: [
      Ayat(surahNumber: 110, number: 1, arabic: 'اِذَا جَاۤءَ نَصْرُ اللّٰهِ وَالْفَتْحُۙ', translation: 'Apabila telah datang pertolongan Allah dan kemenangan,'),
      Ayat(surahNumber: 110, number: 2, arabic: 'وَرَاَيْتَ النَّاسَ يَدْخُلُوْنَ فِيْ دِيْنِ اللّٰهِ اَفْوَاجًاۙ', translation: 'dan engkau melihat manusia berbondong-bondong masuk agama Allah,'),
      Ayat(surahNumber: 110, number: 3, arabic: 'فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ ۗاِنَّهٗ كَانَ تَوَّابًا', translation: 'maka bertasbihlah dengan memuji Tuhanmu dan mohonlah ampunan kepada-Nya. Sungguh, Dia Maha Penerima tobat.'),
    ],
    // Quraisy
    106: [
      Ayat(surahNumber: 106, number: 1, arabic: 'لِاِيْلٰفِ قُرَيْشٍۙ', translation: 'Karena kebiasaan orang-orang Quraisy,'),
      Ayat(surahNumber: 106, number: 2, arabic: 'اٖلٰفِهِمْ رِحْلَةَ الشِّتَاۤءِ وَالصَّيْفِۚ', translation: '(yaitu) kebiasaan mereka bepergian pada musim dingin dan musim panas.'),
      Ayat(surahNumber: 106, number: 3, arabic: 'فَلْيَعْبُدُوْا رَبَّ هٰذَا الْبَيْتِۙ', translation: 'Maka hendaklah mereka menyembah Tuhan (pemilik) rumah ini (Ka\'bah),'),
      Ayat(surahNumber: 106, number: 4, arabic: 'الَّذِيْٓ اَطْعَمَهُمْ مِّنْ جُوْعٍ ەۙ وَّاٰمَنَهُمْ مِّنْ خَوْفٍ', translation: 'yang telah memberi makan kepada mereka untuk menghilangkan lapar dan mengamankan mereka dari rasa ketakutan.'),
    ],
  };

  static List<Ayat> getAyat(int surahNumber) {
    if (ayatBySurah.containsKey(surahNumber)) {
      return ayatBySurah[surahNumber]!;
    }
    // Generate placeholder untuk surah yang belum ada teks lengkapnya
    final surah = surahs.firstWhere(
      (s) => s.number == surahNumber,
      orElse: () => const Surah(number: 0, nameArabic: '', nameLatin: '', nameTranslation: '', ayatCount: 1, type: '', juz: 1),
    );
    return List.generate(
      surah.ayatCount,
      (i) => Ayat(
        surahNumber: surahNumber,
        number: i + 1,
        arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ ۝${i + 1}',
        translation: 'Terjemahan ayat ${i + 1} dari surah ${surah.nameLatin} (akan diisi dari API).',
      ),
    );
  }
}
