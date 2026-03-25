import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/arabic_text.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../core/services/audio_player_notifier.dart';
import '../../data/ayat_model.dart';
import '../../domain/quran_provider.dart';
import '../widgets/tajweed_text.dart';
import '../../../playlist/domain/playlist_provider.dart';
import '../../../playlist/data/playlist_model.dart';

class SurahDetailPage extends ConsumerStatefulWidget {
  final int surahId;
  const SurahDetailPage({super.key, required this.surahId});

  @override
  ConsumerState<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends ConsumerState<SurahDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _showTranslation = true;
  bool _tajweedMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Derive audio URL for a given ayat (using current qari)
  String _audioUrl(Ayat ayat, String qariId) {
    if (ayat.audioUrl != null) return ayat.audioUrl!;
    // Fallback: construct CDN URL (needs global ayat number — skip for now)
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final surah = ref.watch(surahByNumberProvider(widget.surahId));
    final ayatAsync = ref.watch(ayatListProvider(widget.surahId));
    final audio = ref.watch(quranAudioProvider);

    if (surah == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Surah tidak ditemukan')),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // ── Header ─────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: SafeArea(
                  child: Stack(
                    children: [
                      // Background decorative Arabic text
                      Positioned(
                        right: -10, bottom: 10,
                        child: Opacity(
                          opacity: 0.06,
                          child: ArabicText(
                            text: surah.nameArabic,
                            style: AppTextStyles.arabicSurahName.copyWith(fontSize: 100, color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Type badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(AppRadius.full),
                                border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                              ),
                              child: Text(surah.type.toUpperCase(),
                                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, letterSpacing: 1.5)),
                            ),
                            const Gap(AppSpacing.sm),
                            // Arabic name
                            ArabicText(
                              text: surah.nameArabic,
                              style: AppTextStyles.arabicSurahName.copyWith(fontSize: 36, color: Colors.white),
                            ),
                            const Gap(4),
                            Text(surah.nameLatin,
                                style: AppTextStyles.headingMedium.copyWith(color: Colors.white)),
                            Text(surah.nameTranslation,
                                style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                            const Gap(AppSpacing.md),
                            // Info chips
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _InfoChip(icon: Icons.format_list_numbered_rounded, label: '${surah.ayatCount} Ayat'),
                                const Gap(AppSpacing.sm),
                                _InfoChip(icon: Icons.bookmark_outline_rounded, label: 'Juz ${surah.juz}'),
                                const Gap(AppSpacing.sm),
                                // Play all button
                                ayatAsync.whenOrNull(data: (ayatList) {
                                  if (ayatList.isEmpty) return null;
                                  final first = ayatList.first;
                                  final url = _audioUrl(first, audio.qariId);
                                  if (url.isEmpty) return null;
                                  return GestureDetector(
                                    onTap: () => ref.read(quranAudioProvider.notifier).playAyat(
                                      surahNumber: widget.surahId,
                                      ayatNumber: first.number,
                                      audioUrl: url,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius: BorderRadius.circular(AppRadius.full),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                                          const Gap(4),
                                          Text('Putar', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  );
                                }) ?? const SizedBox.shrink(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Tab bar ───────────────────────────────────────────────────
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Al-Quran'),
                Tab(text: 'Tafsir'),
              ],
              labelStyle: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700),
              unselectedLabelStyle: AppTextStyles.labelSmall,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              indicatorColor: AppColors.accent,
              indicatorWeight: 3,
              dividerColor: Colors.white.withValues(alpha: 0.2),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // ── Tab 1: Al-Quran ─────────────────────────────────────────
            _AlQuranTab(
              surahId: widget.surahId,
              surahNumber: surah.number,
              surahName: surah.nameLatin,
              surahNameArabic: surah.nameArabic,
              showTranslation: _showTranslation,
              tajweedMode: _tajweedMode,
              onToggleTranslation: () => setState(() => _showTranslation = !_showTranslation),
              onToggleTajweed: () {
                setState(() => _tajweedMode = !_tajweedMode);
                if (!_tajweedMode) {
                  // Pre-fetch tajweed data when enabling
                  ref.read(tajweedProvider(widget.surahId).future);
                }
              },
            ),
            // ── Tab 2: Tafsir ───────────────────────────────────────────
            _TafsirTab(surahId: widget.surahId, surahNumber: surah.number),
          ],
        ),
      ),
      // ── Floating mini audio player ──────────────────────────────────────
      bottomNavigationBar: audio.hasActiveAudio && audio.surahNumber == widget.surahId
          ? _AudioMiniPlayer(audio: audio)
          : null,
    );
  }
}

// ─── Al-Quran tab ─────────────────────────────────────────────────────────────

class _AlQuranTab extends ConsumerStatefulWidget {
  final int surahId;
  final int surahNumber;
  final String surahName;
  final String surahNameArabic;
  final bool showTranslation;
  final bool tajweedMode;
  final VoidCallback onToggleTranslation;
  final VoidCallback onToggleTajweed;

  const _AlQuranTab({
    required this.surahId,
    required this.surahNumber,
    required this.surahName,
    required this.surahNameArabic,
    required this.showTranslation,
    required this.tajweedMode,
    required this.onToggleTranslation,
    required this.onToggleTajweed,
  });

  @override
  ConsumerState<_AlQuranTab> createState() => _AlQuranTabState();
}

class _AlQuranTabState extends ConsumerState<_AlQuranTab> {
  final _scrollCtrl = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final show = _scrollCtrl.offset > 400;
      if (show != _showBackToTop) setState(() => _showBackToTop = show);
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ayatAsync = ref.watch(ayatListProvider(widget.surahId));
    final tajweedAsync =
        widget.tajweedMode ? ref.watch(tajweedProvider(widget.surahId)) : null;
    final audio = ref.watch(quranAudioProvider);

    return ayatAsync.when(
      loading: () => _SkeletonList(),
      error: (e, _) =>
          _ErrorRetry(onRetry: () => ref.invalidate(ayatListProvider(widget.surahId))),
      data: (ayatList) {
        final tajweedTexts = tajweedAsync?.value;
        return Stack(
          children: [
          Column(
          children: [
            // ── Toolbar ─────────────────────────────────────────────────
            _ToolbarRow(
              showTranslation: widget.showTranslation,
              tajweedMode: widget.tajweedMode,
              onToggleTranslation: widget.onToggleTranslation,
              onToggleTajweed: widget.onToggleTajweed,
              surahId: widget.surahId,
              audio: audio,
            ),

            // ── Tajweed legend ───────────────────────────────────────────
            if (widget.tajweedMode)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.divider),
                ),
                child: const TajweedLegendCard(),
              ).animate().fadeIn(duration: 200.ms),

            // ── Bismillah ────────────────────────────────────────────────
            if (widget.surahNumber != 1 && widget.surahNumber != 9)
              _BismillahCard(),

            // ── Ayat list ────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                itemCount: ayatList.length,
                itemBuilder: (_, i) {
                  final ayat = ayatList[i];
                  final tajweedText = (tajweedTexts != null && i < tajweedTexts.length)
                      ? tajweedTexts[i]
                      : null;
                  final isCurrentAudio = audio.surahNumber == widget.surahNumber && audio.ayatNumber == ayat.number;

                  return _AyatCard(
                    ayat: ayat,
                    index: i,
                    tajweedText: tajweedText,
                    showTranslation: widget.showTranslation,
                    tajweedMode: widget.tajweedMode,
                    isPlaying: isCurrentAudio && audio.isPlaying,
                    isLoading: isCurrentAudio && audio.isLoading,
                    onPlay: ayat.audioUrl != null
                        ? () => ref.read(quranAudioProvider.notifier).playAyat(
                              surahNumber: widget.surahNumber,
                              ayatNumber: ayat.number,
                              audioUrl: ayat.audioUrl!,
                            )
                        : null,
                    onCopy: () {
                      Clipboard.setData(ClipboardData(text: '${ayat.arabic}\n\n${ayat.translation}'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ayat disalin'), duration: Duration(seconds: 1)),
                      );
                    },
                    onAddToPlaylist: () => _showAddToPlaylist(
                        context, ref, widget.surahNumber, widget.surahName, widget.surahNameArabic, ayat.number),
                  ).animate(delay: (i * 15).ms).fadeIn(duration: 200.ms);
                },
              ),
            ),
          ],
          ),
          // ── Back to top FAB ─────────────────────────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            bottom: _showBackToTop ? 16 : -60,
            right: 16,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: _showBackToTop ? 1.0 : 0.0,
              child: FloatingActionButton.small(
                heroTag: 'back_to_top_quran',
                onPressed: () => _scrollCtrl.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                ),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                child: const Icon(Icons.keyboard_arrow_up_rounded),
              ),
            ),
          ),
          ],
        );
      },
    );
  }

  void _showAddToPlaylist(BuildContext context, WidgetRef ref, int surahNumber, String surahName, String surahNameArabic, int ayatNumber) {
    final playlists = ref.read(playlistsProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tambah ke Playlist', style: AppTextStyles.titleCard),
            const Gap(AppSpacing.md),
            if (playlists.isEmpty)
              Text('Belum ada playlist', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textHint))
            else
              ...playlists.map((p) => ListTile(
                    leading: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(gradient: AppColors.playlistGradientAt(playlists.indexOf(p)), borderRadius: BorderRadius.circular(AppRadius.sm)),
                      child: const Icon(Icons.playlist_play_rounded, color: Colors.white, size: 18),
                    ),
                    title: Text(p.name, style: AppTextStyles.bodyMedium),
                    subtitle: Text('${p.items.length} item', style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
                    onTap: () {
                      ref.read(playlistsProvider.notifier).addItem(
                        p.id,
                        PlaylistItem(
                          id: 'i_${DateTime.now().millisecondsSinceEpoch}',
                          surahNumber: surahNumber,
                          surahName: surahName,
                          surahNameArabic: surahNameArabic,
                          ayatStart: ayatNumber,
                          ayatEnd: ayatNumber,
                          order: p.items.length,
                        ),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ditambahkan ke ${p.name}'), duration: const Duration(seconds: 2)),
                      );
                    },
                  )),
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

// ─── Toolbar row ──────────────────────────────────────────────────────────────

class _ToolbarRow extends ConsumerWidget {
  final bool showTranslation;
  final bool tajweedMode;
  final VoidCallback onToggleTranslation;
  final VoidCallback onToggleTajweed;
  final int surahId;
  final QuranAudioState audio;

  const _ToolbarRow({
    required this.showTranslation,
    required this.tajweedMode,
    required this.onToggleTranslation,
    required this.onToggleTajweed,
    required this.surahId,
    required this.audio,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        border: Border(bottom: BorderSide(color: AppColors.borderColor(context))),
      ),
      child: Row(
        children: [
          // Translation toggle
          _ToolbarButton(
            icon: Icons.translate_rounded,
            label: 'Terjemah',
            active: showTranslation,
            onTap: onToggleTranslation,
          ),
          const Gap(AppSpacing.sm),
          // Tajwid toggle
          _ToolbarButton(
            icon: Icons.format_color_text_rounded,
            label: 'Tajwid',
            active: tajweedMode,
            onTap: onToggleTajweed,
          ),
          const Spacer(),
          // Qari selector
          GestureDetector(
            onTap: () => _showQariSelector(context, ref),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.record_voice_over_rounded, color: AppColors.primary, size: 14),
                  const Gap(4),
                  Text(
                    _qariShortName(audio.qariId),
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
                  ),
                  const Gap(2),
                  const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _qariShortName(String qariId) {
    final q = kSupportedQari.firstWhere((q) => q.id == qariId, orElse: () => kSupportedQari.first);
    return q.name.split(' ').first;
  }

  void _showQariSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Qari', style: AppTextStyles.titleCard),
            const Gap(AppSpacing.md),
            ...kSupportedQari.map((q) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(Icons.mic_rounded, color: AppColors.primary, size: 20),
                  ),
                  title: Text(q.name, style: AppTextStyles.bodyMedium),
                  subtitle: Text(q.nameAr,
                      style: AppTextStyles.arabicSmall.copyWith(color: AppColors.textSecondary, fontSize: 14),
                      textDirection: TextDirection.rtl),
                  trailing: audio.qariId == q.id
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    ref.read(quranAudioProvider.notifier).setQari(q.id);
                    Navigator.pop(context);
                  },
                )),
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ToolbarButton({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: active ? AppColors.primary.withValues(alpha: 0.3) : AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: active ? AppColors.primary : AppColors.textHint),
            const Gap(4),
            Text(label, style: AppTextStyles.labelSmall.copyWith(color: active ? AppColors.primary : AppColors.textHint)),
          ],
        ),
      ),
    );
  }
}

