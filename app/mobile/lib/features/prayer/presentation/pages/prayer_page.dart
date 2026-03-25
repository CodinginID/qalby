import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/prayer_times_model.dart';
import '../../domain/prayer_provider.dart';

class PrayerPage extends ConsumerWidget {
  const PrayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerAsync = ref.watch(prayerTimesProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
      body: prayerAsync.when(
        loading: () => const _LoadingView(),
        error: (e, _) => _ErrorView(message: e.toString()),
        data: (times) => _PrayerContent(times: times),
      ),
      ),
    );
  }
}

// ─── Loading ───────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.accent),
            Gap(AppSpacing.md),
            Text('Mendeteksi lokasi...', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

// ─── Error ─────────────────────────────────────────────────────────────────────

class _ErrorView extends ConsumerWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off_rounded, color: AppColors.accent, size: 64),
              const Gap(AppSpacing.lg),
              Text(
                'Lokasi tidak tersedia',
                style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const Gap(AppSpacing.sm),
              Text(
                message.replaceAll('Exception: ', ''),
                style: AppTextStyles.bodyRegular.copyWith(color: Colors.white60),
                textAlign: TextAlign.center,
              ),
              const Gap(AppSpacing.xl),
              FilledButton.icon(
                onPressed: () => ref.invalidate(locationProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Main content ──────────────────────────────────────────────────────────────

class _PrayerContent extends ConsumerWidget {
  final PrayerTimesModel times;
  const _PrayerContent({required this.times});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifPrefs = ref.watch(notificationPrefsProvider);

    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: () async => ref.invalidate(prayerTimesProvider),
      child: CustomScrollView(
      slivers: [
        // Header: next prayer countdown
        SliverToBoxAdapter(
          child: _NextPrayerHeader(times: times)
              .animate()
              .fadeIn(duration: 400.ms),
        ),

        // Prayer list
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
          sliver: SliverList.separated(
            separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
            itemCount: PrayerTimesModel.prayerNames.length,
            itemBuilder: (_, i) {
              final name = PrayerTimesModel.prayerNames[i];
              final time = times.times[i];
              final icon = PrayerTimesModel.prayerIcons[i];
              final isNext = times.nextPrayer?.index == i;
              final isPast = time.isBefore(DateTime.now());
              final isEnabled = notifPrefs[name] ?? true;

              return _PrayerCard(
                name: name,
                time: time,
                icon: icon,
                isNext: isNext,
                isPast: isPast,
                notifEnabled: isEnabled,
                prayerIndex: i,
                onToggle: () async {
                  await ref.read(notificationPrefsProvider.notifier).toggle(name);
                  final updatedPrefs = ref.read(notificationPrefsProvider);
                  await NotificationService.instance
                      .scheduleAdzanNotifications(times, updatedPrefs);
                },
              ).animate(delay: (i * 60).ms).fadeIn(duration: 300.ms).slideY(begin: 0.05);
            },
          ),
        ),
      ],
      ),
    );
  }
}

// ─── Next prayer header ────────────────────────────────────────────────────────

class _NextPrayerHeader extends ConsumerWidget {
  final PrayerTimesModel times;
  const _NextPrayerHeader({required this.times});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = times.nextPrayer;
    final countdown = ref.watch(prayerCountdownProvider).value;

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        MediaQuery.of(context).padding.top + AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Column(
        children: [
          // Location row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 14),
              const Gap(4),
              Text(
                'Lokasi Kamu',
                style: AppTextStyles.caption.copyWith(color: AppColors.accent),
              ),
            ],
          ),
          const Gap(AppSpacing.lg),

