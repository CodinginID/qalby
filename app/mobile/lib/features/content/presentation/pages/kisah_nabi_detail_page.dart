import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/kisah_nabi_data.dart';

class KisahNabiDetailPage extends StatelessWidget {
  final String prophetId;
  const KisahNabiDetailPage({super.key, required this.prophetId});

  @override
  Widget build(BuildContext context) {
    final prophet = KisahNabiData.prophets.firstWhere(
      (p) => p.id == prophetId,
      orElse: () => KisahNabiData.prophets.first,
    );

    return Scaffold(
      // backgroundColor adapts via theme
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: prophet.color,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [prophet.color, prophet.color.withValues(alpha: 0.7)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background ornamen
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Opacity(
                        opacity: 0.07,
                        child: Text(
                          prophet.nameArabic,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 120,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg, 80, AppSpacing.lg, AppSpacing.lg),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prophet.nameArabic,
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            prophet.name,
                            style: AppTextStyles.headingMedium
                                .copyWith(color: Colors.white),
                          ),
                          const Gap(4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              prophet.epithet,
                              style: AppTextStyles.caption
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                  // Brief
                  _SectionCard(
                    title: 'Ringkasan',
                    icon: Icons.info_outline_rounded,
                    color: prophet.color,
                    child: Text(
                      prophet.brief,
                      style: AppTextStyles.bodyRegular
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ).animate().fadeIn(duration: 400.ms),

                  const Gap(AppSpacing.md),

                  // Key events
                  _SectionCard(
                    title: 'Peristiwa Penting',
                    icon: Icons.timeline_rounded,
                    color: prophet.color,
                    child: Column(
                      children: prophet.keyEvents.asMap().entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: prophet.color.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${e.key + 1}',
                                    style: AppTextStyles.labelSmall
                                        .copyWith(color: prophet.color),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  e.value,
                                  style: AppTextStyles.bodyRegular
                                      .copyWith(color: AppColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

                  const Gap(AppSpacing.md),

                  // Full story
                  _SectionCard(
                    title: 'Kisah Lengkap',
                    icon: Icons.auto_stories_rounded,
                    color: prophet.color,
                    child: Text(
                      prophet.story,
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.7,
                      ),
                    ),
                  ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

                  const Gap(AppSpacing.md),

                  // Lesson / hikmah
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: prophet.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                          color: prophet.color.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline_rounded,
                                color: prophet.color, size: 20),
                            const Gap(AppSpacing.sm),
                            Text(
                              'Hikmah & Pelajaran',
                              style: AppTextStyles.titleCard
                                  .copyWith(color: prophet.color),
                            ),
                          ],
                        ),
                        const Gap(AppSpacing.sm),
                        Text(
                          prophet.lesson,
                          style: AppTextStyles.bodyRegular.copyWith(
                            color: AppColors.textPrimary,
                            fontStyle: FontStyle.italic,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

                  const Gap(AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const Gap(AppSpacing.sm),
              Text(title,
                  style: AppTextStyles.titleCard.copyWith(color: color)),
            ],
          ),
          const Gap(AppSpacing.md),
          child,
        ],
      ),
    );
  }
}
