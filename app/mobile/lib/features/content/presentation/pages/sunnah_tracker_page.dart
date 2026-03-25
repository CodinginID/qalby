import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/sunnah_data.dart';
import '../../data/content_models.dart';
import '../../domain/sunnah_tracker_provider.dart';

class SunnahTrackerPage extends ConsumerWidget {
  const SunnahTrackerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checked = ref.watch(sunnahTrackerProvider);
    final notifier = ref.read(sunnahTrackerProvider.notifier);
    final total = SunnahData.items.length;
    final done = checked.length;
    final progress = total > 0 ? done / total : 0.0;

    // Group by category
    final Map<String, List<SunnahItem>> grouped = {};
    for (final item in SunnahData.items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    return Scaffold(
      // backgroundColor adapts via theme
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 60,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            title:
                const Text('Sunnah Tracker', style: TextStyle(color: Colors.white)),
            iconTheme: const IconThemeData(color: Colors.white),
          ),

          // Progress header
          SliverToBoxAdapter(
            child: _ProgressHeader(
              done: done,
              total: total,
              progress: progress,
            ).animate().fadeIn(duration: 400.ms),
          ),

          // List per category
          for (final entry in grouped.entries) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _categoryColor(entry.key),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Gap(AppSpacing.sm),
                    Text(
                      entry.key,
                      style: AppTextStyles.titleCard
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    const Gap(AppSpacing.sm),
                    Text(
                      '${entry.value.where((i) => checked.contains(i.id)).length}/${entry.value.length}',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textHint),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverList.separated(
                separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
                itemCount: entry.value.length,
                itemBuilder: (_, i) {
                  final item = entry.value[i];
                  final isChecked = checked.contains(item.id);
                  return _SunnahCard(
                    item: item,
                    isChecked: isChecked,
                    onToggle: () => notifier.toggle(item.id),
                  )
                      .animate(delay: (i * 50).ms)
                      .fadeIn(duration: 300.ms);
                },
              ),
            ),
          ],

          const SliverToBoxAdapter(child: Gap(AppSpacing.xxl)),
        ],
      ),
    );
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Ibadah':
        return AppColors.primary;
      case 'Adab':
        return AppColors.success;
      default:
        return const Color(0xFFC9A84C);
    }
  }
}

// ─── Progress header ───────────────────────────────────────────────────────────

class _ProgressHeader extends StatelessWidget {
  final int done;
  final int total;
  final double progress;

  const _ProgressHeader({
    required this.done,
    required this.total,
    required this.progress,
  });

  String get _motivasiText {
    if (progress == 0) return 'Mulai hari ini dengan sunnah 🌟';
    if (progress < 0.4) return 'Bagus! Terus semangat';
    if (progress < 0.7) return 'Luar biasa! Hampir setengahnya';
    if (progress < 1.0) return 'MasyaAllah! Hampir sempurna';
    return 'Alhamdulillah! Semua sunnah terlaksana ✨';
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.now());

    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(today,
              style: AppTextStyles.caption.copyWith(color: Colors.white54)),
          const Gap(AppSpacing.xs),
          Text(
            _motivasiText,
            style: AppTextStyles.titleCard.copyWith(color: Colors.white),
          ),
          const Gap(AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.accent),
                    minHeight: 8,
                  ),
                ),
              ),
              const Gap(AppSpacing.md),
              Text(
                '$done/$total',
                style: AppTextStyles.titleCard.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Sunnah card ───────────────────────────────────────────────────────────────

class _SunnahCard extends StatefulWidget {
  final SunnahItem item;
  final bool isChecked;
  final VoidCallback onToggle;

  const _SunnahCard({
    required this.item,
    required this.isChecked,
    required this.onToggle,
  });

  @override
  State<_SunnahCard> createState() => _SunnahCardState();
}

class _SunnahCardState extends State<_SunnahCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: widget.isChecked
              ? AppColors.success.withValues(alpha: 0.06)
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: widget.isChecked ? AppColors.success : AppColors.divider,
            width: widget.isChecked ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Check button
                GestureDetector(
                  onTap: widget.onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: widget.isChecked
                          ? AppColors.success
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isChecked
                            ? AppColors.success
                            : AppColors.textHint,
                        width: 2,
                      ),
                    ),
                    child: widget.isChecked
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 16)
                            .animate(key: const ValueKey('check'))
                            .scale(
                              begin: const Offset(0, 0),
                              end: const Offset(1, 1),
                              duration: 200.ms,
                              curve: Curves.elasticOut,
                            )
                        : null,
                  ),
                ),
                const Gap(AppSpacing.md),

                // Icon + name
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.item.icon,
                      color: AppColors.primary, size: 18),
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: widget.isChecked
                              ? AppColors.success
                              : AppColors.textPrimary,
                          decoration: widget.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      Text(
                        widget.item.category,
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.textHint),
                      ),
                    ],
                  ),
                ),

                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
              ],
            ),

            // Expanded detail
            if (_expanded) ...[
              const Gap(AppSpacing.sm),
              Divider(color: AppColors.divider, height: 1),
              const Gap(AppSpacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.item.description,
                  style: AppTextStyles.bodyRegular
                      .copyWith(color: AppColors.textSecondary, height: 1.5),
                ),
              ),
              const Gap(AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.accent, size: 14),
                    const Gap(AppSpacing.xs),
                    Expanded(
                      child: Text(
                        widget.item.reward,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
