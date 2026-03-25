import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/arabic_text.dart';
import '../../domain/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final success = await ref.read(authProvider.notifier).signInWithGoogle();
      if (!mounted) return;
      if (success) {
        context.go('/home');
      } else {
        _showError('Masuk dibatalkan atau gagal. Coba lagi.');
      }
    } catch (_) {
      if (mounted) _showError('Terjadi kesalahan. Periksa koneksi internet.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent, duration: const Duration(seconds: 3)),
    );
  }

  // Skip login — lanjut sebagai tamu
  void _continueAsGuest() => context.go('/home');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient ───────────────────────────────────────
          Container(decoration: const BoxDecoration(gradient: AppColors.nightGradient)),

          // ── Background ornament ───────────────────────────────────────
          Positioned(
            top: -40, right: -60,
            child: Opacity(
              opacity: 0.06,
              child: Icon(Icons.mosque_rounded, size: 320, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: -20, left: -40,
            child: Opacity(
              opacity: 0.04,
              child: Icon(Icons.star_rounded, size: 220, color: Colors.white),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // ── Logo section ────────────────────────────────────────
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Crescent icon
                        Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFC9A84C), Color(0xFFE8CC7A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.4), blurRadius: 24, offset: const Offset(0, 8))],
                          ),
                          child: const Icon(Icons.nightlight_round, size: 44, color: Colors.white),
                        ).animate().scale(begin: const Offset(0.5, 0.5), duration: 800.ms, curve: Curves.elasticOut),
                        const Gap(AppSpacing.lg),
                        ArabicText(
                          text: 'قَلْبِي',
                          style: AppTextStyles.arabicSurahName.copyWith(color: Colors.white, fontSize: 52),
                        ).animate(delay: 200.ms).fadeIn().slideY(begin: -0.1),
                        const Gap(AppSpacing.xs),
                        Text(
                          'QALBY',
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, letterSpacing: 5, fontSize: 13),
                        ).animate(delay: 300.ms).fadeIn(),
                        const Gap(AppSpacing.sm),
                        Text(
                          'Teman Perjalanan Hafalanmu',
                          style: AppTextStyles.bodyRegular.copyWith(color: Colors.white60),
                          textAlign: TextAlign.center,
                        ).animate(delay: 400.ms).fadeIn(),
                      ],
                    ),
                  ),
                ),

                // ── Sign-in card ─────────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 24, offset: const Offset(0, -8))],
                  ),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.xl,
                    AppSpacing.xl,
                    MediaQuery.of(context).padding.bottom + AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Selamat Datang',
                        style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(AppSpacing.xs),
                      Text(
                        'Masuk untuk menyimpan progress hafalan\ndan sinkronisasi antar perangkat',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(AppSpacing.xl),

                      // ── Google button ─────────────────────────────────
                      _GoogleSignInButton(
                        isLoading: _isLoading,
                        onPressed: _signInWithGoogle,
                      ),
                      const Gap(AppSpacing.md),

                      // ── Benefits ──────────────────────────────────────
                      const _BenefitsRow(),
                      const Gap(AppSpacing.xl),

                      // ── Guest option ──────────────────────────────────
                      GestureDetector(
                        onTap: _continueAsGuest,
                        child: Text(
                          'Lanjutkan tanpa masuk',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textHint,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 500.ms).slideY(begin: 0.3).fadeIn(duration: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Google sign-in button ────────────────────────────────────────────────────

class _GoogleSignInButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const _GoogleSignInButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: 200.ms,
        height: 52,
        decoration: BoxDecoration(
          color: isLoading ? AppColors.divider : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: isLoading ? null : [
            BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: isLoading
            ? const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google "G" icon — using colored text as placeholder
                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'G',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.blue.shade700,
                        fontFamily: 'Arial',
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.md),
                  Text(
                    'Masuk dengan Google',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─── Benefits row ────────────────────────────────────────────────────────────

class _BenefitsRow extends StatelessWidget {
  const _BenefitsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _BenefitItem(icon: Icons.cloud_sync_rounded, label: 'Sinkronisasi'),
        _BenefitItem(icon: Icons.devices_rounded, label: 'Multi Perangkat'),
        _BenefitItem(icon: Icons.lock_outline_rounded, label: 'Aman & Privat'),
      ],
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BenefitItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const Gap(AppSpacing.xs),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
      ],
    );
  }
}
