import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  // Latin UI — Plus Jakarta Sans
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        fontSize: 28, fontWeight: FontWeight.w700, height: 1.3,
      );

  static TextStyle get headingMedium => GoogleFonts.plusJakartaSans(
        fontSize: 20, fontWeight: FontWeight.w600, height: 1.4,
      );

  static TextStyle get titleCard => GoogleFonts.plusJakartaSans(
        fontSize: 16, fontWeight: FontWeight.w600, height: 1.4,
      );

  static TextStyle get bodyRegular => GoogleFonts.plusJakartaSans(
        fontSize: 14, fontWeight: FontWeight.w400, height: 1.6,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14, fontWeight: FontWeight.w500, height: 1.6,
      );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 12, fontWeight: FontWeight.w400, height: 1.5,
      );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
        fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5,
      );

  // Arabic — Amiri (selalu RTL)
  static TextStyle get arabicAyat => GoogleFonts.amiri(
        fontSize: 26, fontWeight: FontWeight.w400, height: 2.0,
      );

  static TextStyle get arabicSmall => GoogleFonts.amiri(
        fontSize: 18, fontWeight: FontWeight.w400, height: 1.8,
      );

  static TextStyle get arabicSurahName => GoogleFonts.amiri(
        fontSize: 22, fontWeight: FontWeight.w700,
      );

  static TextStyle get arabicCounter => GoogleFonts.amiri(
        fontSize: 28, fontWeight: FontWeight.w700,
      );
}
