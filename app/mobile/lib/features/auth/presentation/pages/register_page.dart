import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/login'),
        ),
        title: const Text('Buat Akun'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(AppSpacing.md),
            Text(
              'Mulai perjalanan hafalanmu',
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(AppSpacing.sm),
            Text(
              'Daftar gratis dan mulai hari ini',
              style: AppTextStyles.bodyRegular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Gap(AppSpacing.xl),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Nama Lengkap',
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
            ),
            const Gap(AppSpacing.md),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email_outlined, size: 20),
              ),
            ),
            const Gap(AppSpacing.md),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Password (min. 8 karakter)',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const Gap(AppSpacing.xl),
            AppButton.filled(
              label: 'Daftar',
              isLoading: _isLoading,
              onPressed: _register,
            ),
            const Gap(AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sudah punya akun? ',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.go('/login'),
                  child: Text(
                    'Masuk',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.05),
      ),
    );
  }
}
