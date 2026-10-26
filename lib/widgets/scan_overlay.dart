import 'package:flutter/material.dart';

import '../theme.dart';

/// Corner brackets and a glowing line that sweeps over the photo.
class ScanOverlay extends StatelessWidget {
  const ScanOverlay({super.key, required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => CustomPaint(
        painter: _ScanPainter(Curves.easeInOut.transform(animation.value)),
        size: Size.infinite,
      ),
    );
  }
}

class _ScanPainter extends CustomPainter {
  _ScanPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final box = Rect.fromLTRB(36, size.height * 0.2, size.width - 36, size.height * 0.72);

    // Dim everything outside the scan box.
    final dim = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(box, const Radius.circular(28)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(dim, Paint()..color = Colors.black.withValues(alpha: 0.45));

    // Four corner brackets.
    final corner = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const l = 34.0;
    for (final (c, dx, dy) in [
      (box.topLeft, 1.0, 1.0),
      (box.topRight, -1.0, 1.0),
      (box.bottomLeft, 1.0, -1.0),
      (box.bottomRight, -1.0, -1.0),
    ]) {
      canvas.drawPath(
        Path()
          ..moveTo(c.dx, c.dy + dy * l)
          ..lineTo(c.dx, c.dy)
          ..lineTo(c.dx + dx * l, c.dy),
        corner,
      );
    }

    // The scan line with a soft glow trailing behind it.
    final y = box.top + 12 + (box.height - 24) * t;
    final glow = Rect.fromLTRB(box.left + 12, y - 70, box.right - 12, y);
    canvas.drawRect(
      glow,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [green.withValues(alpha: 0), green.withValues(alpha: 0.35)],
        ).createShader(glow),
    );
    canvas.drawLine(
      Offset(box.left + 12, y),
      Offset(box.right - 12, y),
      Paint()
        ..color = green
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_ScanPainter old) => old.t != t;
}
