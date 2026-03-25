import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/data/app_user.dart';
import '../../../auth/domain/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeModeProvider);
    final themeMode = themeAsync.value ?? ThemeMode.system;
    final authAsync = ref.watch(authProvider);
    final user = authAsync.value;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, 80, AppSpacing.lg, AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Profil',
                        style: AppTextStyles.displayLarge.copyWith(color: Colors.white)),
                    const Gap(AppSpacing.xs),
                    Text('Akun & pengaturan aplikasi',
                        style: AppTextStyles.bodyRegular.copyWith(color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Akun ───────────────────────────────────────────────
                  _SectionHeader(label: 'Akun'),
                  const Gap(AppSpacing.sm),
                  user != null
                      ? _ProfileCard(user: user, ref: ref)
                      : _GuestCard(onLogin: () => context.push('/login')),
                  const Gap(AppSpacing.lg),

                  // ─── Tampilan ───────────────────────────────────────────
                  _SectionHeader(label: 'Tampilan'),
                  const Gap(AppSpacing.sm),
                  _SettingsCard(
                    children: [
                      _ThemeTile(currentMode: themeMode, ref: ref),
                    ],
                  ),
                  const Gap(AppSpacing.lg),

                  // ─── Dukung Kami ─────────────────────────────────────────
                  _SectionHeader(label: 'Dukung Kami'),
                  const Gap(AppSpacing.sm),
                  _InfaqCard(),
                  const Gap(AppSpacing.lg),

                  // ─── Tentang ────────────────────────────────────────────
                  _SectionHeader(label: 'Tentang'),
                  const Gap(AppSpacing.sm),
                  _SettingsCard(
                    children: [
                      _InfoTile(
                        icon: Icons.auto_stories_rounded,
                        color: const Color(0xFF1E8449),
                        title: 'Qalby',
                        subtitle: 'Aplikasi Hafalan Quran',
                      ),
                      _divider(context),
                      _InfoTile(
                        icon: Icons.tag_rounded,
                        color: AppColors.primary,
                        title: 'Versi',
                        subtitle: '1.0.0',
                      ),
                      _divider(context),
                      _InfoTile(
                        icon: Icons.favorite_rounded,
                        color: Colors.redAccent,
                        title: 'Dibuat dengan',
                        subtitle: 'Flutter & Riverpod',
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) => Divider(
        height: 1,
        indent: AppSpacing.lg + 40,
        color: AppColors.borderColor(context),
      );
}

// ─── Section header ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textSec(context),
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }
}

// ─── Settings card container ─────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Column(children: children),
    );
  }
}

// ─── Profile card (logged in) ─────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final AppUser user;
  final WidgetRef ref;
  const _ProfileCard({required this.user, required this.ref});

  @override
  Widget build(BuildContext context) {
    final photoUrl = user.photoUrl;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? Icon(Icons.person_rounded, color: AppColors.primary, size: 24)
                : null,
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName ?? user.email,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPri(context)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                    user.email,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSec(context)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => ref.read(authProvider.notifier).signOut(),
            icon: const Icon(Icons.logout_rounded, size: 16),
            label: const Text('Keluar'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.redAccent,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Guest card ───────────────────────────────────────────────────────────────

class _GuestCard extends StatelessWidget {
  final VoidCallback onLogin;
  const _GuestCard({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline_rounded,
                color: AppColors.primary, size: 20),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tamu',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textPri(context))),
                Text(
                  'Masuk untuk sinkronisasi data',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSec(context)),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: onLogin,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            child: const Text('Masuk'),
          ),
        ],
      ),
    );
  }
}

// ─── Theme tile ──────────────────────────────────────────────────────────────

class _ThemeTile extends StatelessWidget {
  final ThemeMode currentMode;
  final WidgetRef ref;
  const _ThemeTile({required this.currentMode, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.palette_rounded,
                    color: AppColors.primary, size: 18),
              ),
              const Gap(AppSpacing.md),
              Text('Tema Aplikasi',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPri(context))),
            ],
          ),
          const Gap(AppSpacing.sm),
          Row(
            children: [
              _ThemeChip(
                label: 'Sistem',
                icon: Icons.brightness_auto_rounded,
                selected: currentMode == ThemeMode.system,
                onTap: () => ref
                    .read(themeModeProvider.notifier)
                    .setMode(ThemeMode.system),
              ),
              const Gap(AppSpacing.sm),
              _ThemeChip(
                label: 'Terang',
                icon: Icons.light_mode_rounded,
                selected: currentMode == ThemeMode.light,
                onTap: () => ref
                    .read(themeModeProvider.notifier)
                    .setMode(ThemeMode.light),
              ),
              const Gap(AppSpacing.sm),
              _ThemeChip(
                label: 'Gelap',
                icon: Icons.dark_mode_rounded,
                selected: currentMode == ThemeMode.dark,
                onTap: () => ref
                    .read(themeModeProvider.notifier)
                    .setMode(ThemeMode.dark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _ThemeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.bgCard(context),
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderColor(context),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 14,
                color: selected ? AppColors.primary : AppColors.textSec(context)),
            const Gap(4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: selected ? AppColors.primary : AppColors.textSec(context),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Infaq card ───────────────────────────────────────────────────────────────

class _InfaqCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E8449), Color(0xFF27AE60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E8449).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.volunteer_activism_rounded,
                    color: Colors.white, size: 22),
              ),
              const Gap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Infaq Pengembangan',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Aplikasi ini sepenuhnya gratis',
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  'Segera Hadir',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Jika aplikasi ini bermanfaat, dukung kami agar terus berkembang. Setiap infaq Anda menjadi amal jariyah.',
            style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.85)),
          ),
          const Gap(AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showComingSoon(context),
              icon: const Icon(Icons.favorite_rounded, size: 16, color: Colors.white),
              label: const Text('Infaq Sekarang',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.volunteer_activism_rounded,
            color: Color(0xFF1E8449), size: 32),
        title: const Text('Segera Hadir'),
        content: const Text(
          'Fitur infaq sedang dalam pengembangan. Terima kasih atas niat baik Anda — semoga Allah mencatatnya sebagai kebaikan.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aamiin'),
          ),
        ],
      ),
    );
  }
}

// ─── Info tile ───────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _InfoTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Text(title,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textPri(context))),
          ),
          Text(subtitle,
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSec(context))),
        ],
      ),
    );
  }
}
