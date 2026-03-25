import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/doa_data.dart';
import '../../data/content_models.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  String _selectedCategory = 'Semua';

  List<Doa> get _filtered => DoaData.byCategory(_selectedCategory);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor adapts via theme
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 60,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            title: const Text('Doa Harian', style: TextStyle(color: Colors.white)),
            iconTheme: const IconThemeData(color: Colors.white),
          ),

          // Header info
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.volunteer_activism_rounded,
                        color: AppColors.accent, size: 24),
                  ),
                  const Gap(AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${DoaData.doas.length} Doa Pilihan',
                            style: AppTextStyles.titleCard
                                .copyWith(color: Colors.white)),
                        Text('Dari Al-Quran & Hadith Shahih',
                            style: AppTextStyles.caption
                                .copyWith(color: Colors.white60)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
          ),

          // Category tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _CategoryHeaderDelegate(
              selectedCategory: _selectedCategory,
              onSelected: (c) => setState(() => _selectedCategory = c),
            ),
          ),

          // Doa list or empty state
          _filtered.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sentiment_neutral_rounded,
                            size: 64,
                            color: AppColors.textHint.withValues(alpha: 0.4)),
                        const Gap(AppSpacing.md),
                        Text('Tidak ada doa untuk kategori ini',
                            style: AppTextStyles.bodyRegular
                                .copyWith(color: AppColors.textHint)),
                        const Gap(AppSpacing.sm),
                        TextButton(
                          onPressed: () =>
                              setState(() => _selectedCategory = 'Semua'),
                          child: const Text('Tampilkan Semua'),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
                  sliver: SliverList.separated(
                    separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _DoaCard(doa: _filtered[i])
                        .animate(delay: (i * 40).ms)
                        .fadeIn(duration: 250.ms),
                  ),
                ),
        ],
      ),
    );
  }
}

// ─── Category header delegate ──────────────────────────────────────────────────

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String selectedCategory;
  final ValueChanged<String> onSelected;
  const _CategoryHeaderDelegate({
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  double get minExtent => 52;
  @override
  double get maxExtent => 52;

  @override
  Widget build(_, __, ___) {
    return Container(
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        child: Row(
          children: DoaData.categories.map((cat) {
            final selected = selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: FilterChip(
                label: Text(cat),
                selected: selected,
                onSelected: (_) => onSelected(cat),
                selectedColor: AppColors.primary.withValues(alpha: 0.12),
                checkmarkColor: AppColors.primary,
                labelStyle: AppTextStyles.caption.copyWith(
                  color:
                      selected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_CategoryHeaderDelegate old) =>
      old.selectedCategory != selectedCategory;
}

// ─── Doa card ──────────────────────────────────────────────────────────────────

class _DoaCard extends StatefulWidget {
  final Doa doa;
  const _DoaCard({required this.doa});

  @override
  State<_DoaCard> createState() => _DoaCardState();
}

class _DoaCardState extends State<_DoaCard> {
  bool _expanded = false;
  bool _showLatin = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.doa.name,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    widget.doa.category,
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                const Gap(AppSpacing.sm),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
              ],
            ),

            // Arabic text (always visible)
            const Gap(AppSpacing.md),
            Text(
              widget.doa.arabic,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                color: AppColors.textPrimary,
                height: 1.9,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),

            // Expanded content
            if (_expanded) ...[
              const Gap(AppSpacing.sm),
              Divider(color: AppColors.divider, height: 1),
              const Gap(AppSpacing.sm),

              // Toggle latin/terjemahan
              Row(
                children: [
                  _ToggleBtn(
                    label: 'Latin',
                    active: _showLatin,
                    onTap: () => setState(() => _showLatin = true),
                  ),
                  const Gap(AppSpacing.sm),
                  _ToggleBtn(
                    label: 'Terjemahan',
                    active: !_showLatin,
                    onTap: () => setState(() => _showLatin = false),
                  ),
                  const Spacer(),
                  // Copy button
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text:
                              '${widget.doa.arabic}\n\n${widget.doa.latin}\n\n${widget.doa.translation}\n\n${widget.doa.source}'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Doa disalin'),
                            duration: Duration(seconds: 1)),
                      );
                    },
                    child: const Icon(Icons.copy_outlined,
                        size: 18, color: AppColors.textHint),
                  ),
                ],
              ),
              const Gap(AppSpacing.sm),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _showLatin ? widget.doa.latin : widget.doa.translation,
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: _showLatin ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
              const Gap(AppSpacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.doa.source,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ToggleBtn({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: active ? AppColors.primary : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}
