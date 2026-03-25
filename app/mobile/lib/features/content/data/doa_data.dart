import 'content_models.dart';

class DoaData {
  DoaData._();

  static const List<String> categories = [
    'Semua', 'Bangun Tidur', 'Makan & Minum', 'Perjalanan',
    'Rumah', 'Masjid', 'Wudhu', 'Sholat', 'Sebelum Tidur',
  ];

  static const List<Doa> doas = [
    // Bangun Tidur
    Doa(
      name: 'Bangun Tidur',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      latin: 'Alhamdulillahil-ladzi ahyaanaa ba\'da maa amaatanaa wa ilaihin-nusyuur',
      translation: 'Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami, dan kepada-Nya kami dibangkitkan.',
      source: 'HR. Bukhari No. 6312',
      category: 'Bangun Tidur',
    ),

    // Sebelum Tidur
    Doa(
      name: 'Sebelum Tidur',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      latin: 'Bismika allaahumma amuutu wa ahyaa',
      translation: 'Dengan nama-Mu ya Allah, aku mati dan aku hidup.',
      source: 'HR. Bukhari No. 6311',
      category: 'Sebelum Tidur',
    ),
    Doa(
      name: 'Doa Sebelum Tidur (Lengkap)',
      arabic: 'اللَّهُمَّ بِاسْمِكَ أَحْيَا وَبِاسْمِكَ أَمُوتُ',
      latin: 'Allaahumma bismika ahyaa wa bismika amuut',
      translation: 'Ya Allah, dengan nama-Mu aku hidup dan dengan nama-Mu aku mati.',
      source: 'HR. Bukhari No. 6325',
      category: 'Sebelum Tidur',
    ),

    // Makan & Minum
    Doa(
      name: 'Sebelum Makan',
      arabic: 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
      latin: 'Bismillaahi wa \'alaa barakatillaah',
      translation: 'Dengan nama Allah dan atas berkah Allah.',
      source: 'HR. Abu Dawud No. 3767',
      category: 'Makan & Minum',
    ),
    Doa(
      name: 'Sesudah Makan',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
      latin: 'Alhamdulillaahil-ladzii ath\'amanaa wa saqaanaa wa ja\'alanaa muslimiin',
      translation: 'Segala puji bagi Allah yang telah memberi kami makan, memberi kami minum, dan menjadikan kami muslim.',
      source: 'HR. Abu Dawud No. 3850',
      category: 'Makan & Minum',
    ),
    Doa(
      name: 'Lupa Baca Bismillah Saat Makan',
      arabic: 'بِسْمِ اللَّهِ أَوَّلَهُ وَآخِرَهُ',
      latin: 'Bismillaahi awwalahu wa aakhirahu',
      translation: 'Dengan nama Allah pada awal dan akhirnya.',
      source: 'HR. Abu Dawud No. 3767',
      category: 'Makan & Minum',
    ),

    // Perjalanan
    Doa(
      name: 'Keluar Rumah',
      arabic: 'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      latin: 'Bismillaahi tawakkaltu \'alallaaah, laa hawla wa laa quwwata illaa billaah',
      translation: 'Dengan nama Allah, aku bertawakal kepada Allah. Tidak ada daya dan kekuatan kecuali dengan Allah.',
      source: 'HR. Abu Dawud No. 5095',
      category: 'Perjalanan',
    ),
    Doa(
      name: 'Masuk Rumah',
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلَجِ وَخَيْرَ الْمَخْرَجِ',
      latin: 'Allaahumma innii as\'aluka khayral-mawlaji wa khayral-makhraji',
      translation: 'Ya Allah, sesungguhnya aku mohon kepada-Mu kebaikan tempat masuk dan kebaikan tempat keluar.',
      source: 'HR. Abu Dawud No. 5096',
      category: 'Rumah',
    ),
    Doa(
      name: 'Naik Kendaraan',
      arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ',
      latin: 'Subhaanal-ladzii sakhkhara lanaa haadzaa wa maa kunnaa lahu muqriniin',
      translation: 'Maha Suci Dzat yang telah menundukkan semua ini bagi kami padahal kami sebelumnya tidak mampu menguasainya.',
      source: 'QS. Az-Zukhruf: 13 | HR. Muslim No. 1342',
      category: 'Perjalanan',
    ),

    // Masjid
    Doa(
      name: 'Masuk Masjid',
      arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      latin: 'Allaahummaf-tah lii abwaaba rahmatik',
      translation: 'Ya Allah, bukakanlah bagiku pintu-pintu rahmat-Mu.',
      source: 'HR. Muslim No. 713',
      category: 'Masjid',
    ),
    Doa(
      name: 'Keluar Masjid',
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
      latin: 'Allaahumma innii as\'aluka min fadhlika',
      translation: 'Ya Allah, sesungguhnya aku memohon kepada-Mu sebagian dari karunia-Mu.',
      source: 'HR. Muslim No. 713',
      category: 'Masjid',
    ),

    // Wudhu
    Doa(
      name: 'Sebelum Wudhu',
      arabic: 'بِسْمِ اللَّهِ',
      latin: 'Bismillaah',
      translation: 'Dengan nama Allah.',
      source: 'HR. Abu Dawud No. 101',
      category: 'Wudhu',
    ),
    Doa(
      name: 'Setelah Wudhu',
      arabic: 'أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      latin: 'Asyhadu allaa ilaaha illallaahu wahdahu laa syariika lahu wa asyhadu anna muhammadan \'abduhu wa rasuuluh',
      translation: 'Aku bersaksi bahwa tidak ada sesembahan yang berhak disembah selain Allah, tiada sekutu bagi-Nya, dan aku bersaksi bahwa Muhammad adalah hamba dan utusan-Nya.',
      source: 'HR. Muslim No. 234',
      category: 'Wudhu',
    ),

    // Sholat
    Doa(
      name: 'Iftitah',
      arabic: 'اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ',
      latin: 'Allaahumma baa\'id bainii wa baina khathaa yaaya kamaa baa\'adta bainal-masyriqi wal-maghrib',
      translation: 'Ya Allah, jauhkanlah aku dari dosa-dosaku sebagaimana Engkau telah menjauhkan timur dan barat.',
      source: 'HR. Bukhari No. 744',
      category: 'Sholat',
    ),
    Doa(
      name: 'Qunut Subuh',
      arabic: 'اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ وَعَافِنِي فِيمَنْ عَافَيْتَ',
      latin: 'Allaahummah-dinii fiiman hadayt, wa \'aafinii fiiman \'aafayt',
      translation: 'Ya Allah, tunjukilah aku bersama orang-orang yang telah Engkau beri petunjuk, dan sehatkanlah aku bersama orang-orang yang telah Engkau sehatkan.',
      source: 'HR. Abu Dawud No. 1425',
      category: 'Sholat',
    ),
  ];

  static List<Doa> byCategory(String category) {
    if (category == 'Semua') return doas;
    return doas.where((d) => d.category == category).toList();
  }
}