// ─── Bismillah card ───────────────────────────────────────────────────────────

class _BismillahCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.08), AppColors.accent.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: ArabicText(
        text: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
        style: AppTextStyles.arabicSmall.copyWith(color: AppColors.primary, fontSize: 22),
      ),
    );
  }
}

// ─── Ayat card ────────────────────────────────────────────────────────────────

class _AyatCard extends StatefulWidget {
  final Ayat ayat;
  final int index;
  final String? tajweedText;
  final bool showTranslation;
  final bool tajweedMode;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback? onPlay;
  final VoidCallback onCopy;
  final VoidCallback onAddToPlaylist;

  const _AyatCard({
    required this.ayat,
    required this.index,
    required this.tajweedText,
    required this.showTranslation,
    required this.tajweedMode,
    required this.isPlaying,
    required this.isLoading,
    required this.onPlay,
    required this.onCopy,
    required this.onAddToPlaylist,
  });

  @override
  State<_AyatCard> createState() => _AyatCardState();
}

class _AyatCardState extends State<_AyatCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isPlaying || widget.isLoading;
    Color cardColor;
    if (isActive) {
      cardColor = AppColors.primary.withValues(alpha: 0.06);
    } else if (_pressed) {
      cardColor = AppColors.primary.withValues(alpha: 0.05);
    } else {
      cardColor = AppColors.bgCard(context);
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => Future.delayed(
        const Duration(milliseconds: 200),
        () { if (mounted) setState(() => _pressed = false); },
      ),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
      duration: 250.ms,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isActive ? AppColors.primary.withValues(alpha: 0.3) : AppColors.divider,
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: isActive
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header row ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.sm, 0),
            child: Row(
              children: [
                // Ayat number
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? AppColors.primary : AppColors.accent.withValues(alpha: 0.15),
                    border: Border.all(color: isActive ? AppColors.primary : AppColors.accent.withValues(alpha: 0.4)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${widget.ayat.number}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isActive ? Colors.white : AppColors.accentDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Spacer(),
                // Play/pause button
                if (widget.onPlay != null)
                  _CircleIconButton(
                    icon: widget.isLoading
                        ? Icons.hourglass_top_rounded
                        : (widget.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                    color: isActive ? AppColors.primary : AppColors.textHint,
                    onTap: widget.onPlay!,
                    filled: isActive,
                  ),
                _CircleIconButton(icon: Icons.copy_outlined, color: AppColors.textHint, onTap: widget.onCopy),
                _CircleIconButton(icon: Icons.playlist_add_rounded, color: AppColors.primary, onTap: widget.onAddToPlaylist),
              ],
            ),
          ),
          // ── Arabic text ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
            child: widget.tajweedMode && widget.tajweedText != null
                ? TajweedText(
                    tajweedHtml: widget.tajweedText!,
                    baseStyle: AppTextStyles.arabicAyat.copyWith(color: AppColors.textPrimary),
                  )
                : ArabicText(
                    text: widget.ayat.arabic,
                    style: AppTextStyles.arabicAyat.copyWith(color: AppColors.textPrimary),
                  ),
          ),
          // ── Divider ──────────────────────────────────────────────────
          Divider(height: 1, indent: AppSpacing.md, endIndent: AppSpacing.md, color: AppColors.divider),
          // ── Translation ──────────────────────────────────────────────
          if (widget.showTranslation)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 3, height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Gap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.ayat.translation,
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 200.ms),
        ],
      ),
      ),
    );
  }
}

