import 'dart:math';
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
import '../../../quran/domain/quran_provider.dart';
import '../../../quran/data/surah_model.dart';
import '../../data/playlist_model.dart';
import '../../domain/playlist_provider.dart';

class AddAyatPage extends ConsumerStatefulWidget {
  final String playlistId;
  const AddAyatPage({super.key, required this.playlistId});

  @override
  ConsumerState<AddAyatPage> createState() => _AddAyatPageState();
}

class _AddAyatPageState extends ConsumerState<AddAyatPage> {
  Surah? _selectedSurah;
  int _ayatStart = 1;
  int _ayatEnd = 1;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final surahs = ref.watch(surahSearchProvider(_searchQuery));
    final step = _selectedSurah == null ? 1 : 2;

    return Scaffold(
      // backgroundColor adapts via theme
      body: Column(
        children: [
          // ── Header ───────────────────────────────────────────────────────
          _AddAyatHeader(
            step: step,
            onBack: step == 2
                ? () => setState(() => _selectedSurah = null)
                : () => context.pop(),
          ),

          // ── Content ──────────────────────────────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.04, 0),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: step == 1
                  ? _SurahPicker(
                      key: const ValueKey('picker'),
                      surahs: surahs,
                      searchQuery: _searchQuery,
                      onSearch: (q) => setState(() => _searchQuery = q),
                      onSelect: (s) => setState(() {
                        _selectedSurah = s;
                        _ayatStart = 1;
                        _ayatEnd = s.ayatCount;
                      }),
                    )
                  : _AyatRangePicker(
                      key: const ValueKey('range'),
                      surah: _selectedSurah!,
                      ayatStart: _ayatStart,
                      ayatEnd: _ayatEnd,
                      onRangeChange: (start, end) =>
                          setState(() { _ayatStart = start; _ayatEnd = end; }),
                      onChangeSurah: () => setState(() => _selectedSurah = null),
                    ),
            ),
          ),

          // ── Bottom action ─────────────────────────────────────────────────
          if (_selectedSurah != null)
            _AddButton(
              surah: _selectedSurah!,
              ayatStart: _ayatStart,
              ayatEnd: _ayatEnd,
              onAdd: _addToPlaylist,
            ),
        ],
      ),
    );
  }

  void _addToPlaylist() {
    if (_selectedSurah == null) return;
    final playlist = ref.read(playlistByIdProvider(widget.playlistId));
    if (playlist == null) return;

    ref.read(playlistsProvider.notifier).addItem(
          widget.playlistId,
          PlaylistItem(
            id: 'i_${DateTime.now().millisecondsSinceEpoch}',
            surahNumber: _selectedSurah!.number,
            surahName: _selectedSurah!.nameLatin,
            surahNameArabic: _selectedSurah!.nameArabic,
            ayatStart: _ayatStart,
            ayatEnd: _ayatEnd,
            order: playlist.items.length,
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedSurah!.nameLatin} ayat $_ayatStart–$_ayatEnd ditambahkan'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    );
    context.pop();
  }
}

// ─── Header with step indicator ────────────────────────────────────────────────

class _AddAyatHeader extends StatelessWidget {
  final int step;
  final VoidCallback onBack;

  const _AddAyatHeader({required this.step, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        MediaQuery.of(context).padding.top + AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                onPressed: onBack,
              ),
              const Gap(AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step == 1 ? 'Pilih Surah' : 'Pilih Range Ayat',
                      style: AppTextStyles.titleCard.copyWith(color: Colors.white),
                    ),
                    Text(
                      'Langkah $step dari 2',
                      style: AppTextStyles.caption.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.md),
          // Step progress bar
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Gap(AppSpacing.sm),
              Expanded(
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: step >= 2
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Surah picker ──────────────────────────────────────────────────────────────

class _SurahPicker extends StatefulWidget {
  final List<Surah> surahs;
  final String searchQuery;
  final ValueChanged<String> onSearch;
  final ValueChanged<Surah> onSelect;

  const _SurahPicker({
    super.key,
    required this.surahs,
    required this.searchQuery,
    required this.onSearch,
    required this.onSelect,
  });

  @override
  State<_SurahPicker> createState() => _SurahPickerState();
}

class _SurahPickerState extends State<_SurahPicker> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
          child: TextField(
            controller: _controller,
            onChanged: widget.onSearch,
            decoration: InputDecoration(
              hintText: 'Cari nama atau nomor surah...',
              hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textHint),
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textHint),
              suffixIcon: widget.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textHint),
                      onPressed: () { _controller.clear(); widget.onSearch(''); },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.surfaceCard,
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
        const Gap(AppSpacing.sm),
        // Count hint
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Text(
                '${widget.surahs.length} surah',
                style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
              ),
            ],
          ),
        ),
        const Gap(AppSpacing.xs),
        // List
        Expanded(
          child: ListView.builder(
            itemCount: widget.surahs.length,
            itemBuilder: (_, i) {
              final s = widget.surahs[i];
              return _SurahPickerTile(
                surah: s,
                onTap: () => widget.onSelect(s),
              ).animate(delay: (i * 15).ms).fadeIn(duration: 180.ms);
            },
          ),
        ),
      ],
    );
  }
}

