import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/motivasi_data.dart';
import '../../data/content_models.dart';

class MotivasiPage extends StatefulWidget {
  const MotivasiPage({super.key});

  @override
  State<MotivasiPage> createState() => _MotivasiPageState();
}

class _MotivasiPageState extends State<MotivasiPage> {
  String _filter = 'Semua';
  static const _filters = ['Semua', 'Quran', 'Hadith', 'Ulama'];

  List<MotivationQuote> get _filtered {
    if (_filter == 'Semua') return MotivasiData.quotes;
    return MotivasiData.quotes.where((q) => q.category == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final daily = MotivasiData.dailyQuote();

    return Scaffold(
      // backgroundColor adapts via theme
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 60,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            title: const Text('Motivasi Islam', style: TextStyle(color: Colors.white)),
            iconTheme: const IconThemeData(color: Colors.white),
          ),

          // Daily quote card
          SliverToBoxAdapter(
            child: _DailyQuoteCard(quote: daily)
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.05),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Semua Quotes',
                      style: AppTextStyles.titleCard
                          .copyWith(color: AppColors.textPrimary)),
                  const Gap(AppSpacing.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((f) {
                        final selected = _filter == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: FilterChip(
                            label: Text(f),
                            selected: selected,
                            onSelected: (_) => setState(() => _filter = f),
                            selectedColor: AppColors.primary.withValues(alpha: 0.15),
                            checkmarkColor: AppColors.primary,
                            labelStyle: AppTextStyles.caption.copyWith(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quotes list or empty state
          _filtered.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 64,
                            color: AppColors.textHint.withValues(alpha: 0.4)),
                        const Gap(AppSpacing.md),
                        Text('Tidak ada kutipan untuk kategori ini',
                            style: AppTextStyles.bodyRegular
                                .copyWith(color: AppColors.textHint)),
                        const Gap(AppSpacing.sm),
                        TextButton(
                          onPressed: () => setState(() => _filter = 'Semua'),
                          child: const Text('Tampilkan Semua'),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  sliver: SliverList.separated(
                    separatorBuilder: (_, __) => const Gap(AppSpacing.md),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _QuoteCard(quote: _filtered[i])
                        .animate(delay: (i * 50).ms)
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.05),
                  ),
                ),
        ],
      ),
    );
  }
}

// ─── Daily quote card ──────────────────────────────────────────────────────────

class _DailyQuoteCard extends StatelessWidget {
  final MotivationQuote quote;
  const _DailyQuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  'Quote Hari Ini',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  quote.category,
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white70),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.md),
          Text(
            quote.arabic,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 22,
              color: Colors.white,
              height: 1.8,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          const Gap(AppSpacing.md),
          Text(
            '"${quote.translation}"',
            style: AppTextStyles.bodyRegular.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              fontStyle: FontStyle.italic,
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            quote.source,
            style: AppTextStyles.caption.copyWith(color: AppColors.accentLight),
          ),
        ],
      ),
    );
  }
}

// ─── Quote card ────────────────────────────────────────────────────────────────

class _QuoteCard extends StatelessWidget {
  final MotivationQuote quote;
  const _QuoteCard({required this.quote});

  Color get _categoryColor {
    switch (quote.category) {
      case 'Quran':
        return AppColors.primary;
      case 'Hadith':
        return AppColors.success;
      default:
        return const Color(0xFF6C3483);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 3),
                decoration: BoxDecoration(
                  color: _categoryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  quote.category,
                  style: AppTextStyles.labelSmall
                      .copyWith(color: _categoryColor),
                ),
              ),
              Container(
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                  color: _categoryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.md),
          Text(
            quote.arabic,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 20,
              color: AppColors.textPrimary,
              height: 1.9,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          const Gap(AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '"${quote.translation}"',
              style: AppTextStyles.bodyRegular.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const Gap(AppSpacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              quote.source,
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
            ),
          ),
        ],
      ),
    );
  }
}
