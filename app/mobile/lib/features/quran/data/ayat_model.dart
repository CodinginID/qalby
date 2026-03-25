class Ayat {
  final int surahNumber;
  final int number;
  final String arabic;
  final String translation;
  final String? audioUrl;     // from ar.alafasy (murotal)
  final String? tajweedText;  // XML-annotated text from quran-tajweed edition

  const Ayat({
    required this.surahNumber,
    required this.number,
    required this.arabic,
    required this.translation,
    this.audioUrl,
    this.tajweedText,
  });

  Ayat copyWith({String? tajweedText, String? audioUrl}) => Ayat(
        surahNumber: surahNumber,
        number: number,
        arabic: arabic,
        translation: translation,
        audioUrl: audioUrl ?? this.audioUrl,
        tajweedText: tajweedText ?? this.tajweedText,
      );
}
