import 'package:flutter/material.dart';
import 'content_models.dart';

class KisahNabiData {
  KisahNabiData._();

  static const List<ProphetStory> prophets = [
    ProphetStory(
      id: 'adam',
      name: 'Nabi Adam AS',
      nameArabic: 'آدم',
      epithet: 'Manusia Pertama',
      brief: 'Manusia pertama yang diciptakan Allah dari tanah, nenek moyang seluruh umat manusia.',
      story:
          'Allah SWT menciptakan Nabi Adam AS dari tanah liat dan meniupkan ruh ke dalamnya. Allah memerintahkan para malaikat untuk bersujud kepada Adam sebagai bentuk penghormatan atas kemuliaan manusia. Semua malaikat bersujud, kecuali Iblis yang sombong karena merasa dirinya lebih mulia dari Adam yang terbuat dari tanah.\n\n'
          'Allah menempatkan Adam di surga bersama istrinya, Hawa. Keduanya diizinkan menikmati semua yang ada di surga, kecuali satu pohon yang dilarang. Namun Iblis berhasil menggoda Adam dan Hawa untuk mendekati pohon terlarang tersebut, sehingga keduanya diturunkan ke bumi.\n\n'
          'Di bumi, Adam dan Hawa memulai kehidupan manusia. Nabi Adam mengajarkan nama-nama benda kepada anak cucunya dan menjadi nabi pertama yang membawa risalah tauhid.',
      lesson: 'Kesombongan adalah awal dari kebinasaan. Ketaatan kepada Allah adalah kunci keselamatan. Setiap kesalahan dapat diperbaiki dengan taubat yang tulus.',
      keyEvents: [
        'Diciptakan dari tanah oleh Allah SWT',
        'Malaikat bersujud, Iblis menolak dan menjadi kafir',
        'Ditempatkan di surga bersama Hawa',
        'Tertipu Iblis dan memakan buah terlarang',
        'Diturunkan ke bumi dan bertaubat kepada Allah',
        'Bertemu kembali dengan Hawa di Jabal Rahmah, Arafah',
      ],
      color: Color(0xFF1A5276),
    ),
    ProphetStory(
      id: 'idris',
      name: 'Nabi Idris AS',
      nameArabic: 'إِدْرِيس',
      epithet: 'Orang yang Cerdas',
      brief: 'Nabi pertama yang menggunakan pena untuk menulis, diangkat derajatnya oleh Allah ke tempat yang tinggi.',
      story:
          'Nabi Idris AS hidup di zaman setelah Nabi Adam AS. Beliau terkenal dengan kecerdasannya dan merupakan nabi pertama yang menggunakan pena untuk menulis. Allah SWT telah mengajarkan kepadanya ilmu pengetahuan yang luas.\n\n'
          'Allah SWT berfirman tentang Nabi Idris dalam Al-Quran: "Dan ceritakanlah (hai Muhammad kepada mereka, kisah) Idris (yang tersebut) di dalam Al Quran. Sesungguhnya ia adalah seorang yang sangat membenarkan dan seorang nabi. Dan Kami telah mengangkatnya ke martabat yang tinggi." (QS. Maryam: 56-57)\n\n'
          'Nabi Idris dikenal sebagai nabi yang sangat rajin beribadah dan berpuasa. Beliau diangkat Allah ke langit dan belum pernah merasakan kematian seperti manusia pada umumnya.',
      lesson: 'Ilmu pengetahuan adalah cahaya yang menerangi jalan kebenaran. Ibadah yang tekun dan ikhlas akan mengangkat derajat seseorang di sisi Allah.',
      keyEvents: [
        'Nabi pertama yang menggunakan pena untuk menulis',
        'Diajarkan ilmu perbintangan dan berbagai ilmu pengetahuan',
        'Sangat tekun beribadah dan berpuasa',
        'Diangkat Allah ke derajat yang tinggi (langit)',
      ],
      color: Color(0xFF1E8449),
    ),
    ProphetStory(
      id: 'nuh',
      name: 'Nabi Nuh AS',
      nameArabic: 'نُوح',
      epithet: 'Ulul Azmi',
      brief: 'Nabi yang berdakwah selama 950 tahun dan membuat bahtera untuk menyelamatkan umatnya dari banjir besar.',
      story:
          'Nabi Nuh AS berdakwah kepada kaumnya selama 950 tahun, mengajak mereka untuk meninggalkan penyembahan berhala dan kembali kepada Allah SWT. Namun hanya sedikit yang beriman — riwayat menyebut kurang dari seratus orang.\n\n'
          'Allah SWT memerintahkan Nabi Nuh untuk membuat bahtera besar di atas bukit. Kaum Nuh mengejek dan menertawakannya. Namun Nabi Nuh tetap melaksanakan perintah Allah dengan penuh keyakinan.\n\n'
          'Ketika bahtera selesai, Allah menurunkan hujan lebat selama berhari-hari dan mengeluarkan air dari bumi. Banjir besar melanda seluruh daratan. Nabi Nuh membawa serta orang-orang beriman dan sepasang dari setiap hewan ke dalam bahtera.\n\n'
          'Putra Nabi Nuh sendiri, Kan\'an, menolak masuk ke dalam bahtera dan akhirnya tenggelam. Ini adalah ujian berat bagi Nabi Nuh sebagai seorang ayah.',
      lesson: 'Kesabaran dan keteguhan dalam berdakwah adalah kunci keberhasilan. Hidayah adalah hak prerogatif Allah, bahkan keluarga terdekat pun bisa menolak kebenaran.',
      keyEvents: [
        'Berdakwah selama 950 tahun kepada kaumnya',
        'Hanya sedikit yang beriman',
        'Diperintahkan membuat bahtera besar',
        'Banjir besar menghancurkan kaum yang ingkar',
        'Putranya Kan\'an tenggelam karena menolak beriman',
        'Bahtera berlabuh di Gunung Judi',
      ],
      color: Color(0xFF0E3460),
    ),
    ProphetStory(
      id: 'ibrahim',
      name: 'Nabi Ibrahim AS',
      nameArabic: 'إِبْرَاهِيم',
      epithet: 'Khalilullah (Kekasih Allah)',
      brief: 'Bapak para nabi, pembangun Ka\'bah bersama putranya Ismail, simbol ketaatan dan pengorbanan total kepada Allah.',
      story:
          'Nabi Ibrahim AS lahir di Ur, Mesopotamia (sekarang Irak). Sejak muda, beliau sudah mempertanyakan kebenaran penyembahan berhala yang dilakukan kaumnya. Dengan akal dan fitrahnya, beliau sampai pada kesimpulan bahwa hanya Allah SWT yang layak disembah.\n\n'
          'Ibrahim pernah diperintahkan Allah untuk meninggalkan istri (Hajar) dan anaknya (Ismail) yang masih bayi di lembah tandus yang kelak menjadi Makkah. Hajar berlari-lari antara bukit Shafa dan Marwah mencari air, hingga Allah memunculkan mata air Zamzam.\n\n'
          'Ujian terberat adalah ketika Allah memerintahkan Ibrahim untuk menyembelih putra kesayangannya, Ismail. Ibrahim dan Ismail sama-sama taat. Ketika pisau hampir menyentuh Ismail, Allah menggantikannya dengan seekor domba — inilah asal mula ibadah qurban.\n\n'
          'Ibrahim bersama Ismail kemudian membangun Ka\'bah di Makkah dan menjadi cikal bakal millah Ibrahim yang diteruskan oleh Nabi Muhammad SAW.',
      lesson: 'Ketaatan total kepada Allah adalah puncak keimanan. Ujian terberat adalah ujian yang melibatkan sesuatu yang paling kita cintai.',
      keyEvents: [
        'Menghancurkan berhala-berhala kaumnya',
        'Dilempar ke dalam api oleh Raja Namrudz — selamat atas izin Allah',
        'Meninggalkan Hajar dan Ismail di Makkah',
        'Munculnya mata air Zamzam',
        'Diperintahkan menyembelih Ismail — Allah ganti dengan domba',
        'Membangun Ka\'bah bersama Ismail',
        'Mendapat gelar Khalilullah (Kekasih Allah)',
      ],
      color: Color(0xFFC9A84C),
    ),
    ProphetStory(
      id: 'musa',
      name: 'Nabi Musa AS',
      nameArabic: 'مُوسَى',
      epithet: 'Ulul Azmi, Kalimullah',
      brief: 'Nabi yang berbicara langsung dengan Allah, memimpin Bani Israil keluar dari perbudakan Fir\'aun di Mesir.',
      story:
          'Nabi Musa AS lahir di Mesir ketika Raja Fir\'aun memerintahkan pembunuhan semua bayi laki-laki Bani Israil. Ibunya menghanyutkan bayi Musa di sungai Nil dalam sebuah peti, dan peti itu hanyut ke istana Fir\'aun. Musa kemudian dirawat langsung oleh Fir\'aun.\n\n'
          'Setelah dewasa dan mengetahui jati dirinya sebagai Bani Israil, Musa melarikan diri ke Madyan setelah tidak sengaja membunuh orang Mesir. Di sana ia menikah dan bekerja sebagai penggembala.\n\n'
          'Suatu hari, di Gunung Sinai, Allah SWT berbicara langsung kepada Musa dari dalam sebatang pohon yang menyala — inilah mengapa Musa mendapat gelar Kalimullah (yang diajak bicara Allah). Musa diberi tongkat ajaib dan diutus kembali ke Mesir untuk membebaskan Bani Israil.\n\n'
          'Musa menghadapi Fir\'aun dengan mukjizat-mukjizat yang luar biasa: tongkat berubah menjadi ular besar, tangan bersinar putih bercahaya, dan sembilan azab bagi Mesir. Akhirnya, Musa berhasil memimpin Bani Israil keluar dari Mesir. Ketika Fir\'aun mengejar, Allah membelah Laut Merah untuk Musa dan kaumnya, lalu menenggelamkan Fir\'aun.',
      lesson: 'Pertolongan Allah pasti datang bagi orang yang sabar dan beriman. Keberanian menghadapi kezaliman adalah kewajiban seorang mukmin.',
      keyEvents: [
        'Lahir saat Fir\'aun membunuh bayi Bani Israil',
        'Dihanyutkan di sungai Nil, dipungut Fir\'aun',
        'Melarikan diri ke Madyan setelah membunuh tidak sengaja',
        'Allah berbicara langsung di Gunung Sinai (Kalimullah)',
        'Kembali ke Mesir membawa risalah kepada Fir\'aun',
        'Sembilan mukjizat/azab Allah atas Mesir',
        'Membelah Laut Merah, Fir\'aun tenggelam',
        'Menerima Kitab Taurat di Gunung Sinai',
      ],
      color: Color(0xFF1E8449),
    ),
    ProphetStory(
      id: 'isa',
      name: 'Nabi Isa AS',
      nameArabic: 'عِيسَى',
      epithet: 'Ulul Azmi, Ruhullah',
      brief: 'Nabi yang lahir tanpa ayah dari Maryam binti Imran, membawa Injil dan banyak mukjizat.',
      story:
          'Nabi Isa AS lahir secara mukjizat dari seorang wanita suci bernama Maryam binti Imran, tanpa ayah. Kelahiran ini adalah bukti kekuasaan Allah SWT yang mampu menciptakan sesuatu dari ketiadaan.\n\n'
          'Sejak bayi, Isa sudah dapat berbicara dan membela kesucian ibundanya yang difitnah. Allah menganugerahinya banyak mukjizat: menyembuhkan penyakit kusta dan kebutaan, menghidupkan orang mati, dan membuat burung dari tanah liat yang kemudian hidup atas izin Allah.\n\n'
          'Nabi Isa diutus kepada Bani Israil dengan membawa Kitab Injil. Beliau mengajarkan kasih sayang, kerendahan hati, dan keesaan Allah. Namun Bani Israil banyak yang menentangnya, bahkan berencana membunuhnya.\n\n'
          'Allah SWT menyelamatkan Nabi Isa dari rencana pembunuhan dengan mengangkatnya ke langit. Yang disalib oleh musuh-musuhnya adalah orang lain yang diserupakan wajahnya dengan Isa. Nabi Isa akan turun kembali ke bumi menjelang hari kiamat.',
      lesson: 'Kesucian hati dan ketulusan ibadah adalah nilai utama yang diajarkan Nabi Isa. Pertolongan Allah selalu ada bagi hamba-hamba yang tulus.',
      keyEvents: [
        'Lahir dari Maryam tanpa ayah, mukjizat Allah',
        'Berbicara sejak bayi untuk membela ibundanya',
        'Banyak mukjizat: menyembuhkan, menghidupkan orang mati',
        'Menerima Kitab Injil dari Allah',
        'Bani Israil menolak dan berencana membunuhnya',
        'Allah mengangkat Isa ke langit, bukan disalib',
        'Akan turun kembali menjelang hari kiamat',
      ],
      color: Color(0xFF6C3483),
    ),
    ProphetStory(
      id: 'muhammad',
      name: 'Nabi Muhammad SAW',
      nameArabic: 'مُحَمَّد',
      epithet: 'Ulul Azmi, Khatamul Anbiya',
      brief: 'Nabi dan Rasul terakhir, pembawa Islam sebagai agama yang sempurna untuk seluruh umat manusia.',
      story:
          'Nabi Muhammad SAW lahir pada 12 Rabi\'ul Awwal di Makkah, dalam keadaan yatim. Ayahnya, Abdullah, wafat sebelum beliau lahir. Ibundanya, Aminah, wafat ketika Muhammad berusia 6 tahun. Beliau diasuh oleh kakeknya, Abdul Muthalib, lalu pamannya, Abu Thalib.\n\n'
          'Sejak muda, Muhammad dikenal dengan sifat jujur dan amanah sehingga diberi gelar Al-Amin (yang terpercaya). Beliau menikah dengan Khadijah binti Khuwailid pada usia 25 tahun.\n\n'
          'Pada usia 40 tahun, di Gua Hira, Muhammad menerima wahyu pertama melalui Malaikat Jibril: "Iqra\' bismi rabbikal-ladzii khalaq." Inilah awal kenabian beliau. Selama 23 tahun, beliau menerima wahyu yang terhimpun dalam Al-Quran.\n\n'
          'Perjuangan dakwah penuh rintangan. Beliau dan para sahabat diboikot, disiksa, bahkan harus berhijrah ke Madinah. Namun dengan kesabaran dan keteguhan iman, Islam akhirnya tersebar ke seluruh jazirah Arab dan kemudian ke seluruh penjuru dunia.\n\n'
          'Nabi Muhammad SAW wafat pada usia 63 tahun di Madinah. Beliau adalah nabi terakhir, tidak ada nabi setelah beliau.',
      lesson: 'Akhlak mulia adalah warisan terbesar seorang pemimpin. Kesabaran dalam dakwah dan konsistensi dalam ibadah adalah teladan abadi.',
      keyEvents: [
        'Lahir yatim di Makkah, 12 Rabiul Awwal',
        'Diberi gelar Al-Amin karena kejujurannya',
        'Menikah dengan Khadijah pada usia 25 tahun',
        'Wahyu pertama di Gua Hira pada usia 40 tahun',
        'Dakwah terang-terangan dan berbagai cobaan',
        'Isra Mi\'raj — perjalanan ke langit, menerima perintah sholat 5 waktu',
        'Hijrah ke Madinah — tonggak awal kalender Hijriyah',
        'Perang Badar, Uhud, Khandaq, dan berbagai perang',
        'Fathu Makkah — penaklukan Makkah tanpa pertumpahan darah',
        'Haji Wada\' dan wafat pada usia 63 tahun',
      ],
      color: Color(0xFF1A5276),
    ),
  ];
}
