import 'package:flutter/material.dart';
import 'content_models.dart';

class DzikirData {
  DzikirData._();

  static final DzikirSession pagi = DzikirSession(
    id: 'pagi',
    name: 'Dzikir Pagi',
    icon: Icons.wb_sunny_rounded,
    items: const [
      DzikirItem(
        arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ',
        latin: 'Ashbahnaa wa ashbahal-mulku lillaahi walhamdulillaahi laa ilaaha illallaahu wahdahu laa syariika lah',
        translation: 'Kami telah memasuki waktu pagi dan kerajaan hanya milik Allah, segala puji bagi Allah. Tidak ada sesembahan yang berhak disembah kecuali Allah semata, tiada sekutu bagi-Nya.',
        recommendedCount: 1,
        source: 'HR. Muslim No. 2723',
      ),
      DzikirItem(
        arabic: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
        latin: 'Allaahumma bika ashbahnaa wa bika amsaynaa wa bika nahyaa wa bika namuutu wa ilaykan-nusyuur',
        translation: 'Ya Allah, dengan-Mu kami memasuki waktu pagi, dengan-Mu kami memasuki waktu petang, dengan-Mu kami hidup, dengan-Mu kami mati, dan kepada-Mu kebangkitan.',
        recommendedCount: 1,
        source: 'HR. Abu Dawud No. 5068',
      ),
      DzikirItem(
        arabic: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ — اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ...',
        latin: 'A\'uudzu billaahi minasy-syaythaanir-rajiim. Allaahu laa ilaaha illaa huwal-hayyul-qayyuum...',
        translation: 'Ayat Kursi — barangsiapa membacanya di pagi hari, maka ia akan dilindungi hingga petang.',
        recommendedCount: 1,
        source: 'QS. Al-Baqarah: 255 | HR. Bukhari',
      ),
      DzikirItem(
        arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        latin: 'Subhaanallaahi wa bihamdih',
        translation: 'Maha Suci Allah dan dengan memuji-Nya.',
        recommendedCount: 100,
        source: 'HR. Bukhari No. 6405, Muslim No. 2691',
      ),
      DzikirItem(
        arabic: 'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        latin: 'Laa ilaaha illallaahu wahdahu laa syariika lahu, lahul-mulku wa lahul-hamdu wa huwa \'alaa kulli syay\'in qadiir',
        translation: 'Tidak ada sesembahan yang berhak disembah kecuali Allah semata, tiada sekutu bagi-Nya. Bagi-Nya kerajaan dan bagi-Nya segala pujian, dan Dia Maha Kuasa atas segala sesuatu.',
        recommendedCount: 10,
        source: 'HR. Bukhari No. 6403',
      ),
      DzikirItem(
        arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ',
        latin: 'Allaahumma anta rabbii laa ilaaha illaa anta, khalaqtanii wa ana \'abduka',
        translation: 'Ya Allah, Engkau adalah Tuhanku, tidak ada sesembahan yang berhak disembah kecuali Engkau. Engkau yang menciptakanku dan aku adalah hamba-Mu. (Sayyidul Istighfar)',
        recommendedCount: 1,
        source: 'HR. Bukhari No. 6306',
      ),
      DzikirItem(
        arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ',
        latin: 'Allaahumma innii as\'alukal-\'aafiyata fid-dunyaa wal-aakhirah',
        translation: 'Ya Allah, sesungguhnya aku memohon kepada-Mu keselamatan di dunia dan akhirat.',
        recommendedCount: 3,
        source: 'HR. Abu Dawud No. 5074',
      ),
    ],
  );

  static final DzikirSession petang = DzikirSession(
    id: 'petang',
    name: 'Dzikir Petang',
    icon: Icons.wb_twilight_rounded,
    items: const [
      DzikirItem(
        arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ',
        latin: 'Amsaynaa wa amsal-mulku lillaahi walhamdulillaahi laa ilaaha illallaahu wahdahu laa syariika lah',
        translation: 'Kami telah memasuki waktu petang dan kerajaan hanya milik Allah, segala puji bagi Allah. Tidak ada sesembahan yang berhak disembah kecuali Allah semata, tiada sekutu bagi-Nya.',
        recommendedCount: 1,
        source: 'HR. Muslim No. 2723',
      ),
      DzikirItem(
        arabic: 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ',
        latin: 'Allaahumma bika amsaynaa wa bika ashbahnaa wa bika nahyaa wa bika namuutu wa ilayal-mashiir',
        translation: 'Ya Allah, dengan-Mu kami memasuki waktu petang, dengan-Mu kami memasuki waktu pagi, dengan-Mu kami hidup, dengan-Mu kami mati, dan kepada-Mu tempat kembali.',
        recommendedCount: 1,
        source: 'HR. Abu Dawud No. 5068',
      ),
      DzikirItem(
        arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
        latin: 'A\'uudzu bikalimaatillaahit-taammati min syarri maa khalaq',
        translation: 'Aku berlindung dengan kalimat-kalimat Allah yang sempurna dari kejahatan apa yang Dia ciptakan.',
        recommendedCount: 3,
        source: 'HR. Muslim No. 2709',
      ),
      DzikirItem(
        arabic: 'بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
        latin: 'Bismillaahil-ladzii laa yadhurru ma\'asmihi syay\'un fil-ardhi wa laa fis-samaai wa huwas-samii\'ul-\'aliim',
        translation: 'Dengan nama Allah yang dengan nama-Nya tidak ada sesuatu pun yang dapat membahayakan, baik di bumi maupun di langit, dan Dia Maha Mendengar lagi Maha Mengetahui.',
        recommendedCount: 3,
        source: 'HR. Abu Dawud No. 5088',
      ),
      DzikirItem(
        arabic: 'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالإِسْلاَمِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا',
        latin: 'Radhiitu billaahi rabban wa bil-islaami diinan wa bi-muhammadin shallallaahu \'alayhi wa sallama nabiyyan',
        translation: 'Aku ridha Allah sebagai Tuhanku, Islam sebagai agamaku, dan Muhammad shallallahu \'alaihi wa sallam sebagai nabiku.',
        recommendedCount: 3,
        source: 'HR. Abu Dawud No. 5072',
      ),
      DzikirItem(
        arabic: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
        latin: 'Allaahumma shalli wa sallim \'alaa nabiyyinaa muhammad',
        translation: 'Ya Allah, limpahkanlah shalawat dan salam kepada Nabi kita Muhammad.',
        recommendedCount: 10,
        source: 'HR. Thabrani',
      ),
      DzikirItem(
        arabic: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
        latin: 'Astaghfirullaaha wa atuubu ilayh',
        translation: 'Aku memohon ampun kepada Allah dan bertaubat kepada-Nya.',
        recommendedCount: 100,
        source: 'HR. Bukhari No. 6307',
      ),
    ],
  );
}