class _SurahPickerTile extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;
  const _SurahPickerTile({required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isMakkiyah = surah.type == 'Makkiyah';
    final typeColor = isMakkiyah ? AppColors.primary : AppColors.success;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 11),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
            left: BorderSide(color: typeColor, width: 3),
          ),
        ),
        child: Row(
          children: [
            // Octagon number badge
            _OctagonBadge(number: surah.number, color: typeColor),
            const Gap(AppSpacing.md),
            // Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.nameLatin,
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                  ),
                  const Gap(2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          surah.type,
                          style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 10, color: typeColor),
                        ),
                      ),
                      const Gap(6),
                      Text(
                        '${surah.ayatCount} ayat',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arabic name
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ArabicText(
                  text: surah.nameArabic,
                  style: AppTextStyles.arabicSmall.copyWith(color: typeColor, fontSize: 17),
                ),
                const Gap(2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text('Juz ${surah.juz}',
                      style: AppTextStyles.labelSmall.copyWith(fontSize: 9, color: typeColor)),
                ),
              ],
            ),
            const Gap(AppSpacing.sm),
            Icon(Icons.add_circle_outline_rounded, color: typeColor, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Ayat range picker ─────────────────────────────────────────────────────────

class _AyatRangePicker extends StatelessWidget {
  final Surah surah;
  final int ayatStart;
  final int ayatEnd;
  final void Function(int start, int end) onRangeChange;
  final VoidCallback onChangeSurah;

  const _AyatRangePicker({
    super.key,
    required this.surah,
    required this.ayatStart,
    required this.ayatEnd,
    required this.onRangeChange,
    required this.onChangeSurah,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCount = ayatEnd - ayatStart + 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Surah terpilih card
          GestureDetector(
            onTap: onChangeSurah,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _OctagonBadge(number: surah.number, color: AppColors.accent, onDark: true),
                  const Gap(AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(surah.nameLatin,
                            style: AppTextStyles.titleCard.copyWith(color: Colors.white)),
                        Text('${surah.ayatCount} ayat · ${surah.type}',
                            style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                      ],
                    ),
                  ),
                  ArabicText(
                    text: surah.nameArabic,
                    style: AppTextStyles.arabicSmall.copyWith(color: Colors.white70, fontSize: 18),
                  ),
                  const Gap(AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.swap_horiz_rounded, color: Colors.white70, size: 14),
                        const Gap(4),
                        Text('Ganti',
                            style: AppTextStyles.labelSmall.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.04),

          const Gap(AppSpacing.xl),

          // Range header
          Row(
            children: [
              Text('Pilih Range Ayat',
                  style: AppTextStyles.titleCard.copyWith(color: AppColors.textPrimary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '$selectedCount ayat dipilih',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ).animate(delay: 50.ms).fadeIn(duration: 300.ms),

          const Gap(AppSpacing.lg),

          // Big number display
          Row(
            children: [
              Expanded(
                child: _AyatNumberCard(
                  label: 'Dari',
                  value: ayatStart,
                  color: AppColors.primary,
                  onDecrement: ayatStart > 1 ? () => onRangeChange(ayatStart - 1, ayatEnd) : null,
                  onIncrement: ayatStart < ayatEnd ? () => onRangeChange(ayatStart + 1, ayatEnd) : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    const Icon(Icons.arrow_forward_rounded, color: AppColors.textHint, size: 20),
                    Text('$selectedCount ayat',
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint)),
                  ],
                ),
              ),
              Expanded(
                child: _AyatNumberCard(
                  label: 'Sampai',
                  value: ayatEnd,
                  color: AppColors.success,
                  onDecrement: ayatEnd > ayatStart ? () => onRangeChange(ayatStart, ayatEnd - 1) : null,
                  onIncrement: ayatEnd < surah.ayatCount ? () => onRangeChange(ayatStart, ayatEnd + 1) : null,
                ),
              ),
            ],
          ).animate(delay: 80.ms).fadeIn(duration: 300.ms),

          const Gap(AppSpacing.xl),

          // Range slider
          Text('Geser untuk pilih range',
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
          const Gap(AppSpacing.sm),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.divider,
              thumbColor: AppColors.primary,
              rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
              overlayColor: AppColors.primary.withValues(alpha: 0.1),
              trackHeight: 6,
              rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
            ),
            child: RangeSlider(
              values: RangeValues(ayatStart.toDouble(), ayatEnd.toDouble()),
              min: 1,
              max: surah.ayatCount.toDouble(),
              divisions: surah.ayatCount - 1,
              labels: RangeLabels('$ayatStart', '$ayatEnd'),
              onChanged: (v) => onRangeChange(v.start.round(), v.end.round()),
            ),
          ).animate(delay: 120.ms).fadeIn(duration: 300.ms),

          // Ayat range visual bar
          _RangeVisualBar(
            total: surah.ayatCount,
            start: ayatStart,
            end: ayatEnd,
          ).animate(delay: 150.ms).fadeIn(duration: 300.ms),

          const Gap(AppSpacing.xl),

          // Summary
          _SummaryCard(
            surah: surah,
            ayatStart: ayatStart,
            ayatEnd: ayatEnd,
          ).animate(delay: 180.ms).fadeIn(duration: 300.ms),

          const Gap(AppSpacing.xxl),
        ],
      ),
    );
  }
}