// ─── Tafsir tab ───────────────────────────────────────────────────────────────

class _TafsirTab extends ConsumerWidget {
  final int surahId;
  final int surahNumber;
  const _TafsirTab({required this.surahId, required this.surahNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayatAsync = ref.watch(ayatListProvider(surahId));
    final tafsirAsync = ref.watch(tafsirProvider(surahId));

    return tafsirAsync.when(
      loading: () => _SkeletonList(),
      error: (e, _) => _ErrorRetry(onRetry: () => ref.invalidate(tafsirProvider(surahId))),
      data: (tafsirList) => ayatAsync.when(
        loading: () => _SkeletonList(),
        error: (_, __) => const SizedBox.shrink(),
        data: (ayatList) {
          final count = tafsirList.length;
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            itemCount: count,
            itemBuilder: (_, i) {
              if (i >= ayatList.length) return const SizedBox.shrink();
              final ayat = ayatList[i];
              final tafsir = tafsirList[i];
              return _TafsirCard(
                ayatNumber: ayat.number,
                arabic: ayat.arabic,
                tafsir: tafsir,
              ).animate(delay: (i * 20).ms).fadeIn(duration: 250.ms);
            },
          );
        },
      ),
    );
  }
}

class _TafsirCard extends StatelessWidget {
  final int ayatNumber;
  final String arabic;
  final String tafsir;
  const _TafsirCard({required this.ayatNumber, required this.arabic, required this.tafsir});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ayat number + Arabic
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
            ),
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                  alignment: Alignment.center,
                  child: Text('$ayatNumber', style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: ArabicText(
                    text: arabic,
                    style: AppTextStyles.arabicSmall.copyWith(color: AppColors.primary, fontSize: 16),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          // Tafsir text
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              tafsir,
              style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary, height: 1.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Audio mini player ────────────────────────────────────────────────────────

class _AudioMiniPlayer extends ConsumerWidget {
  final QuranAudioState audio;
  const _AudioMiniPlayer({required this.audio});

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(quranAudioProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, MediaQuery.of(context).padding.bottom + AppSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
              activeTrackColor: AppColors.accent,
              inactiveTrackColor: Colors.white24,
              thumbColor: AppColors.accent,
              overlayColor: AppColors.accent.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: audio.progress.clamp(0.0, 1.0),
              onChanged: (v) => notifier.seek(v),
            ),
          ),
          Row(
            children: [
              // Times
              Text(_formatDuration(audio.position), style: AppTextStyles.labelSmall.copyWith(color: Colors.white54)),
              const Spacer(),
              // Ayat info
              Column(
                children: [
                  Text('Ayat ${audio.ayatNumber}', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                  Text(_qariName(audio.qariId), style: AppTextStyles.caption.copyWith(color: Colors.white54)),
                ],
              ),
              const Spacer(),
              Text(_formatDuration(audio.duration), style: AppTextStyles.labelSmall.copyWith(color: Colors.white54)),
            ],
          ),
          const Gap(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10_rounded, color: Colors.white70),
                onPressed: () => notifier.seek((audio.position.inMilliseconds - 10000)
                    .clamp(0, audio.duration.inMilliseconds) / audio.duration.inMilliseconds.clamp(1, double.maxFinite)),
              ),
              const Gap(AppSpacing.md),
              GestureDetector(
                onTap: () {
                  if (audio.isPlaying) notifier.pause(); else notifier.resume();
                },
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  child: Icon(
                    audio.isLoading ? Icons.hourglass_top_rounded : (audio.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                    color: Colors.white, size: 28,
                  ),
                ),
              ),
              const Gap(AppSpacing.md),
              IconButton(
                icon: const Icon(Icons.forward_10_rounded, color: Colors.white70),
                onPressed: () => notifier.seek((audio.position.inMilliseconds + 10000)
                    .clamp(0, audio.duration.inMilliseconds) / audio.duration.inMilliseconds.clamp(1, double.maxFinite)),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white54, size: 20),
                onPressed: () => notifier.stop(),
              ),
            ],
          ),
        ],
      ),
    ).animate().slideY(begin: 1, duration: 300.ms, curve: Curves.easeOut);
  }

  String _qariName(String id) {
    final q = kSupportedQari.firstWhere((q) => q.id == id, orElse: () => kSupportedQari.first);
    return q.name;
  }
}

// ─── Info chip ────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const Gap(4),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

// ─── Circle icon button ───────────────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool filled;
  const _CircleIconButton({required this.icon, required this.color, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? color.withValues(alpha: 0.15) : Colors.transparent,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

// ─── Skeleton loading ─────────────────────────────────────────────────────────

class _SkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: 6,
        itemBuilder: (_, i) => Container(
          height: 180,
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
    );
  }
}

// ─── Error retry ──────────────────────────────────────────────────────────────

class _ErrorRetry extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorRetry({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 56, color: AppColors.textHint),
          const Gap(AppSpacing.md),
          Text('Gagal memuat data', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const Gap(AppSpacing.sm),
          Text('Periksa koneksi internet kamu', style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
          const Gap(AppSpacing.lg),
          AppButton.outlined(label: 'Coba Lagi', icon: Icons.refresh_rounded, fullWidth: false, onPressed: onRetry),
        ],
      ),
    );
  }
}
