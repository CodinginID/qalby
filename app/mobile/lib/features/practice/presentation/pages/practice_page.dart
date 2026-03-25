import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/arabic_text.dart';
import '../../../playlist/domain/playlist_provider.dart';
import '../../../quran/domain/quran_provider.dart' show ayatListCompatProvider;

class PracticePage extends ConsumerStatefulWidget {
  final String playlistId;
  const PracticePage({super.key, required this.playlistId});

  @override
  ConsumerState<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends ConsumerState<PracticePage> {
  bool _showTranslation = false;
  int _counterAnimKey = 0;
  double _dragStartX = 0;
  bool _showSwipeHint = false;

  static const _hintKey = 'practice_swipe_hint_shown';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playlist = ref.read(playlistByIdProvider(widget.playlistId));
      if (playlist != null) {
        ref.read(practiceProvider.notifier).start(playlist);
      }
    });
    _checkSwipeHint();
  }

  Future<void> _checkSwipeHint() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool(_hintKey) ?? false;
    if (!shown && mounted) {
      setState(() => _showSwipeHint = true);
    }
  }

  Future<void> _dismissSwipeHint() async {
    if (!_showSwipeHint) return;
    setState(() => _showSwipeHint = false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hintKey, true);
  }

  void _navigate(bool forward) {
    _dismissSwipeHint();
    setState(() => _showTranslation = false);
    if (forward) {
      ref.read(practiceProvider.notifier).next();
    } else {
      ref.read(practiceProvider.notifier).previous();
    }
    HapticFeedback.selectionClick();
  }

  void _goTo(int index) {
    setState(() => _showTranslation = false);
    ref.read(practiceProvider.notifier).goTo(index);
    HapticFeedback.selectionClick();
  }

  void _showVoiceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _VoiceMatchSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(practiceProvider);

    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (session.isAllDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(playlistsProvider.notifier).markPracticed(widget.playlistId);
          context.pushReplacement('/playlists/${widget.playlistId}/practice/result');
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final item = session.currentItem;
    final ayatList = ref.watch(ayatListCompatProvider(item.surahNumber));
    final ayatTexts = ayatList
        .where((a) => a.number >= item.ayatStart && a.number <= item.ayatEnd)
        .toList();

    final total = session.playlist.items.length;
    final currentIndex = session.currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(session.playlist.name, overflow: TextOverflow.ellipsis),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => _confirmExit(context),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(total > 12 ? 20 : 32),
          child: _SegmentedProgress(
            total: total,
            currentIndex: currentIndex,
            completedIds: session.completedIds,
            itemIds: session.playlist.items.map((i) => i.id).toList(),
            onTap: _goTo,
          ),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
        onHorizontalDragStart: (d) => _dragStartX = d.globalPosition.dx,
        onHorizontalDragEnd: (d) {
          final dx = d.globalPosition.dx - _dragStartX;
          if (dx.abs() > 60) {
            if (dx < 0 && !session.isLast) _navigate(true);
            if (dx > 0 && !session.isFirst) _navigate(false);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            // ── Step info bar ─────────────────────────────
            _StepIndicator(
              current: currentIndex + 1,
              total: total,
              surahName: item.surahName,
              rangeLabel: item.rangeLabel,
              isDone: session.isCurrentDone,
            ),

            // ── Ayat card ─────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.04, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                    child: child,
                  ),
                ),
                child: _AyatCard(
                  key: ValueKey('${item.surahNumber}_${item.ayatStart}_${item.ayatEnd}'),
                  item: item,
                  ayatTexts: ayatTexts,
                  showTranslation: _showTranslation,
                  onToggleTranslation: () =>
                      setState(() => _showTranslation = !_showTranslation),
                ),
              ),
            ),

            // ── Bottom controls ───────────────────────────
            _BottomControls(
              session: session,
              counterAnimKey: _counterAnimKey,
              onDecrement: () {
                if (session.currentRepetitions > 0) {
                  ref.read(practiceProvider.notifier).decrementRepetition();
                  HapticFeedback.lightImpact();
                }
              },
              onIncrement: () {
                setState(() => _counterAnimKey++);
                ref.read(practiceProvider.notifier).incrementRepetition();
                HapticFeedback.lightImpact();
              },
              onVoice: () => _showVoiceSheet(context),
              onPrevious: session.isFirst ? null : () => _navigate(false),
              onMarkDone: () {
                ref.read(practiceProvider.notifier).markDone();
                HapticFeedback.mediumImpact();
                if (!session.isLast) _navigate(true);
              },
              onNext: session.isLast ? null : () => _navigate(true),
            ),
          ],
        ),
          ),
          // Swipe hint overlay (first launch only)
          if (_showSwipeHint)
            _SwipeHintOverlay(onDismiss: _dismissSwipeHint),
        ],
      ),
    );
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Keluar Latihan?'),
        content: const Text('Progres sesi ini tidak akan disimpan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Lanjutkan'),
          ),
          TextButton(
            onPressed: () {
              ref.read(practiceProvider.notifier).reset();
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ── Swipe hint overlay ────────────────────────────────────────────────────────

class _SwipeHintOverlay extends StatefulWidget {
  final VoidCallback onDismiss;
  const _SwipeHintOverlay({required this.onDismiss});

  @override
  State<_SwipeHintOverlay> createState() => _SwipeHintOverlayState();
}

class _SwipeHintOverlayState extends State<_SwipeHintOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _dismiss();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _dismiss() {
    _ctrl.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismiss,
      child: FadeTransition(
        opacity: _fade,
        child: Container(
          color: Colors.black.withValues(alpha: 0.55),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ArrowHint(
                      icon: Icons.arrow_back_ios_rounded,
                      label: 'Sebelumnya',
                    ),
                    const Gap(AppSpacing.xl),
                    _ArrowHint(
                      icon: Icons.arrow_forward_ios_rounded,
                      label: 'Berikutnya',
                      isRight: true,
                    ),
                  ],
                ),
                const Gap(AppSpacing.xl),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'Geser kiri/kanan untuk pindah item',
                    style: AppTextStyles.bodyRegular.copyWith(color: Colors.white),
                  ),
                ),
                const Gap(AppSpacing.md),
                Text(
                  'Ketuk di mana saja untuk menutup',
                  style: AppTextStyles.caption.copyWith(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowHint extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isRight;
  const _ArrowHint({required this.icon, required this.label, this.isRight = false});

  @override
  State<_ArrowHint> createState() => _ArrowHintState();
}

class _ArrowHintState extends State<_ArrowHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _slide = Tween<double>(begin: 0, end: widget.isRight ? 8 : -8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slide,
      builder: (_, __) => Transform.translate(
        offset: Offset(_slide.value, 0),
        child: Column(
          children: [
            Icon(widget.icon, color: Colors.white, size: 40),
            const Gap(AppSpacing.xs),
            Text(widget.label,
                style: AppTextStyles.caption.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

// ── Segmented progress bar (interactive) ──────────────────────────────────────

class _SegmentedProgress extends StatelessWidget {
  final int total;
  final int currentIndex;
  final Set<String> completedIds;
  final List<String> itemIds;
  final void Function(int) onTap;

  const _SegmentedProgress({
    required this.total,
    required this.currentIndex,
    required this.completedIds,
    required this.itemIds,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final useDots = total <= 12;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      child: useDots
          ? _DotIndicator(
              total: total,
              currentIndex: currentIndex,
              completedIds: completedIds,
              itemIds: itemIds,
              onTap: onTap,
            )
          : _BarIndicator(
              total: total,
              currentIndex: currentIndex,
              completedIds: completedIds,
              itemIds: itemIds,
              onTap: onTap,
            ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int total;
  final int currentIndex;
  final Set<String> completedIds;
  final List<String> itemIds;
  final void Function(int) onTap;

  const _DotIndicator({
    required this.total,
    required this.currentIndex,
    required this.completedIds,
    required this.itemIds,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isDone = completedIds.contains(itemIds[i]);
        final isCurrent = i == currentIndex;

        Color dotColor;
        double size;
        if (isCurrent) {
          dotColor = AppColors.primary;
          size = 10;
        } else if (isDone) {
          dotColor = AppColors.successLight;
          size = 8;
        } else {
          dotColor = AppColors.divider;
          size = 6;
        }

        return GestureDetector(
          onTap: () => onTap(i),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: isCurrent ? 20 : size,
              height: size,
              decoration: BoxDecoration(
                color: dotColor,
                borderRadius: BorderRadius.circular(AppRadius.full),
                boxShadow: isCurrent
                    ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 6)]
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _BarIndicator extends StatelessWidget {
  final int total;
  final int currentIndex;
  final Set<String> completedIds;
  final List<String> itemIds;
  final void Function(int) onTap;

  const _BarIndicator({
    required this.total,
    required this.currentIndex,
    required this.completedIds,
    required this.itemIds,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final segW = (constraints.maxWidth - (total - 1) * 3) / total;
      return Row(
        children: List.generate(total, (i) {
          final isDone = completedIds.contains(itemIds[i]);
          final isCurrent = i == currentIndex;

          Color color;
          if (isCurrent) {
            color = AppColors.primary;
          } else if (isDone) {
            color = AppColors.successLight;
          } else {
            color = AppColors.divider;
          }

          return GestureDetector(
            onTap: () => onTap(i),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: segW,
                  height: isCurrent ? 5 : 3,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
                if (i < total - 1) const SizedBox(width: 3),
              ],
            ),
          );
        }),
      );
    });
  }
}

// ── Step indicator bar ─────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;
  final String surahName;
  final String rangeLabel;
  final bool isDone;

  const _StepIndicator({
    required this.current,
    required this.total,
    required this.surahName,
    required this.rangeLabel,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              '$current / $total',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Gap(AppSpacing.sm),
          Expanded(
            child: Text(
              surahName,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(AppSpacing.sm),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rangeLabel,
                style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
              ),
              if (isDone) ...[
                const Gap(6),
                Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── Ayat card ──────────────────────────────────────────────────────────────────

class _AyatCard extends StatelessWidget {
  final dynamic item;
  final List<dynamic> ayatTexts;
  final bool showTranslation;
  final VoidCallback onToggleTranslation;

  const _AyatCard({
    super.key,
    required this.item,
    required this.ayatTexts,
    required this.showTranslation,
    required this.onToggleTranslation,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.bgCard(context),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
              ),
              child: ArabicText(
                text: item.surahNameArabic,
                style: AppTextStyles.arabicSmall.copyWith(
                  color: AppColors.accentDark,
                  fontSize: 16,
                ),
              ),
            ),
            const Gap(AppSpacing.lg),
            ...ayatTexts.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ArabicText(
                    text: '${a.arabic} ﴿${a.number}﴾',
                    style: AppTextStyles.arabicAyat.copyWith(color: AppColors.textPrimary),
                  ),
                )),
            const Gap(AppSpacing.xs),
            TextButton.icon(
              icon: Icon(
                showTranslation ? Icons.visibility_off_outlined : Icons.translate_rounded,
                size: 16,
              ),
              label: Text(showTranslation ? 'Sembunyikan Terjemahan' : 'Lihat Terjemahan'),
              onPressed: onToggleTranslation,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textHint,
                textStyle: AppTextStyles.caption,
              ),
            ),
            if (showTranslation)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  children: ayatTexts
                      .map((a) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Text(
                              '${a.number}. ${a.translation}',
                              style: AppTextStyles.bodyRegular.copyWith(
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ).animate().fadeIn(duration: 200.ms),
          ],
        ),
      ),
    );
  }
}

// ── Bottom controls ────────────────────────────────────────────────────────────

class _BottomControls extends StatelessWidget {
  final dynamic session;
  final int counterAnimKey;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onVoice;
  final VoidCallback? onPrevious;
  final VoidCallback onMarkDone;
  final VoidCallback? onNext;

  const _BottomControls({
    required this.session,
    required this.counterAnimKey,
    required this.onDecrement,
    required this.onIncrement,
    required this.onVoice,
    required this.onPrevious,
    required this.onMarkDone,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final reps = session.currentRepetitions as int;
    final isDone = session.isCurrentDone as bool;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        border: const Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, bottom + AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Counter ─────────────────────────────────────
          _RepetitionCounter(
            reps: reps,
            animKey: counterAnimKey,
            onDecrement: onDecrement,
            onIncrement: onIncrement,
          ),
          const Gap(AppSpacing.sm),

          // ── Voice match button ───────────────────────────
          _VoiceButton(onTap: onVoice),
          const Gap(AppSpacing.sm),

          // ── Navigation ──────────────────────────────────
          Row(
            children: [
              _NavIconButton(
                icon: Icons.arrow_back_ios_rounded,
                onTap: onPrevious,
                tooltip: 'Sebelumnya',
              ),
              const Gap(AppSpacing.sm),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    icon: Icon(
                      isDone ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                      size: 18,
                    ),
                    label: Text(isDone ? 'Selesai' : 'Tandai Selesai'),
                    style: FilledButton.styleFrom(
                      backgroundColor: isDone ? AppColors.success : AppColors.accent,
                      foregroundColor: Colors.white,
                      textStyle: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                    ),
                    onPressed: onMarkDone,
                  ),
                ),
              ),
              const Gap(AppSpacing.sm),
              _NavIconButton(
                icon: Icons.arrow_forward_ios_rounded,
                onTap: onNext,
                tooltip: 'Berikutnya',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Voice button ───────────────────────────────────────────────────────────────

class _VoiceButton extends StatelessWidget {
  final VoidCallback onTap;
  const _VoiceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Uji pelafalan suara',
      button: true,
      child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF6C3483).withValues(alpha: 0.12),
              const Color(0xFF3A7BD5).withValues(alpha: 0.12),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: const Color(0xFF6C3483).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C3483), Color(0xFF3A7BD5)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic_rounded, color: Colors.white, size: 16),
            ),
            const Gap(AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Uji Pelafalan',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF6C3483),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Cocokkan bacaan dengan tajwid',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textHint,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF6C3483).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                'Segera',
                style: AppTextStyles.labelSmall.copyWith(
                  color: const Color(0xFF6C3483),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Gap(AppSpacing.sm),
          ],
        ),
      ),
      ),
    );
  }
}

// ── Repetition counter ─────────────────────────────────────────────────────────

class _RepetitionCounter extends StatelessWidget {
  final int reps;
  final int animKey;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _RepetitionCounter({
    required this.reps,
    required this.animKey,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CounterButton(icon: Icons.remove_rounded, enabled: reps > 0, onTap: onDecrement),
        SizedBox(
          width: 100,
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: Tween<double>(begin: 0.6, end: 1).animate(
                    CurvedAnimation(parent: anim, curve: Curves.elasticOut),
                  ),
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Text(
                  '$reps',
                  key: ValueKey('counter_$animKey'),
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColors.primary,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'kali diulang',
                style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
              ),
            ],
          ),
        ),
        _CounterButton(
            icon: Icons.add_rounded, enabled: true, primary: true, onTap: onIncrement),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final bool primary;
  final VoidCallback onTap;

  const _CounterButton({
    required this.icon,
    required this.enabled,
    this.primary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: enabled
              ? (primary ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1))
              : AppColors.surface,
          shape: BoxShape.circle,
          border: enabled && !primary
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
              : null,
          boxShadow: enabled && primary
              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3))]
              : null,
        ),
        child: Icon(
          icon,
          size: 22,
          color: enabled ? (primary ? Colors.white : AppColors.primary) : AppColors.textHint,
        ),
      ),
    );
  }
}

