import 'content_models.dart';

class MotivasiData {
  MotivasiData._();

  static const List<MotivationQuote> quotes = [
    MotivationQuote(
      arabic: 'لَا يُكَلِّفُ ٱللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
      translation: 'Allah tidak membebani seseorang melainkan sesuai dengan kesanggupannya.',
      source: 'QS. Al-Baqarah: 286',
      category: 'Quran',
    ),
    MotivationQuote(
      arabic: 'إِنَّ مَعَ ٱلْعُسْرِ يُسْرًا',
      translation: 'Sesungguhnya bersama kesulitan ada kemudahan.',
      source: 'QS. Al-Insyirah: 6',
      category: 'Quran',
    ),
    MotivationQuote(
      arabic: 'وَمَن يَتَّقِ ٱللَّهَ يَجْعَل لَّهُۥ مَخْرَجًا',
      translation: 'Barangsiapa bertakwa kepada Allah, Dia akan membukakan jalan keluar baginya.',
      source: 'QS. At-Thalaq: 2',
      category: 'Quran',
    ),
    MotivationQuote(
      arabic: 'فَإِنَّ مَعَ ٱلْعُسْرِ يُسْرًا ۝ إِنَّ مَعَ ٱلْعُسْرِ يُسْرًا',
      translation: 'Maka sesungguhnya bersama kesulitan ada kemudahan. Sesungguhnya bersama kesulitan ada kemudahan.',
      source: 'QS. Al-Insyirah: 5-6',
      category: 'Quran',
    ),
    MotivationQuote(
      arabic: 'وَٱسْتَعِينُوا۟ بِٱلصَّبْرِ وَٱلصَّلَوٰةِ',
      translation: 'Mohonlah pertolongan dengan sabar dan sholat.',
      source: 'QS. Al-Baqarah: 45',
      category: 'Quran',
    ),
    MotivationQuote(
      arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
      translation: 'Sesungguhnya Allah bersama orang-orang yang sabar.',
      source: 'QS. Al-Baqarah: 153',
      category: 'Quran',
    ),
    MotivationQuote(
      arabic: 'أَقْرَبُ مَا يَكُونُ الْعَبْدُ مِنْ رَبِّهِ وَهُوَ سَاجِدٌ',
      translation: 'Keadaan paling dekat antara seorang hamba dengan Tuhannya adalah ketika ia sedang bersujud.',
      source: 'HR. Muslim No. 482',
      category: 'Hadith',
    ),
    MotivationQuote(
      arabic: 'مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا سَهَّلَ اللَّهُ لَهُ طَرِيقًا إِلَى الْجَنَّةِ',
      translation: 'Barangsiapa menempuh jalan untuk mencari ilmu, Allah akan mudahkan baginya jalan menuju surga.',
      source: 'HR. Muslim No. 2699',
      category: 'Hadith',
    ),
    MotivationQuote(
      arabic: 'خَيْرُ النَّاسِ أَنْفَعُهُمْ لِلنَّاسِ',
      translation: 'Sebaik-baik manusia adalah yang paling bermanfaat bagi manusia lain.',
      source: 'HR. Ahmad, Thabrani',
      category: 'Hadith',
    ),
    MotivationQuote(
      arabic: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
      translation: 'Sesungguhnya setiap amal perbuatan tergantung pada niatnya.',
      source: 'HR. Bukhari No. 1, Muslim No. 1907',
      category: 'Hadith',
    ),
    MotivationQuote(
      arabic: 'الْمُؤْمِنُ الْقَوِيُّ خَيْرٌ وَأَحَبُّ إِلَى اللَّهِ مِنَ الْمُؤْمِنِ الضَّعِيفِ',
      translation: 'Mukmin yang kuat lebih baik dan lebih dicintai Allah daripada mukmin yang lemah.',
      source: 'HR. Muslim No. 2664',
      category: 'Hadith',
    ),
    MotivationQuote(
      arabic: 'تَفَكُّرُ سَاعَةٍ خَيْرٌ مِنْ عِبَادَةِ سَبْعِينَ سَنَةً',
      translation: 'Berpikir selama satu jam lebih baik daripada beribadah selama tujuh puluh tahun.',
      source: 'Imam Al-Ghazali',
      category: 'Ulama',
    ),
    MotivationQuote(
      arabic: 'اَلْوَقْتُ كَالسَّيْفِ إِنْ لَمْ تَقْطَعْهُ قَطَعَكَ',
      translation: 'Waktu itu seperti pedang. Jika kamu tidak memotongnya, ia akan memotongmu.',
      source: 'Imam Syafi\'i',
      category: 'Ulama',
    ),
    MotivationQuote(
      arabic: 'وَهُوَ مَعَكُمْ أَيْنَ مَا كُنتُمْ',
      translation: 'Dan Dia bersama kamu di mana saja kamu berada.',
      source: 'QS. Al-Hadid: 4',
      category: 'Quran',
    ),
    MotivationQuote(
      arabic: 'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا',
      translation: 'Ya Tuhan kami, janganlah Engkau jadikan hati kami condong kepada kesesatan sesudah Engkau memberi petunjuk kepada kami.',
      source: 'QS. Ali Imran: 8',
      category: 'Quran',
    ),
  ];

  /// Quote of the day based on date
  static MotivationQuote dailyQuote() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return quotes[dayOfYear % quotes.length];
  }
}
