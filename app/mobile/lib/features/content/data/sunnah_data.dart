import 'package:flutter/material.dart';
import 'content_models.dart';

class SunnahData {
  SunnahData._();

  static const List<SunnahItem> items = [
    // Ibadah
    SunnahItem(
      id: 'sholat_dhuha',
      name: 'Sholat Dhuha',
      description: 'Minimal 2 rakaat, paling banyak 12 rakaat, waktu dari matahari setinggi tombak hingga sebelum zawal.',
      reward: 'Senilai 360 sedekah dan mendatangkan rezeki.',
      icon: Icons.wb_sunny_outlined,
      category: 'Ibadah',
    ),
    SunnahItem(
      id: 'sholat_rawatib',
      name: 'Sholat Rawatib',
      description: '12 rakaat: 2 sebelum Subuh, 4 sebelum Dzuhur, 2 setelah Dzuhur, 2 setelah Maghrib, 2 setelah Isya.',
      reward: 'Allah akan membangunkan rumah di surga baginya.',
      icon: Icons.star_outline_rounded,
      category: 'Ibadah',
    ),
    SunnahItem(
      id: 'tahajjud',
      name: 'Sholat Tahajjud',
      description: 'Sholat malam minimal 2 rakaat setelah bangun tidur, sebelum Subuh.',
      reward: 'Allah akan menjawab doa, mengampuni dosa, dan meninggikan derajat.',
      icon: Icons.nightlight_round,
      category: 'Ibadah',
    ),
    SunnahItem(
      id: 'puasa_senin_kamis',
      name: 'Puasa Senin & Kamis',
      description: 'Puasa sunnah setiap hari Senin dan Kamis.',
      reward: 'Amal perbuatan diangkat pada hari Senin dan Kamis, ingin amalnya diangkat dalam keadaan berpuasa.',
      icon: Icons.event_available_outlined,
      category: 'Ibadah',
    ),
    SunnahItem(
      id: 'baca_quran',
      name: 'Baca Al-Quran',
      description: 'Baca minimal 1 halaman Al-Quran setiap hari.',
      reward: 'Setiap huruf mendapat 10 kebaikan. Al-Quran akan menjadi syafaat di hari kiamat.',
      icon: Icons.menu_book_outlined,
      category: 'Ibadah',
    ),
    SunnahItem(
      id: 'dzikir_pagi_petang',
      name: 'Dzikir Pagi & Petang',
      description: 'Membaca dzikir pagi setelah Subuh dan dzikir petang setelah Ashar.',
      reward: 'Perlindungan dari gangguan setan, ketenangan hati, dan pahala besar.',
      icon: Icons.self_improvement_rounded,
      category: 'Ibadah',
    ),

    // Adab
    SunnahItem(
      id: 'salam',
      name: 'Menyebarkan Salam',
      description: 'Mengucapkan Assalamu\'alaikum kepada sesama muslim yang dikenal maupun tidak.',
      reward: 'Menyebarkan cinta, memperkuat ukhuwah, dan mendapat keselamatan.',
      icon: Icons.handshake_outlined,
      category: 'Adab',
    ),
    SunnahItem(
      id: 'sholawat',
      name: 'Sholawat kepada Nabi',
      description: 'Membaca sholawat minimal 10 kali setiap hari, terutama saat mendengar nama Nabi disebut.',
      reward: 'Allah akan bersholawat 10 kali kepada kita dan diangkat 10 derajat.',
      icon: Icons.favorite_outline_rounded,
      category: 'Adab',
    ),
    SunnahItem(
      id: 'sedekah',
      name: 'Bersedekah',
      description: 'Bersedekah walaupun sedikit setiap hari, bahkan dengan senyuman pun adalah sedekah.',
      reward: 'Sedekah tidak mengurangi harta, justru menambahkannya. Perlindungan dari api neraka.',
      icon: Icons.volunteer_activism_outlined,
      category: 'Adab',
    ),
    SunnahItem(
      id: 'istighfar',
      name: 'Beristighfar 100x',
      description: 'Membaca Astaghfirullah 100 kali setiap hari.',
      reward: 'Pengampunan dosa, ketenangan hati, dan kemudahan rezeki.',
      icon: Icons.loop_rounded,
      category: 'Adab',
    ),

    // Kesehatan
    SunnahItem(
      id: 'siwak',
      name: 'Bersiwak',
      description: 'Membersihkan gigi dengan siwak, terutama sebelum sholat dan setelah bangun tidur.',
      reward: 'Kebersihan mulut yang diridhai Allah, pahala berlipat dalam sholat.',
      icon: Icons.cleaning_services_outlined,
      category: 'Kesehatan',
    ),
    SunnahItem(
      id: 'minum_3teguk',
      name: 'Minum 3 Teguk',
      description: 'Minum dengan duduk, dalam tiga tegukan, tidak bernafas dalam gelas.',
      reward: 'Mengikuti sunnah Nabi, lebih sehat untuk pencernaan.',
      icon: Icons.local_drink_outlined,
      category: 'Kesehatan',
    ),
    SunnahItem(
      id: 'tidur_awal',
      name: 'Tidur Lebih Awal',
      description: 'Tidak begadang tanpa keperluan, tidur setelah Isya untuk bangun tahajjud.',
      reward: 'Lebih segar dan produktif, memudahkan bangun untuk tahajjud dan Subuh.',
      icon: Icons.bedtime_outlined,
      category: 'Kesehatan',
    ),
  ];

  static List<String> get categories =>
      items.map((i) => i.category).toSet().toList()..sort();
}
