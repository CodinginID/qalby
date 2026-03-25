import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class IslamicDivider extends StatelessWidget {
  final String? label;

  const IslamicDivider({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    final content = label ?? '✦';
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            content,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textHint,
              letterSpacing: 1,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
      ],
    );
  }
}
