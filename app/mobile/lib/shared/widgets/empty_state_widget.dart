import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? illustrationPath;
  final String title;
  final String? subtitle;
  final Widget? action;
  final IconData? icon;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    this.illustrationPath,
    required this.title,
    this.subtitle,
    this.action,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with layered gradient circles
            SizedBox(
              width: 100, height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.06),
                    ),
                  ),
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.1),
                    ),
                  ),
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      icon ?? Icons.inbox_outlined,
                      size: 26,
                      color: color.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.elasticOut, begin: const Offset(0.7, 0.7)),

            const Gap(AppSpacing.lg),

            Text(
              title,
              style: AppTextStyles.titleCard.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ).animate(delay: 100.ms).fadeIn(duration: 300.ms),

            if (subtitle != null) ...[
              const Gap(AppSpacing.sm),
              Text(
                subtitle!,
                style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textHint),
                textAlign: TextAlign.center,
              ).animate(delay: 150.ms).fadeIn(duration: 300.ms),
            ],

            if (action != null) ...[
              const Gap(AppSpacing.lg),
              action!.animate(delay: 200.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1),
            ],
          ],
        ),
      ),
    );
  }
}
