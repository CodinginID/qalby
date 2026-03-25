import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/arabic_text.dart';
import '../../domain/quran_provider.dart';
import '../../data/surah_model.dart';

class SurahListPage extends ConsumerStatefulWidget {
  const SurahListPage({super.key});

  @override
  ConsumerState<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends ConsumerState<SurahListPage>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _query = '';
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncSurahs = ref.watch(surahListAsyncProvider);
    final filteredSurahs = ref.watch(surahSearchProvider(_query));

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // ── App bar ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primaryDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 56, AppSpacing.lg, 0),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Al-Quran', style: AppTextStyles.headingMedium.copyWith(color: Colors.white)),
                                asyncSurahs.when(
                                  data: (s) => Text('${s.length} Surah', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                                  loading: () => Text('Memuat...', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                                  error: (_, __) => Text('Offline — data lokal', style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
                                ),
                              ],
                            ),
                          ),
                          ArabicText(
                            text: 'الْقُرْآن',
                            style: AppTextStyles.arabicSurahName.copyWith(color: Colors.white38, fontSize: 32),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Search ───────────────────────────────────────────────────
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Container(
                color: AppColors.primaryDark,
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Cari surah atau nomor...',
                    hintStyle: AppTextStyles.caption.copyWith(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Colors.white54),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18, color: Colors.white54),
                            onPressed: () { _searchController.clear(); setState(() => _query = ''); },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.12),
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.full), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.full), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.full), borderSide: const BorderSide(color: AppColors.accent, width: 1.5)),
                  ),
                ),
              ),
            ),
          ),

          // ── Juz / Tab filter ─────────────────────────────────────────────
          if (_query.isEmpty)
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Semua'),
                    Tab(text: 'Makkiyah'),
                    Tab(text: 'Madaniyah'),
                  ],
                  labelStyle: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700),
                  unselectedLabelStyle: AppTextStyles.labelSmall,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2.5,
                  dividerColor: AppColors.divider,
                ),
              ),
            ),
        ],
        body: RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () async => ref.invalidate(surahListAsyncProvider),
          child: _query.isNotEmpty
              ? _SurahListBody(surahs: filteredSurahs, isLoading: false)
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _SurahTabBody(filter: null, asyncSurahs: asyncSurahs),
                    _SurahTabBody(filter: 'Makkiyah', asyncSurahs: asyncSurahs),
                    _SurahTabBody(filter: 'Madaniyah', asyncSurahs: asyncSurahs),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─── Tab body with filter ─────────────────────────────────────────────────────

class _SurahTabBody extends StatelessWidget {
  final String? filter;
  final AsyncValue<List<Surah>> asyncSurahs;
  const _SurahTabBody({required this.filter, required this.asyncSurahs});

  @override
  Widget build(BuildContext context) {
    return asyncSurahs.when(
      loading: () => _SurahListBody(
        surahs: List.generate(10, (i) => Surah(
          number: i + 1, nameArabic: 'xxxxxxx', nameLatin: 'Surah Name',
          nameTranslation: 'Translation', ayatCount: 100, type: 'Makkiyah', juz: 1,
        )),
        isLoading: true,
      ),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textHint),
            const Gap(AppSpacing.md),
            Text('Gagal memuat. Tampil data offline.', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textHint)),
          ],
        ),
      ),
      data: (surahs) {
        final filtered = filter == null ? surahs : surahs.where((s) => s.type == filter).toList();
        return _SurahListBody(surahs: filtered, isLoading: false);
      },
    );
  }
}

// ─── List body ────────────────────────────────────────────────────────────────

class _SurahListBody extends StatelessWidget {
  final List<Surah> surahs;
  final bool isLoading;
  const _SurahListBody({required this.surahs, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading && surahs.isEmpty) {
      return Center(
        child: Text('Surah tidak ditemukan', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textHint)),
      );
    }

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: surahs.length,
        itemBuilder: (_, i) {
          final s = surahs[i];
          return _SurahTile(surah: s, index: i).animate(delay: (i * 15).ms).fadeIn(duration: 200.ms).slideX(begin: 0.02);
        },
      ),
    );
  }
}

// ─── Surah tile ───────────────────────────────────────────────────────────────

class _SurahTile extends StatelessWidget {
  final Surah surah;
  final int index;
  const _SurahTile({required this.surah, required this.index});

  @override
  Widget build(BuildContext context) {
    final isMakkiyah = surah.type == 'Makkiyah';
    final typeColor = isMakkiyah ? AppColors.primary : AppColors.success;

    return InkWell(
      onTap: () => context.push('/quran/${surah.number}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
            left: BorderSide(color: typeColor, width: 3),
          ),
        ),
        child: Row(
          children: [
            // Number badge — filled diamond
            _SurahNumberBadge(number: surah.number, color: typeColor),
            const Gap(AppSpacing.md),

            // Name + info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(surah.nameLatin,
                      style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  const Gap(2),
                  Row(
                    children: [
                      Text(
                        surah.nameTranslation,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textHint, fontStyle: FontStyle.italic),
                      ),
                      const Gap(AppSpacing.sm),
                      Container(width: 3, height: 3,
                          decoration: BoxDecoration(color: AppColors.textHint, shape: BoxShape.circle)),
                      const Gap(AppSpacing.sm),
                      Text('${surah.ayatCount} ayat',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),

            // Right side: Arabic + Juz badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ArabicText(
                  text: surah.nameArabic,
                  style: AppTextStyles.arabicSmall.copyWith(color: typeColor, fontSize: 18),
                ),
                const Gap(2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: typeColor.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    'Juz ${surah.juz}',
                    style: AppTextStyles.labelSmall.copyWith(fontSize: 10, color: typeColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SurahNumberBadge extends StatelessWidget {
  final int number;
  final Color color;
  const _SurahNumberBadge({required this.number, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42, height: 42,
      child: CustomPaint(
        painter: _DiamondPainter(color: color),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              color: color,
              fontSize: number > 99 ? 10 : 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _DiamondPainter extends CustomPainter {
  final Color color;
  const _DiamondPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color.withValues(alpha: 0.08)..style = PaintingStyle.fill;
    final stroke = Paint()..color = color.withValues(alpha: 0.4)..style = PaintingStyle.stroke..strokeWidth = 1.2;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.46;

    // Octagon
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * 3.14159 / 8) - (3.14159 / 8);
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

// ─── Tab bar delegate ─────────────────────────────────────────────────────────

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(_TabBarDelegate old) => false;
}
