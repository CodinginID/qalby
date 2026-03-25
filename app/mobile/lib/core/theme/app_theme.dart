import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.surface,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          titleTextStyle: AppTextStyles.headingMedium,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.surfaceCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: const BorderSide(color: AppColors.divider, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            textStyle: AppTextStyles.bodyMedium,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            textStyle: AppTextStyles.bodyMedium,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.bodyMedium,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 14,
          ),
          hintStyle: AppTextStyles.bodyRegular.copyWith(
            color: AppColors.textHint,
          ),
        ),
        // Material 3 NavigationBar
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.surfaceCard,
          indicatorColor: AppColors.primary.withValues(alpha: 0.12),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: AppColors.divider,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primary, size: 24);
            }
            return const IconThemeData(color: AppColors.textHint, size: 24);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTextStyles.labelSmall.copyWith(color: AppColors.primary);
            }
            return AppTextStyles.labelSmall.copyWith(color: AppColors.textHint);
          }),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surface,
          selectedColor: AppColors.primary.withValues(alpha: 0.12),
          labelStyle: AppTextStyles.caption,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
            side: const BorderSide(color: AppColors.divider),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          surface: AppColors.darkSurface,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textOnPrimary,
          titleTextStyle: AppTextStyles.headingMedium.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: const BorderSide(color: AppColors.darkBorder, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            textStyle: AppTextStyles.bodyMedium,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            side: const BorderSide(color: AppColors.primaryLight),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            textStyle: AppTextStyles.bodyMedium,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            textStyle: AppTextStyles.bodyMedium,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide:
                const BorderSide(color: AppColors.primaryLight, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: 14),
          hintStyle: AppTextStyles.bodyRegular
              .copyWith(color: AppColors.textHint),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkBorder,
          thickness: 1,
          space: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedColor: AppColors.primary.withValues(alpha: 0.25),
          labelStyle: AppTextStyles.caption
              .copyWith(color: Colors.white70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
            side: const BorderSide(color: AppColors.darkBorder),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.primaryLight
                  : Colors.white54),
          trackColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.primaryLight.withValues(alpha: 0.4)
                  : AppColors.darkBorder),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.darkCard,
          indicatorColor: AppColors.primary.withValues(alpha: 0.2),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                  color: AppColors.primaryLight, size: 24);
            }
            return IconThemeData(
              color: AppColors.textHint.withValues(alpha: 0.7),
              size: 24,
            );
          }),
        ),
      );
}
