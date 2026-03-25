import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

enum _AppButtonVariant { filled, outlined, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;
  final _AppButtonVariant _variant;

  const AppButton.filled({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
  }) : _variant = _AppButtonVariant.filled;

  const AppButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
  }) : _variant = _AppButtonVariant.outlined;

  const AppButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
    this.icon,
  }) : _variant = _AppButtonVariant.text;

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _variant == _AppButtonVariant.filled
              ? AppColors.textOnPrimary
              : AppColors.primary,
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      );
    }
    return Text(label, style: AppTextStyles.bodyMedium);
  }

  @override
  Widget build(BuildContext context) {
    final child = _buildChild();
    final isDisabled = onPressed == null && !isLoading;

    Widget button;
    switch (_variant) {
      case _AppButtonVariant.filled:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
      case _AppButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
      case _AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
    }

    if (isDisabled) {
      button = Opacity(opacity: 0.5, child: button);
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
