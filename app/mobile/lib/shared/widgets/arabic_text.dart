import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_text_styles.dart';

class ArabicText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ArabicText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.right,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: TextDirection.rtl,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.amiri(
        fontSize: (style ?? AppTextStyles.arabicAyat).fontSize,
        fontWeight: (style ?? AppTextStyles.arabicAyat).fontWeight,
        height: (style ?? AppTextStyles.arabicAyat).height,
        color: style?.color,
      ),
    );
  }
}
