import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../prayer/domain/prayer_provider.dart';
import '../../domain/qibla_provider.dart';

class QiblaPage extends ConsumerWidget {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.nightGradient),
        child: SafeArea(
          child: locationAsync.when(
            loading: () => const _LoadingView(),
            error: (e, _) => _ErrorView(
              message: e.toString().replaceAll('Exception: ', ''),
              onRetry: () => ref.invalidate(locationProvider),
            ),
            data: (_) => const _QiblaCompassView(),
          ),
        ),
      ),
      ),
    );
  }
}

// ─── Loading ───────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.accent),
          Gap(AppSpacing.md),
          Text('Mendapatkan lokasi...', style: TextStyle(color: Colors.white60)),
        ],
      ),
    );
  }
}

// ─── Error ─────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.explore_off_rounded, color: AppColors.accent, size: 64),
            const Gap(AppSpacing.lg),
            Text(
              'Lokasi diperlukan',
              style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.sm),
            Text(
              message,
              style: AppTextStyles.bodyRegular.copyWith(color: Colors.white60),
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.xl),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Izinkan Lokasi'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Compass view ──────────────────────────────────────────────────────────────

class _QiblaCompassView extends ConsumerWidget {
  const _QiblaCompassView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bearingAsync = ref.watch(qiblaBearingProvider);
    final headingAsync = ref.watch(compassHeadingProvider);
    final distanceAsync = ref.watch(qiblaDistanceProvider);

    final qiblaBearing = bearingAsync.value ?? 0.0;
    final compassHeading = headingAsync.value ?? 0.0;
    final distance = distanceAsync.value;

    // The qibla needle angle on screen = qiblaBearing - compassHeading
    final needleAngle = (qiblaBearing - compassHeading) * pi / 180;

    return Column(
      children: [
        const Gap(AppSpacing.lg),
        // Title
        Text(
          'Arah Qibla',
          style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
        ).animate().fadeIn(duration: 400.ms),
        const Gap(AppSpacing.xs),
        if (distance != null)
          Text(
            '${distance.toStringAsFixed(0)} km dari Ka\'bah',
            style: AppTextStyles.caption.copyWith(color: AppColors.accent),
          ).animate(delay: 100.ms).fadeIn(),

        const Spacer(),

        // Compass
        _AnimatedCompass(
          needleAngle: needleAngle,
          compassHeading: compassHeading,
          qiblaBearing: qiblaBearing,
          hasCompass: headingAsync.hasValue,
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

        const Spacer(),

        // Info footer
        _QiblaInfoFooter(
          bearing: qiblaBearing,
          heading: compassHeading,
          hasCompass: headingAsync.hasValue,
          isLoading: headingAsync.isLoading || bearingAsync.isLoading,
        ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1),

        const Gap(AppSpacing.xl),
      ],
    );
  }
}

// ─── Animated compass widget ──────────────────────────────────────────────────

class _AnimatedCompass extends StatelessWidget {
  final double needleAngle;
  final double compassHeading;
  final double qiblaBearing;
  final bool hasCompass;

  const _AnimatedCompass({
    required this.needleAngle,
    required this.compassHeading,
    required this.qiblaBearing,
    required this.hasCompass,
  });