// ─── Ayat number card ──────────────────────────────────────────────────────────

class _AyatNumberCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const _AyatNumberCard({
    required this.label,
    required this.value,
    required this.color,
    this.onDecrement,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(label,
              style: AppTextStyles.caption.copyWith(color: color.withValues(alpha: 0.8))),
          const Gap(AppSpacing.sm),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          const Gap(AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SmallBtn(icon: Icons.remove, color: color, onTap: onDecrement),
              const Gap(AppSpacing.sm),
              _SmallBtn(icon: Icons.add, color: color, onTap: onIncrement),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _SmallBtn({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: onTap != null ? color.withValues(alpha: 0.12) : AppColors.divider,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14,
            color: onTap != null ? color : AppColors.textHint),
      ),
    );
  }
}

// ─── Range visual bar ──────────────────────────────────────────────────────────

class _RangeVisualBar extends StatelessWidget {
  final int total;
  final int start;
  final int end;

  const _RangeVisualBar({required this.total, required this.start, required this.end});

  @override
  Widget build(BuildContext context) {
    final startFrac = (start - 1) / total;
    final endFrac = end / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: SizedBox(
            height: 8,
            child: LayoutBuilder(
              builder: (_, constraints) {
                final w = constraints.maxWidth;
                return Stack(
                  children: [
                    // Background track
                    Container(width: w, color: AppColors.divider),
                    // Selected range
                    Positioned(
                      left: w * startFrac,
                      width: w * (endFrac - startFrac),
                      top: 0, bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.success],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const Gap(4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint, fontSize: 10)),
            Text('$total', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint, fontSize: 10)),
          ],
        ),
      ],
    );
  }
}

// ─── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final Surah surah;
  final int ayatStart;
  final int ayatEnd;

  const _SummaryCard({
    required this.surah,
    required this.ayatStart,
    required this.ayatEnd,
  });

  @override
  Widget build(BuildContext context) {
    final count = ayatEnd - ayatStart + 1;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.playlist_add_rounded, color: AppColors.success, size: 20),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(surah.nameLatin,
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.success, fontWeight: FontWeight.w600)),
                Text(
                  'Ayat $ayatStart – $ayatEnd  ($count ayat)',
                  style: AppTextStyles.caption.copyWith(color: AppColors.success.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom add button ─────────────────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  final Surah surah;
  final int ayatStart;
  final int ayatEnd;
  final VoidCallback onAdd;

  const _AddButton({
    required this.surah,
    required this.ayatStart,
    required this.ayatEnd,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg,
          MediaQuery.of(context).padding.bottom + AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        border: const Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -4)),
        ],
      ),
      child: AppButton.filled(
        label: 'Tambah ke Playlist',
        icon: Icons.playlist_add_rounded,
        onPressed: onAdd,
      ),
    );
  }
}

// ─── Reusable octagon badge ────────────────────────────────────────────────────

class _OctagonBadge extends StatelessWidget {
  final int number;
  final Color color;
  final bool onDark;

  const _OctagonBadge({required this.number, required this.color, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40, height: 40,
      child: CustomPaint(
        painter: _OctagonPainter(color: color, onDark: onDark),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              color: onDark ? color : color,
              fontSize: number > 99 ? 10 : 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _OctagonPainter extends CustomPainter {
  final Color color;
  final bool onDark;
  const _OctagonPainter({required this.color, required this.onDark});

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = onDark
          ? Colors.white.withValues(alpha: 0.15)
          : color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = onDark
          ? Colors.white.withValues(alpha: 0.3)
          : color.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.44;

    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * pi / 8) - (pi / 8);
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(_) => false;
}
