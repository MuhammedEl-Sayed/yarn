import 'package:flutter/material.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppText.body(13,
            color: AppColors.muted, weight: FontWeight.w700),
      );
}

class SelectionRing extends StatelessWidget {
  final bool selected;
  final double size;
  final Widget child;

  const SelectionRing({
    super.key,
    required this.selected,
    required this.child,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.ink : Colors.transparent,
          width: 2,
        ),
      ),
      child: SizedBox(width: size, height: size, child: child),
    );
  }
}

class YarnBall extends StatelessWidget {
  final Color color;
  const YarnBall({super.key, required this.color});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _YarnPainter(color));
}

class _YarnPainter extends CustomPainter {
  final Color color;
  const _YarnPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;

    canvas.drawCircle(c, r, Paint()..color = color);

    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: c, radius: r)));

    final strand = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    for (var i = -1; i <= 1; i++) {
      final dx = i * r * 0.55;
      canvas.drawPath(
        Path()
          ..moveTo(c.dx + dx - r * 0.5, c.dy - r)
          ..quadraticBezierTo(
              c.dx + dx + r * 0.6, c.dy, c.dx + dx - r * 0.5, c.dy + r),
        strand,
      );
    }

    canvas.drawPath(
      Path()
        ..moveTo(c.dx - r, c.dy - r * 0.2)
        ..quadraticBezierTo(c.dx, c.dy + r * 0.5, c.dx + r, c.dy - r * 0.2),
      strand,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_YarnPainter old) => old.color != color;
}