  @override
  Widget build(BuildContext context) {
    const size = 280.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer decorative ring with tick marks (rotates with compass)
          Transform.rotate(
            angle: -compassHeading * pi / 180,
            child: CustomPaint(
              size: const Size(size, size),
              painter: _CompassRingPainter(),
            ),
          ),

          // Inner dark circle background
          Container(
            width: size - 56,
            height: size - 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkCard.withValues(alpha: 0.7),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
          ),

          // Islamic geometric ornament (static, decorative)
          Opacity(
            opacity: 0.06,
            child: CustomPaint(
              size: const Size(size - 80, size - 80),
              painter: _IslamicGeometricPainter(),
            ),
          ),

          // Cardinal labels — rotate with compass so world-N stays up
          Transform.rotate(
            angle: -compassHeading * pi / 180,
            child: SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _CardinalLabel('U', const Offset(0, -1), isNorth: true),
                  _CardinalLabel('S', const Offset(0, 1)),
                  _CardinalLabel('T', const Offset(1, 0)),
                  _CardinalLabel('B', const Offset(-1, 0)),
                ],
              ),
            ),
          ),

          // Qibla needle
          AnimatedRotation(
            turns: needleAngle / (2 * pi),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: CustomPaint(
              size: const Size(size - 80, size - 80),
              painter: _NeedlePainter(active: hasCompass),
            ),
          ),

          // Center hub
          Container(
            width: 16, height: 16,
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: AppColors.accent.withValues(alpha: 0.5), blurRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardinalLabel extends StatelessWidget {
  final String label;
  final Offset direction; // unit vector
  final bool isNorth;
  const _CardinalLabel(this.label, this.direction, {this.isNorth = false});

  @override
  Widget build(BuildContext context) {
    const r = 120.0;
    return Transform.translate(
      offset: Offset(direction.dx * r, direction.dy * r),
      child: Text(
        label,
        style: TextStyle(
          color: isNorth ? Colors.red.shade400 : Colors.white.withValues(alpha: 0.6),
          fontSize: isNorth ? 15 : 12,
          fontWeight: isNorth ? FontWeight.w800 : FontWeight.w500,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// Compass ring with tick marks
class _CompassRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width / 2;
    final innerR = outerR - 14;

    final majorPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final minorPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    final ringPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(Offset(cx, cy), outerR - 2, ringPaint);

    for (int i = 0; i < 72; i++) {
      final angle = i * 5 * pi / 180 - pi / 2;
      final isMajor = i % 6 == 0; // every 30°
      final isMid = i % 3 == 0;   // every 15°
      final tickLen = isMajor ? 12.0 : isMid ? 7.0 : 4.0;
      final paint = (isMajor || isMid) ? majorPaint : minorPaint;
      canvas.drawLine(
        Offset(cx + (outerR - 3) * cos(angle), cy + (outerR - 3) * sin(angle)),
        Offset(cx + (outerR - 3 - tickLen) * cos(angle), cy + (outerR - 3 - tickLen) * sin(angle)),
        paint,
      );
    }
    // Inner ring
    canvas.drawCircle(Offset(cx, cy), innerR - 8,
        Paint()..color = Colors.white.withValues(alpha: 0.05)..style = PaintingStyle.stroke..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(_) => false;
}

// Qibla needle CustomPainter
class _NeedlePainter extends CustomPainter {
  final bool active;
  const _NeedlePainter({required this.active});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    if (!active) {
      final paint = Paint()
        ..color = AppColors.accent.withValues(alpha: 0.3)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(cx, cy - 8), Offset(cx, cy - size.height / 2 + 16), paint);
      return;
    }

    // Needle tip glow
    final glowPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(cx, cy - size.height / 2 + 22), 10, glowPaint);

    // Needle body gradient
    final needleRect = Rect.fromLTRB(cx - 3, cy - size.height / 2 + 26, cx + 3, cy - 10);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.accent, AppColors.accent.withValues(alpha: 0)],
    );
    final needlePaint = Paint()..shader = gradient.createShader(needleRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(needleRect, const Radius.circular(2)),
      needlePaint,
    );

    // Tip circle (Ka'bah marker)
    final tipPaint = Paint()..color = AppColors.accent;
    canvas.drawCircle(Offset(cx, cy - size.height / 2 + 22), 9, tipPaint);
    final iconPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    // Simple mosque outline
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy - size.height / 2 + 22), width: 8, height: 8), iconPaint);
  }

  @override
  bool shouldRepaint(covariant _NeedlePainter old) => old.active != active;
}

// Islamic 8-pointed star geometric
class _IslamicGeometricPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    final path = Path();
    for (int i = 0; i < 8; i++) {
      final a = i * pi / 4 - pi / 8;
      final b = a + pi / 8;
      final outer = Offset(cx + r * cos(a), cy + r * sin(a));
      final inner = Offset(cx + r * 0.38 * cos(b), cy + r * 0.38 * sin(b));
      i == 0 ? path.moveTo(outer.dx, outer.dy) : path.lineTo(outer.dx, outer.dy);
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(cx, cy), r * 0.38, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Info footer ───────────────────────────────────────────────────────────────

class _QiblaInfoFooter extends StatelessWidget {
  final double bearing;
  final double heading;
  final bool hasCompass;
  final bool isLoading;

  const _QiblaInfoFooter({
    required this.bearing,
    required this.heading,
    required this.hasCompass,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          if (isLoading)
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                    dimension: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.accent)),
                Gap(AppSpacing.sm),
                Text('Mendeteksi arah...', style: TextStyle(color: Colors.white60)),
              ],
            )
          else if (hasCompass)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.explore_rounded,
                      color: AppColors.accent, size: 16),
                  const Gap(AppSpacing.sm),
                  Text(
                    'Qibla ${bearing.toStringAsFixed(1)}° dari Utara',
                    style: AppTextStyles.caption.copyWith(color: AppColors.accent),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                'Kompas tidak tersedia di perangkat ini',
                style: AppTextStyles.caption.copyWith(color: Colors.white38),
              ),
            ),
          const Gap(AppSpacing.sm),
          Text(
            'Putar perangkat hingga panah emas menunjuk Ka\'bah',
            style: AppTextStyles.caption.copyWith(color: Colors.white38),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
