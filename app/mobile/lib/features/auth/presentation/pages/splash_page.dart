import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/auth_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _minDelayDone = false;

  @override
  void initState() {
    super.initState();
    // Guarantee minimum 2-second splash display
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _minDelayDone = true);
    });
  }

  void _navigate(Object? user) {
    if (user != null) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authProvider);

    // Navigate once both: auth state settled AND minimum delay elapsed
    if (_minDelayDone) {
      authAsync.whenData((user) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _navigate(user);
        });
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.nightGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.nightlight_round, size: 48, color: AppColors.accent)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(
                        begin: const Offset(0.5, 0.5),
                        curve: Curves.elasticOut),
                const Gap(AppSpacing.lg),
                Text(
                  'قلبي',
                  style: AppTextStyles.arabicSurahName.copyWith(
                    fontSize: 56,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                )
                    .animate(delay: 300.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.3, curve: Curves.easeOut),
                const Gap(AppSpacing.xs),
                Text(
                  'Q A L B Y',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.accent,
                    fontSize: 14,
                    letterSpacing: 6,
                  ),
                ).animate(delay: 500.ms).fadeIn(duration: 400.ms),
                const Gap(AppSpacing.md),
                Text(
                  'Temani Perjalanan Hafalanmu',
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ).animate(delay: 700.ms).fadeIn(duration: 400.ms),
                const Gap(AppSpacing.xxl),
                _LoadingDots().animate(delay: 1000.ms).fadeIn(duration: 300.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final progress = (_controller.value - i * 0.2).clamp(0.0, 0.5);
            return Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: AppColors.accent
                    .withValues(alpha: 0.3 + progress * 1.4),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
