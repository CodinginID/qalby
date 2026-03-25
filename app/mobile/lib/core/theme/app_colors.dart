import 'package:flutter/material.dart';

extension BrightnessContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

class AppColors {
  AppColors._();

  // Primary — Deep Islamic Blue
  static const Color primary      = Color(0xFF1A5276);
  static const Color primaryLight = Color(0xFF2E86C1);
  static const Color primaryDark  = Color(0xFF0E2F44);

  // Accent — Islamic Gold
  static const Color accent      = Color(0xFFC9A84C);
  static const Color accentLight = Color(0xFFE8C97A);
  static const Color accentDark  = Color(0xFF9B7D35);

  // Success — Teal Green
  static const Color success      = Color(0xFF1E8449);
  static const Color successLight = Color(0xFF27AE60);

  // Neutral
  static const Color surface     = Color(0xFFF8F6F2); // warm white krem
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color divider     = Color(0xFFEAE4D8);

  // Text
  static const Color textPrimary   = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textHint      = Color(0xFFAAAAAA);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textGold      = Color(0xFFC9A84C);

  // Dark Mode
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface    = Color(0xFF161B22);
  static const Color darkCard       = Color(0xFF21262D);
  static const Color darkBorder     = Color(0xFF30363D);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A5276), Color(0xFF0E2F44)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC9A84C), Color(0xFF9B7D35)],
  );

  static const LinearGradient nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D1117), Color(0xFF1A2744)],
  );

  // Playlist card gradients — cyclic berdasarkan index
  static const List<LinearGradient> playlistGradients = [
    goldGradient,
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1A5276), Color(0xFF0E2F44)],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1E8449), Color(0xFF145A32)],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF6C3483), Color(0xFF4A235A)],
    ),
  ];

  static LinearGradient playlistGradientAt(int index) =>
      playlistGradients[index % playlistGradients.length];

  // ── Adaptive helpers (context-aware) ──────────────────────────────────────
  static Color bgSurface(BuildContext ctx) =>
      ctx.isDark ? darkBackground : surface;
  static Color bgCard(BuildContext ctx) =>
      ctx.isDark ? darkCard : surfaceCard;
  static Color borderColor(BuildContext ctx) =>
      ctx.isDark ? darkBorder : divider;
  static Color textPri(BuildContext ctx) =>
      ctx.isDark ? Colors.white : textPrimary;
  static Color textSec(BuildContext ctx) =>
      ctx.isDark ? Colors.white60 : textSecondary;
}
