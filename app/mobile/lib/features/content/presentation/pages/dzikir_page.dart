import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/dzikir_data.dart';
import '../../data/content_models.dart';

class DzikirPage extends StatefulWidget {
  const DzikirPage({super.key});

  @override
  State<DzikirPage> createState() => _DzikirPageState();
}

class _DzikirPageState extends State<DzikirPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessions = [DzikirData.pagi, DzikirData.petang];

    return Scaffold(
      // backgroundColor adapts via theme
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 60,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('Dzikir', style: TextStyle(color: Colors.white)),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.accent,
              labelColor: AppColors.accent,
              unselectedLabelColor: Colors.white54,
              tabs: sessions
                  .map((s) => Tab(
                        icon: Icon(s.icon, size: 18),
                        text: s.name,
                      ))
                  .toList(),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: sessions
              .map((session) => _DzikirSessionView(session: session))
              .toList(),
        ),
      ),
    );
  }
}

// ─── Session view ──────────────────────────────────────────────────────────────

class _DzikirSessionView extends StatefulWidget {
  final DzikirSession session;
  const _DzikirSessionView({required this.session});

  @override
  State<_DzikirSessionView> createState() => _DzikirSessionViewState();
}

class _DzikirSessionViewState extends State<_DzikirSessionView> {
  late List<int> _counts;

  @override
  void initState() {
    super.initState();
    _counts = List.filled(widget.session.items.length, 0);
  }

  void _resetAll() {
    setState(() => _counts = List.filled(widget.session.items.length, 0));
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.session.items.length;
    // Count items where count >= recommended
    int completed = 0;
    for (int i = 0; i < _counts.length; i++) {
      if (_counts[i] >= widget.session.items[i].recommendedCount) completed++;
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Progress header
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Icon(widget.session.icon, color: AppColors.accent, size: 28),
              const Gap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.session.name,
                      style: AppTextStyles.titleCard
                          .copyWith(color: Colors.white),
                    ),
                    Text(
                      '$completed / $total selesai',
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white60),
                    ),
                    const Gap(4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      child: LinearProgressIndicator(
                        value: total > 0 ? completed / total : 0,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _resetAll,
                child: Text(
                  'Reset',
                  style: AppTextStyles.caption.copyWith(color: Colors.white54),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms),

        const Gap(AppSpacing.md),

        ...widget.session.items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return _DzikirCard(
            item: item,
            count: _counts[i],
            onTap: () {
              setState(() {
                if (_counts[i] < item.recommendedCount) {
                  _counts[i]++;
                }
              });
            },
            onReset: () => setState(() => _counts[i] = 0),
          )
              .animate(delay: (i * 60).ms)
              .fadeIn(duration: 300.ms);
        }),
      ],
    );
  }
}

// ─── Dzikir card ───────────────────────────────────────────────────────────────

class _DzikirCard extends StatefulWidget {
  final DzikirItem item;
  final int count;
  final VoidCallback onTap;
  final VoidCallback onReset;

  const _DzikirCard({
    required this.item,
    required this.count,
    required this.onTap,
    required this.onReset,
  });

  @override
  State<_DzikirCard> createState() => _DzikirCardState();
}

class _DzikirCardState extends State<_DzikirCard> {
  bool _pressed = false;

  bool get _done => widget.count >= widget.item.recommendedCount;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final count = widget.count;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: _done
              ? AppColors.success.withValues(alpha: 0.06)
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: _done ? AppColors.success : AppColors.divider,
            width: _done ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Progress fill arc
            Align(
              alignment: Alignment.centerRight,
              child: TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: 0,
                  end: item.recommendedCount > 0
                      ? (count / item.recommendedCount).clamp(0.0, 1.0)
                      : 0.0,
                ),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                builder: (_, val, __) => SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    value: val,
                    strokeWidth: 3,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _done ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.xs),
            // Arabic text
            Text(
              item.arabic,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 19,
                color: _done
                    ? AppColors.success
                    : AppColors.textPrimary,
                height: 1.9,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            const Gap(AppSpacing.xs),
            // Latin
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.latin,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const Gap(AppSpacing.xs),
            // Translation
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.translation,
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textHint),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const Gap(AppSpacing.sm),
            Divider(color: AppColors.divider, height: 1),
            const Gap(AppSpacing.sm),

            // Counter row
            Row(
              children: [
                Text(
                  item.source,
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.textHint),
                ),
                const Spacer(),
                if (count > 0)
                  GestureDetector(
                    onTap: widget.onReset,
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: Icon(Icons.refresh_rounded,
                          size: 16, color: AppColors.textHint),
                    ),
                  ),
                // Counter badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 4),
                  decoration: BoxDecoration(
                    color: _done
                        ? AppColors.success.withValues(alpha: 0.12)
                        : AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(
                      color: _done
                          ? AppColors.success.withValues(alpha: 0.4)
                          : AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_done)
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.success, size: 14)
                      else
                        Icon(Icons.touch_app_rounded,
                            color: AppColors.primary, size: 14),
                      const Gap(4),
                      Text(
                        _done
                            ? 'Selesai'
                            : '$count / ${item.recommendedCount}x',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: _done ? AppColors.success : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}
