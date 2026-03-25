import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/arabic_text.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../data/playlist_model.dart';
import '../../domain/playlist_provider.dart';

class PlaylistDetailPage extends ConsumerWidget {
  final String id;
  const PlaylistDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlist = ref.watch(playlistByIdProvider(id));

    if (playlist == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Playlist tidak ditemukan')));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.playlist_add_rounded, color: Colors.white),
                tooltip: 'Tambah Ayat',
                onPressed: () => context.push('/playlists/$id/add-ayat'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 80, AppSpacing.lg, AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(playlist.name, style: AppTextStyles.displayLarge.copyWith(color: Colors.white)),
                              if (playlist.description.isNotEmpty) ...[
                                const Gap(AppSpacing.xs),
                                Text(playlist.description, style: AppTextStyles.bodyRegular.copyWith(color: Colors.white70)),
                              ],
                            ],
                          ),
                        ),
                        // Progress ring
                        if (playlist.items.isNotEmpty)
                          Semantics(
                            label: 'Progress hafalan ${(playlist.progressPercent * 100).round()}%',
                            child: _ProgressRing(progress: playlist.progressPercent),
                          ),
                      ],
                    ),
                    const Gap(AppSpacing.md),
                    Row(
                      children: [
                        _StatChip(label: '${playlist.items.length} item'),
                        const Gap(AppSpacing.sm),
                        _StatChip(label: '${playlist.totalAyat} ayat'),
                        const Gap(AppSpacing.sm),
                        if (playlist.totalPracticed > 0)
                          _StatChip(label: '${playlist.totalPracticed}x latihan'),
                        const Gap(AppSpacing.sm),
                        if (playlist.items.isNotEmpty)
                          _StatChip(label: '~${playlist.items.length * 3} menit'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tombol mulai / lanjutkan latihan
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AppButton.filled(
                label: playlist.totalPracticed > 0 ? 'Lanjutkan Latihan' : 'Mulai Latihan',
                icon: playlist.totalPracticed > 0
                    ? Icons.play_circle_filled_rounded
                    : Icons.play_arrow_rounded,
                onPressed: playlist.items.isEmpty
                    ? null
                    : () => context.push('/playlists/$id/practice'),
              ),
            ),
          ),

          // List ayat (reorderable)
          playlist.items.isEmpty
              ? SliverToBoxAdapter(
                  child: EmptyStateWidget(
                    title: 'Playlist masih kosong',
                    subtitle: 'Tambahkan ayat dari browser Al-Quran',
                    action: AppButton.outlined(
                      label: 'Tambah Ayat',
                      fullWidth: false,
                      onPressed: () => context.push('/playlists/$id/add-ayat'),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  sliver: SliverToBoxAdapter(
                    child: ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > oldIndex) newIndex--;
                        ref.read(playlistsProvider.notifier).reorderItems(id, oldIndex, newIndex);
                      },
                      itemCount: playlist.items.length,
                      itemBuilder: (_, i) {
                        final item = playlist.items[i];
                        return Dismissible(
                          key: ValueKey(item.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: AppSpacing.lg),
                            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: const Icon(Icons.delete_rounded, color: Colors.white),
                          ),
                          onDismissed: (_) =>
                              ref.read(playlistsProvider.notifier).removeItem(id, item.id),
                          child: _PlaylistItemTile(
                            item: item,
                            index: i,
                            onDelete: () => ref.read(playlistsProvider.notifier).removeItem(id, item.id),
                          ).animate(delay: (i * 40).ms).fadeIn(duration: 250.ms),
                        );
                      },
                    ),
                  ),
                ),
          const SliverToBoxAdapter(child: Gap(AppSpacing.xxl)),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final double progress; // 0.0 – 1.0
  const _ProgressRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: _RingPainter(progress: progress),
        child: Center(
          child: Text(
            '${(progress * 100).round()}%',
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;
    const startAngle = -math.pi / 2;

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final fgPaint = Paint()
        ..color = AppColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        2 * math.pi * progress,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

class _StatChip extends StatelessWidget {
  final String label;
  const _StatChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white)),
    );
  }
}

class _PlaylistItemTile extends StatelessWidget {
  final PlaylistItem item;
  final int index;
  final VoidCallback onDelete;

  const _PlaylistItemTile({
    super.key,
    required this.item,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.sm),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            const Icon(Icons.drag_handle_rounded, color: AppColors.textHint, size: 20),
            const Gap(AppSpacing.sm),
            // Nomor urut
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text('${index + 1}', style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 10)),
            ),
          ],
        ),
        title: Text(item.surahName, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPri(context))),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.rangeLabel, style: AppTextStyles.caption.copyWith(color: AppColors.textSec(context))),
            ArabicText(
              text: item.surahNameArabic,
              style: AppTextStyles.arabicSmall.copyWith(color: AppColors.primary, fontSize: 14),
              maxLines: 1,
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
          onPressed: onDelete,
        ),
        isThreeLine: true,
      ),
    );
  }
}
