class Surah {
  final int number;
  final String nameArabic;
  final String nameLatin;
  final String nameTranslation;
  final int ayatCount;
  final String type;
  final int juz;

  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameLatin,
    required this.nameTranslation,
    required this.ayatCount,
    required this.type,
    required this.juz,
  });
}
