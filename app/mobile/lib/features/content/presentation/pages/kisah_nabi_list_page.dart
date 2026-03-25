import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/kisah_nabi_data.dart';
import '../../data/content_models.dart';

class KisahNabiListPage extends StatelessWidget {
  const KisahNabiListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor adapts via theme
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 72, AppSpacing.lg, AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Kisah Para Nabi',
                      style: AppTextStyles.headingMedium
                          .copyWith(color: Colors.white),
                    ),
                    Text(
                      '${KisahNabiData.prophets.length} kisah dari Al-Quran & Hadith',
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverList.separated(
              separatorBuilder: (_, __) => const Gap(AppSpacing.md),
              itemCount: KisahNabiData.prophets.length,
              itemBuilder: (_, i) => _ProphetCard(
                prophet: KisahNabiData.prophets[i],
                index: i,
              )
                  .animate(delay: (i * 60).ms)
                  .fadeIn(duration: 300.ms)
                  .slideX(begin: 0.05),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProphetCard extends StatelessWidget {
  final ProphetStory prophet;
  final int index;
  const _ProphetCard({required this.prophet, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/kisah-nabi/${prophet.id}'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // Number + color badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: prophet.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                    color: prophet.color.withValues(alpha: 0.3), width: 1.5),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: AppTextStyles.titleCard.copyWith(color: prophet.color),
                ),
              ),
            ),
            const Gap(AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          prophet.name,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                      Text(
                        prophet.nameArabic,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Gap(2),
                  Text(
                    prophet.epithet,
                    style: AppTextStyles.caption
                        .copyWith(color: prophet.color),
                  ),
                  const Gap(AppSpacing.xs),
                  Text(
                    prophet.brief,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.sm),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}
