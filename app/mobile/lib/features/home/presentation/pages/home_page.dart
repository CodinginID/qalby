import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/coach_mark.dart';
import '../../../playlist/domain/playlist_provider.dart';
import '../../../playlist/data/playlist_model.dart';
import '../../../prayer/domain/prayer_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _settingsKey = GlobalKey();
  final _playlistKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final show = await CoachMarkController.shouldShow('home_tour');
      if (show && mounted) {
        CoachMarkController.show(
          context,
          id: 'home_tour',
          marks: [
            CoachMark(
              targetKey: _settingsKey,
              title: 'Profil',
              body: 'Lihat profil, ubah tampilan, dan dukung pengembangan aplikasi.',
              position: CalloutPosition.below,
            ),
            CoachMark(
              targetKey: _playlistKey,
              title: 'Playlist Hafalan',
              body: 'Buat dan kelola playlist ayat yang ingin kamu hafal.',
              position: CalloutPosition.above,
            ),
          ],
        );
      }
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 5)  return 'Assalamu\'alaikum';
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  String _getHijriDate() {
    final hijri = HijriCalendar.now();
    const months = ['Muharram','Safar','Rabiul Awwal','Rabiul Akhir','Jumadil Awwal',
      'Jumadil Akhir','Rajab','Sya\'ban','Ramadhan','Syawal','Dzulqa\'dah','Dzulhijjah'];
    return '${hijri.hDay} ${months[hijri.hMonth - 1]} ${hijri.hYear} H';
  }

  @override
  Widget build(BuildContext context) {
    final playlists = ref.watch(playlistsProvider);
    final totalAyat     = playlists.fold<int>(0, (sum, p) => sum + p.items.length);
    final totalPracticed = playlists.fold<int>(0, (sum, p) => sum + p.totalPracticed);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primaryDark,
            actions: [
              IconButton(
                key: _settingsKey,
                icon: const Icon(Icons.account_circle_rounded, color: Colors.white),
                tooltip: 'Profil',
                onPressed: () => context.push('/profile'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _HomeHeader(
                greeting: _getGreeting(),
                hijriDate: _getHijriDate(),
                totalAyat: totalAyat,
                doneAyat: totalPracticed,
                playlistCount: playlists.length,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prayer card
                  _PrayerQuickCard().animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                  const Gap(AppSpacing.lg),

                  // Quick actions
                  Text('Menu Utama', style: AppTextStyles.titleCard.copyWith(color: AppColors.textPrimary)),
                  const Gap(AppSpacing.md),
                  _QuickActionBar(),
                  const Gap(AppSpacing.lg),

                  // Playlist terbaru
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Playlist Terbaru', key: _playlistKey, style: AppTextStyles.titleCard.copyWith(color: AppColors.textPrimary)),
                      TextButton(
                        onPressed: () => context.go('/playlists'),
                        child: Text('Lihat Semua', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.sm),
                  if (playlists.isEmpty)
                    _EmptyPlaylistCard()
                  else
                    SizedBox(
                      height: 130,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: playlists.take(5).length,
                        itemBuilder: (_, i) {
                          final p = playlists[i];
                          return _PlaylistMiniCard(playlist: p, index: i)
                              .animate(delay: (i * 60).ms).fadeIn(duration: 300.ms).slideX(begin: 0.1);
                        },
                      ),
                    ),
                  const Gap(AppSpacing.lg),

                  // Konten Islam
                  Text('Konten Islami', style: AppTextStyles.titleCard.copyWith(color: AppColors.textPrimary)),
                  const Gap(AppSpacing.md),
                  _ContentGrid(),
                  const Gap(AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  final String greeting;
  final String hijriDate;
  final int totalAyat;
  final int doneAyat;
  final int playlistCount;

  const _HomeHeader({
    required this.greeting,
    required this.hijriDate,
    required this.totalAyat,
    required this.doneAyat,
    required this.playlistCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
      child: SafeArea(
        child: Stack(
          children: [
            // Ornamen background
            Positioned(
              right: -40, top: -20,
              child: Opacity(
                opacity: 0.05,
                child: _IslamicStarPattern(size: 200),
              ),
            ),
            Positioned(
              left: -30, bottom: -10,
              child: Opacity(
                opacity: 0.04,
                child: _IslamicStarPattern(size: 140),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(AppSpacing.sm),
                Text(greeting, style: AppTextStyles.caption.copyWith(color: Colors.white60))
                    .animate().fadeIn(duration: 400.ms),
                const Gap(AppSpacing.xs),
                Text('Hamba Allah', style: AppTextStyles.headingMedium.copyWith(color: Colors.white))
                    .animate(delay: 80.ms).fadeIn().slideX(begin: -0.04),
                const Gap(AppSpacing.sm),
                Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.accent),
                  const Gap(4),
                  Text(hijriDate, style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent)),
                ]).animate(delay: 120.ms).fadeIn(),
                const Gap(AppSpacing.lg),
                // Stats row
                Row(
                  children: [
                    _StatBadge(icon: Icons.bookmark_rounded, value: '$playlistCount', label: 'Playlist'),
                    const Gap(AppSpacing.md),
                    _StatBadge(icon: Icons.auto_stories_rounded, value: '$totalAyat', label: 'Ayat'),
                    const Gap(AppSpacing.md),
                    _StatBadge(
                      icon: Icons.check_circle_rounded,
                      value: '$doneAyat',
                      label: 'Latihan',
                      highlight: true,
                    ),
                  ],
                ).animate(delay: 160.ms).fadeIn().slideY(begin: 0.1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool highlight;

  const _StatBadge({
    required this.icon,
    required this.value,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.accent.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: highlight
              ? AppColors.accent.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: highlight ? AppColors.accent : Colors.white70),
          const Gap(6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: AppTextStyles.labelSmall.copyWith(
                color: highlight ? AppColors.accent : Colors.white,
                fontWeight: FontWeight.w700,
              )),
              Text(label, style: AppTextStyles.labelSmall.copyWith(
                color: highlight ? AppColors.accentLight : Colors.white54,
                fontSize: 9,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

// Islamic geometric star painter
class _IslamicStarPattern extends StatelessWidget {
  final double size;
  const _IslamicStarPattern({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _StarPainter(),
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // 8-pointed star
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * pi / 4) - pi / 2;
      final nextAngle = angle + pi / 8;
      final outer = Offset(cx + r * cos(angle), cy + r * sin(angle));
      final inner = Offset(cx + r * 0.4 * cos(nextAngle), cy + r * 0.4 * sin(nextAngle));
      if (i == 0) {
        path.moveTo(outer.dx, outer.dy);
      } else {
        path.lineTo(outer.dx, outer.dy);
      }
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    canvas.drawPath(path, paint);

    // Inner circle
    canvas.drawCircle(Offset(cx, cy), r * 0.3, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Prayer quick card ─────────────────────────────────────────────────────────

class _PrayerQuickCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerAsync = ref.watch(prayerTimesProvider);
    final countdown = ref.watch(prayerCountdownProvider).value;

    final next = prayerAsync.value?.nextPrayer;
    final nextName = next?.name ?? 'Selesai';
    final nextTime = next != null ? DateFormat('HH:mm').format(next.time) : '--:--';
    final countdownText = _formatCountdown(countdown);

    return GestureDetector(
      onTap: () => context.go('/prayer'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
              ),
              child: prayerAsync.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
                    )
                  : const Icon(Icons.access_time_filled, color: AppColors.accent, size: 22),
            ),
            const Gap(AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sholat Berikutnya', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                  Text('$nextName · $nextTime', style: AppTextStyles.titleCard.copyWith(color: Colors.white)),
                ],
              ),
            ),
            if (countdownText.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
                ),
                child: Text(countdownText, style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent)),
              ),
            const Gap(AppSpacing.sm),
            const Icon(Icons.chevron_right, color: Colors.white54, size: 18),
          ],
        ),
      ),
    );
  }

  String _formatCountdown(Duration? d) {
    if (d == null || d <= Duration.zero) return '';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '${h}j ${m}m';
    return '${m}m';
  }
}

// ─── Quick action bar ──────────────────────────────────────────────────────────

class _QuickActionBar extends StatelessWidget {
  static const _actions = [
    _Action(Icons.menu_book_rounded,    'Quran',    '/quran',    AppColors.primary),
    _Action(Icons.playlist_play_rounded,'Playlist', '/playlists',Color(0xFF1E8449)),
    _Action(Icons.explore_rounded,      'Qibla',    '/qibla',    Color(0xFF6C3483)),
    _Action(Icons.access_time_rounded,  'Sholat',   '/prayer',   Color(0xFFC9A84C)),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _actions.asMap().entries.map((e) {
        return _ActionCard(action: e.value)
            .animate(delay: (e.key * 60).ms)
            .fadeIn(duration: 300.ms)
            .scale(begin: const Offset(0.8, 0.8));
      }).toList(),
    );
  }
}

class _Action {
  final IconData icon;
  final String label;
  final String route;
  final Color color;
  const _Action(this.icon, this.label, this.route, this.color);
}

class _ActionCard extends StatelessWidget {
  final _Action action;
  const _ActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(action.route),
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(action.icon, color: action.color, size: 22),
            ),
            const Gap(AppSpacing.sm),
            Text(action.label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// ─── Playlist mini card ────────────────────────────────────────────────────────

class _PlaylistMiniCard extends StatelessWidget {
  final Playlist playlist;
  final int index;
  const _PlaylistMiniCard({required this.playlist, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/playlists/${playlist.id}'),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: AppColors.playlistGradientAt(index),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.playlistGradientAt(index).colors.first.withValues(alpha: 0.3),
              blurRadius: 8, offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(playlist.name, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                maxLines: 2, overflow: TextOverflow.ellipsis),
            const Spacer(),
            Text('${playlist.items.length} ayat', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
            const Gap(4),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: playlist.progressPercent,
                backgroundColor: Colors.white30,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPlaylistCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/playlists'),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline_rounded, color: AppColors.textHint, size: 24),
            const Gap(AppSpacing.sm),
            Text('Buat playlist pertamamu', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }
}

// ─── Content grid ──────────────────────────────────────────────────────────────

class _ContentGrid extends StatelessWidget {
  static const _items = [
    _ContentItem(Icons.format_quote_rounded,      'Motivasi',       Color(0xFF1A5276), '/motivasi',       'Quotes harian'),
    _ContentItem(Icons.volunteer_activism_rounded, 'Doa',            Color(0xFF1E8449), '/doa',            'Doa pilihan'),
    _ContentItem(Icons.auto_stories_rounded,       'Kisah Nabi',     Color(0xFFC9A84C), '/kisah-nabi',     '25 Nabi & Rasul'),
    _ContentItem(Icons.self_improvement_rounded,   'Dzikir',         Color(0xFF6C3483), '/dzikir',         'Pagi & Petang'),
    _ContentItem(Icons.checklist_rounded,          'Sunnah Tracker', Color(0xFF117A65), '/sunnah-tracker', 'Checklist harian'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row pertama: 2 item besar
        Row(
          children: [
            Expanded(child: _ContentCard(item: _items[0], index: 0)),
            const Gap(AppSpacing.md),
            Expanded(child: _ContentCard(item: _items[1], index: 1)),
          ],
        ),
        const Gap(AppSpacing.md),
        // Row kedua: 3 item kecil
        Row(
          children: [
            Expanded(child: _ContentCard(item: _items[2], index: 2, compact: true)),
            const Gap(AppSpacing.sm),
            Expanded(child: _ContentCard(item: _items[3], index: 3, compact: true)),
            const Gap(AppSpacing.sm),
            Expanded(child: _ContentCard(item: _items[4], index: 4, compact: true)),
          ],
        ),
      ],
    );
  }
}

class _ContentCard extends StatelessWidget {
  final _ContentItem item;
  final int index;
  final bool compact;

  const _ContentCard({required this.item, required this.index, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(item.route),
      child: Container(
        padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
        decoration: BoxDecoration(
          color: item.color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: item.color.withValues(alpha: 0.18)),
        ),
        child: compact
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: item.color, size: 18),
                  ),
                  const Gap(6),
                  Text(item.label, style: AppTextStyles.labelSmall.copyWith(color: item.color),
                      textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(item.icon, color: item.color, size: 22),
                  ),
                  const Gap(AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.label, style: AppTextStyles.bodyMedium.copyWith(color: item.color)),
                        Text(item.subtitle, style: AppTextStyles.labelSmall.copyWith(color: item.color.withValues(alpha: 0.6))),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    ).animate(delay: (index * 70).ms).fadeIn(duration: 300.ms).slideY(begin: 0.05);
  }
}

class _ContentItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  final String subtitle;
  const _ContentItem(this.icon, this.label, this.color, this.route, this.subtitle);
}
