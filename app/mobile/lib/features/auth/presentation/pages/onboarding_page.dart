import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _slides = [
    _OnboardingSlide(
      icon: Icons.menu_book_rounded,
      title: 'Hafal dengan Caramu',
      description:
          'Buat playlist ayat sesukamu, tanpa batasan urutan. Mulai dari mana pun yang kamu mau.',
    ),
    _OnboardingSlide(
      icon: Icons.repeat_rounded,
      title: 'Latihan Setiap Hari',
      description:
          'Ulangi dan rekam progres hafalanmu dengan mudah. Konsistensi adalah kunci.',
    ),
    _OnboardingSlide(
      icon: Icons.mosque_rounded,
      title: 'Ibadah Lebih Teratur',
      description:
          'Pengingat sholat tepat waktu, arah qibla akurat. Semua dalam satu genggaman.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Lewati',
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            // Slides
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _OnboardingSlideWidget(slide: _slides[i]),
              ),
            ),
            // Indicator + buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _slides.length,
                    effect: const WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.divider,
                    ),
                  ),
                  const Gap(AppSpacing.lg),
                  AppButton.filled(
                    label: isLast ? 'Mulai Sekarang' : 'Lanjut',
                    onPressed: _next,
                    icon: isLast ? null : Icons.arrow_forward_rounded,
                  ),
                  const Gap(AppSpacing.sm),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(
                      'Sudah punya akun? Masuk',
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _OnboardingSlideWidget extends StatelessWidget {
  final _OnboardingSlide slide;

  const _OnboardingSlideWidget({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ilustrasi icon besar dengan background lingkaran
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: 80, color: Colors.white),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOut),
          const Gap(AppSpacing.xl),
          Text(
            slide.title,
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 150.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.2),
          const Gap(AppSpacing.md),
          Text(
            slide.description,
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 250.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.2),
        ],
      ),
    );
  }
}