          if (next == null) ...[
            Text(
              'Selamat',
              style: AppTextStyles.caption.copyWith(color: Colors.white70),
            ),
            const Gap(AppSpacing.xs),
            Text(
              'Semua Sholat Selesai',
              style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
            ),
            const Gap(AppSpacing.sm),
            Text(
              'Alhamdulillah hari ini',
              style: AppTextStyles.bodyRegular.copyWith(color: Colors.white60),
            ),
          ] else ...[
            Text(
              'Sholat Berikutnya',
              style: AppTextStyles.caption.copyWith(color: Colors.white70),
            ),
            const Gap(AppSpacing.sm),
            Text(
              next.name,
              style: AppTextStyles.displayLarge.copyWith(color: Colors.white),
            ),
            Text(
              DateFormat('HH:mm').format(next.time),
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.accent,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(AppSpacing.sm),
            if (countdown != null && countdown > Duration.zero)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Text(
                  _formatCountdown(countdown),
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
          ],
          const Gap(AppSpacing.lg),
          Text(
            'Jadwal Hari Ini · ${DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.now())}',
            style: AppTextStyles.labelSmall.copyWith(color: Colors.white38),
          ),
        ],
      ),
    );
  }

  String _formatCountdown(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '$h jam $m menit lagi';
    if (m > 0) return '$m menit $s detik lagi';
    return '$s detik lagi';
  }
}

// ─── Prayer card ───────────────────────────────────────────────────────────────

// Per-prayer accent colors (time-of-day palette)
const _prayerColors = [
  Color(0xFF3A7BD5), // Subuh  — blue dawn
  Color(0xFFE8A833), // Dzuhur — gold midday
  Color(0xFF2196A3), // Ashar  — teal afternoon
  Color(0xFFE07B39), // Maghrib— orange dusk
  Color(0xFF6C3483), // Isya   — purple night
];

class _PrayerCard extends StatelessWidget {
  final String name;
  final DateTime time;
  final IconData icon;
  final bool isNext;
  final bool isPast;
  final bool notifEnabled;
  final VoidCallback onToggle;
  final int prayerIndex;

  const _PrayerCard({
    required this.name,
    required this.time,
    required this.icon,
    required this.isNext,
    required this.isPast,
    required this.notifEnabled,
    required this.onToggle,
    required this.prayerIndex,
  });

  Color get _color => _prayerColors[prayerIndex % _prayerColors.length];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: isNext ? _color.withValues(alpha: 0.06) : AppColors.bgCard(context),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isNext ? _color.withValues(alpha: 0.5) : AppColors.divider,
          width: isNext ? 1.5 : 1,
        ),
        boxShadow: isNext
            ? [BoxShadow(color: _color.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))]
            : null,
      ),
      child: Row(
        children: [
          // Icon container with per-prayer color
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: isPast
                  ? AppColors.surface
                  : _color.withValues(alpha: isNext ? 0.18 : 0.1),
              shape: BoxShape.circle,
              border: isNext
                  ? Border.all(color: _color.withValues(alpha: 0.3))
                  : null,
            ),
            child: Icon(
              icon, size: 20,
              color: isPast ? AppColors.textHint : _color,
            ),
          ),
          const Gap(AppSpacing.md),

          // Name + label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isPast ? AppColors.textHint : AppColors.textPrimary,
                    fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (isNext)
                  Row(children: [
                    Container(
                      width: 6, height: 6,
                      decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
                    ),
                    const Gap(4),
                    Text('Berikutnya',
                        style: AppTextStyles.labelSmall.copyWith(color: _color, fontSize: 10)),
                  ])
                else if (isPast)
                  Text('Sudah lewat',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint, fontSize: 10)),
              ],
            ),
          ),

          // Time
          Text(
            DateFormat('HH:mm').format(time),
            style: TextStyle(
              color: isPast ? AppColors.textHint : (isNext ? _color : AppColors.textPrimary),
              fontSize: isNext ? 20 : 16,
              fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
              fontFamily: 'Nunito',
            ),
          ),
          const Gap(AppSpacing.xs),

          // Notif toggle
          Semantics(
            label: 'Notifikasi $name',
            value: notifEnabled ? 'aktif' : 'nonaktif',
            child: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: notifEnabled,
                onChanged: isPast ? null : (_) => onToggle(),
                activeThumbColor: _color,
                activeTrackColor: _color.withValues(alpha: 0.3),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
