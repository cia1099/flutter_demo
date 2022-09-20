import 'package:flutter/material.dart';

class PaintLine extends CustomPainter {
  final Offset offset;
  final double length;
  final Color? color;
  final double? lineWidth;
  PaintLine(
      {required this.offset, this.length = 0, this.color, this.lineWidth});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.black
      ..strokeWidth = lineWidth ?? 4
      ..style = PaintingStyle.stroke;

    final from = Offset(0, size.height) + offset;
    final to = from - Offset(0, length * 1);
    canvas.drawLine(from, to, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
