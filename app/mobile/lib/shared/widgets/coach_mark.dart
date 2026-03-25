import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// A lightweight coach mark system using OverlayEntry.
/// Shows an overlay that highlights a target widget using a key,
/// with a callout bubble and a dismiss action.
///
/// Usage:
///   CoachMarkController.show(context, marks: [
///     CoachMark(targetKey: _key1, title: 'Pengaturan', body: 'Atur tema'),
///   ]);
class CoachMark {
  final GlobalKey targetKey;
  final String title;
  final String body;
  final CalloutPosition position;

  const CoachMark({
    required this.targetKey,
    required this.title,
    required this.body,
    this.position = CalloutPosition.below,
  });
}

enum CalloutPosition { above, below, left, right }

class CoachMarkController {
  static const _prefix = 'coach_mark_shown_';

  static Future<bool> shouldShow(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('$_prefix$id') ?? false);
  }

  static Future<void> markShown(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$id', true);
  }

  static OverlayEntry? _entry;

  static void show(
    BuildContext context, {
    required String id,
    required List<CoachMark> marks,
  }) {
    if (_entry != null) return;
    int _step = 0;

    void advance(StateSetter setState) {
      if (_step < marks.length - 1) {
        setState(() => _step++);
      } else {
        dismiss();
        markShown(id);
      }
    }

    _entry = OverlayEntry(
      builder: (ctx) => _CoachMarkOverlay(
        marks: marks,
        onAdvance: advance,
        onSkip: () {
          dismiss();
          markShown(id);
        },
      ),
    );

    Overlay.of(context).insert(_entry!);
  }

  static void dismiss() {
    _entry?.remove();
    _entry = null;
  }
}

class _CoachMarkOverlay extends StatefulWidget {
  final List<CoachMark> marks;
  final void Function(StateSetter) onAdvance;
  final VoidCallback onSkip;

  const _CoachMarkOverlay({
    required this.marks,
    required this.onAdvance,
    required this.onSkip,
  });

  @override
  State<_CoachMarkOverlay> createState() => _CoachMarkOverlayState();
}

class _CoachMarkOverlayState extends State<_CoachMarkOverlay>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Rect _getTargetRect(CoachMark mark) {
    final renderBox =
        mark.targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return Rect.zero;
    final pos = renderBox.localToGlobal(Offset.zero);
    return pos & renderBox.size;
  }

  @override
  Widget build(BuildContext context) {
    final mark = widget.marks[_step];
    final target = _getTargetRect(mark);
    final screen = MediaQuery.of(context).size;
    final isLast = _step == widget.marks.length - 1;

    // Callout position logic
    double top;
    double? left, right;
    final calloutHeight = 120.0;
    final calloutWidth = 220.0;
    final gap = 12.0;

    if (mark.position == CalloutPosition.below) {
      top = target.bottom + gap;
    } else {
      top = (target.top - calloutHeight - gap).clamp(0.0, screen.height);
    }

    if (target.center.dx + calloutWidth / 2 > screen.width - 16) {
      right = 16;
    } else if (target.center.dx - calloutWidth / 2 < 16) {
      left = 16;
    } else {
      left = target.center.dx - calloutWidth / 2;
    }

    return FadeTransition(
      opacity: _fade,
      child: Stack(
        children: [
          // Scrim
          GestureDetector(
            onTap: widget.onSkip,
            child: Container(color: Colors.black.withValues(alpha: 0.6)),
          ),

          // Spotlight hole (cutout effect via ColorFiltered)
          if (target != Rect.zero)
            Positioned(
              left: target.left - 8,
              top: target.top - 8,
              child: IgnorePointer(
                child: Container(
                  width: target.width + 16,
                  height: target.height + 16,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.8),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),

          // Callout bubble
          Positioned(
            top: top,
            left: left,
            right: right,
            child: SizedBox(
              width: calloutWidth,
              child: _CalloutBubble(
                title: mark.title,
                body: mark.body,
                step: _step + 1,
                total: widget.marks.length,
                isLast: isLast,
                onNext: () => setState(() {
                  widget.onAdvance(setState);
                }),
                onSkip: widget.onSkip,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalloutBubble extends StatelessWidget {
  final String title;
  final String body;
  final int step;
  final int total;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _CalloutBubble({
    required this.title,
    required this.body,
    required this.step,
    required this.total,
    required this.isLast,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                Text('$step/$total',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.accent)),
              ],
            ),
            const SizedBox(height: 6),
            Text(body,
                style: AppTextStyles.caption
                    .copyWith(color: Colors.white70, height: 1.4)),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isLast)
                  TextButton(
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white38,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero),
                    child: const Text('Lewati', style: TextStyle(fontSize: 12)),
                  ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: onNext,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: Text(isLast ? 'Selesai' : 'Berikutnya'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
