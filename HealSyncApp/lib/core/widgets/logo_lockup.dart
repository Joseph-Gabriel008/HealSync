import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HealSyncLogo extends StatelessWidget {
  const HealSyncLogo({
    super.key,
    this.size = 88,
    this.showWordmark = true,
    this.compact = false,
  });

  final double size;
  final bool showWordmark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final wordmark = ShaderMask(
      shaderCallback: (bounds) => AppTheme.heroGradient.createShader(bounds),
      child: Text(
        'HealSync',
        style: TextStyle(
          color: Colors.white,
          fontSize: compact ? 24 : 34,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.2,
        ),
      ),
    );

    if (!showWordmark) {
      return _LogoMark(size: size);
    }

    return compact
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LogoMark(size: size),
              const SizedBox(width: 12),
              wordmark,
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LogoMark(size: size),
              const SizedBox(height: 18),
              wordmark,
            ],
          );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.heroGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.blue.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
          ),
          Container(
            width: size * 0.58,
            height: size * 0.58,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            left: size * 0.02,
            child: Container(
              width: size * 0.24,
              height: size * 0.24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.06),
                gradient: const LinearGradient(
                  colors: [AppTheme.deepBlue, AppTheme.blue],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            left: -size * 0.08,
            child: Container(
              width: size * 0.18,
              height: size * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.06),
                gradient: const LinearGradient(
                  colors: [AppTheme.deepBlue, AppTheme.blue],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Container(
            width: size * 0.44,
            height: size * 0.44,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.green, AppTheme.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            right: -size * 0.07,
            top: size * 0.18,
            child: Row(
              children: List.generate(
                3,
                (index) => Container(
                  width: size * (0.08 + (index * 0.02)),
                  height: size * (0.08 + (index * 0.02)),
                  margin: const EdgeInsets.only(left: 4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppTheme.green, AppTheme.blue],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(child: CustomPaint(painter: _PulsePainter())),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.7),
                    width: size * 0.045,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.56)
      ..lineTo(size.width * 0.34, size.height * 0.56)
      ..lineTo(size.width * 0.42, size.height * 0.38)
      ..lineTo(size.width * 0.5, size.height * 0.66)
      ..lineTo(size.width * 0.6, size.height * 0.34)
      ..lineTo(size.width * 0.68, size.height * 0.56)
      ..lineTo(size.width * 0.84, size.height * 0.56);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