// ── Nav icon button ────────────────────────────────────────────────────────────

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;

  const _NavIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: enabled ? AppColors.primary.withValues(alpha: 0.3) : AppColors.divider,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: enabled ? AppColors.primary : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}

// ── Voice match bottom sheet ───────────────────────────────────────────────────

class _VoiceMatchSheet extends StatefulWidget {
  const _VoiceMatchSheet();

  @override
  State<_VoiceMatchSheet> createState() => _VoiceMatchSheetState();
}

class _VoiceMatchSheetState extends State<_VoiceMatchSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      padding: EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.xl, AppSpacing.xl,
          MediaQuery.of(context).padding.bottom + AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          const Gap(AppSpacing.xl),

          // Animated mic
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) {
              final scale = 1.0 + _pulseCtrl.value * 0.15;
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse ring
                  Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF6C3483).withValues(alpha: 0.08 * (1 + _pulseCtrl.value)),
                      ),
                    ),
                  ),
                  Container(
                    width: 80, height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6C3483), Color(0xFF3A7BD5)],
                      ),
                    ),
                    child: const Icon(Icons.mic_rounded, color: Colors.white, size: 36),
                  ),
                ],
              );
            },
          ),
          const Gap(AppSpacing.lg),

          Text(
            'Uji Pelafalan Tajwid',
            style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary),
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Fitur ini akan membandingkan bacaanmu\ndengan aturan tajwid yang benar secara real-time.',
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppColors.textHint,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(AppSpacing.lg),

          // Feature preview pills
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.center,
            children: [
              _FeaturePill('Deteksi Makharijul Huruf', Icons.record_voice_over_rounded),
              _FeaturePill('Kontrol Panjang Pendek', Icons.tune_rounded),
              _FeaturePill('Skor Pelafalan', Icons.stars_rounded),
              _FeaturePill('Umpan Balik Real-time', Icons.feedback_outlined),
            ],
          ),
          const Gap(AppSpacing.xl),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C3483), Color(0xFF3A7BD5)],
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Text(
              'Segera Hadir',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2, duration: 350.ms, curve: Curves.easeOut)
        .fadeIn(duration: 300.ms);
  }
}

class _FeaturePill extends StatelessWidget {
  final String label;
  final IconData icon;
  const _FeaturePill(this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF6C3483).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: const Color(0xFF6C3483).withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF6C3483)),
          const Gap(4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF6C3483),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
