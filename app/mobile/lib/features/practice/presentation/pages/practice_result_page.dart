import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../playlist/domain/playlist_provider.dart';
import '../../data/practice_remote_service.dart';

class PracticeResultPage extends ConsumerStatefulWidget {
  final String playlistId;
  const PracticeResultPage({super.key, required this.playlistId});

  @override
  ConsumerState<PracticeResultPage> createState() => _PracticeResultPageState();
}

class _PracticeResultPageState extends ConsumerState<PracticeResultPage> {
  static const _quotes = [
    'Sebaik-baik kalian adalah yang mempelajari Al-Quran dan mengajarkannya. (HR. Bukhari)',
    'Bacalah Al-Quran, karena sesungguhnya ia akan datang pada hari kiamat sebagai syafaat bagi para pembacanya. (HR. Muslim)',
    'Orang yang mahir membaca Al-Quran akan bersama para malaikat yang mulia. (HR. Bukhari & Muslim)',
    'Al-Quran adalah obat bagi apa yang ada di dalam dada. (QS. Yunus: 57)',
    'Sesungguhnya Allah mengangkat derajat suatu kaum dengan kitab ini dan merendahkan yang lain. (HR. Muslim)',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(practiceProvider);
      if (session != null) {
        ref
            .read(practiceRemoteServiceProvider)
            .saveSession(session)
            .catchError((_) {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(practiceProvider);
    final playlist = ref.watch(playlistByIdProvider(widget.playlistId));

    final totalReps = session?.repetitions.values.fold(0, (a, b) => a + b) ?? 0;
    final completedCount = session?.completedIds.length ?? 0;
    final duration = session?.elapsed ?? Duration.zero;
    final quote = _quotes[DateTime.now().millisecondsSinceEpoch % _quotes.length];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          ref.read(practiceProvider.notifier).reset();
          context.go('/playlists/${widget.playlistId}');
        }
      },
      child: Scaffold(
        // backgroundColor adapts via theme
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const Gap(AppSpacing.xl),

                // Ikon celebrasi
                Container(
                  width: 120, height: 120,
                  decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.goldGradient),
                  child: const Icon(Icons.emoji_events_rounded, size: 60, color: Colors.white),
                )
                    .animate()
                    .scale(begin: const Offset(0, 0), duration: 600.ms, curve: Curves.elasticOut)
                    .then()
                    .shimmer(duration: 1200.ms, color: Colors.white38),

                const Gap(AppSpacing.lg),

                Text('Luar Biasa!', style: AppTextStyles.displayLarge.copyWith(color: AppColors.textPrimary))
                    .animate(delay: 300.ms).fadeIn().slideY(begin: 0.3),

                const Gap(AppSpacing.sm),

                Text(
                  'Sesi latihan "${playlist?.name ?? ""}" selesai',
                  style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ).animate(delay: 400.ms).fadeIn(),

                const Gap(AppSpacing.xl),

                // Stats cards
                Row(
                  children: [
                    _StatCard(
                      icon: Icons.menu_book_rounded,
                      value: '$completedCount',
                      label: 'Ayat Selesai',
                      color: AppColors.primary,
                    ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2),
                    const Gap(AppSpacing.md),
                    _StatCard(
                      icon: Icons.repeat_rounded,
                      value: '$totalReps',
                      label: 'Total Ulangan',
                      color: AppColors.accent,
                    ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),
                    const Gap(AppSpacing.md),
                    _StatCard(
                      icon: Icons.timer_outlined,
                      value: _formatDuration(duration),
                      label: 'Durasi',
                      color: AppColors.success,
                    ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2),
                  ],
                ),

                const Gap(AppSpacing.xl),

                // Quote
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.format_quote_rounded, color: AppColors.accent, size: 28),
                      const Gap(AppSpacing.sm),
                      Text(
                        quote,
                        style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate(delay: 800.ms).fadeIn(),

                const Gap(AppSpacing.xl),

                AppButton.filled(
                  label: 'Kembali ke Playlist',
                  icon: Icons.arrow_back_rounded,
                  onPressed: () {
                    ref.read(practiceProvider.notifier).reset();
                    context.go('/playlists/${widget.playlistId}');
                  },
                ).animate(delay: 900.ms).fadeIn().slideY(begin: 0.2),

                const Gap(AppSpacing.md),

                AppButton.outlined(
                  label: 'Ulangi Latihan',
                  icon: Icons.replay_rounded,
                  onPressed: () {
                    final p = ref.read(playlistByIdProvider(widget.playlistId));
                    if (p != null) {
                      ref.read(practiceProvider.notifier).start(p);
                      context.go('/playlists/${widget.playlistId}/practice');
                    }
                  },
                ).animate(delay: 950.ms).fadeIn().slideY(begin: 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    if (m == 0) return '${s}d';
    return '${m}m ${s}d';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const Gap(AppSpacing.sm),
            Text(value, style: AppTextStyles.titleCard.copyWith(color: color)),
            Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
