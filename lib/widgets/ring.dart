import 'dart:math';

import 'package:flutter/material.dart';

/// A progress ring that animates to [progress] (0 to 1).
class Ring extends StatelessWidget {
  const Ring({
    super.key,
    required this.progress,
    required this.color,
    this.size = 64,
    this.stroke = 7,
    this.child,
  });

  final double progress;
  final Color color;
  final double size;
  final double stroke;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0, 1)),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => CustomPaint(
        painter: _RingPainter(value, color, stroke),
        child: SizedBox.square(dimension: size, child: Center(child: child)),
      ),
      child: child,
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress, this.color, this.stroke);

  final double progress;
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arc = rect.deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arc, 0, 2 * pi, false, paint..color = color.withValues(alpha: 0.15));
    canvas.drawArc(arc, -pi / 2, 2 * pi * progress, false, paint..color = color);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress || old.color != color;
}
