import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Represents the geometric diamond shapes supported in filters.
enum DiamondShape {
  all,
  round,
  princess,
  oval,
  cushion,
  pear,
  emerald,
  radiant,
  marquise,
  asscher,
  heart,
}

/// Custom painter to draw clean, high-precision geometric diamond facet outlines.
class DiamondShapePainter extends CustomPainter {
  final DiamondShape shape;
  final Color color;

  DiamondShapePainter({required this.shape, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;

    switch (shape) {
      case DiamondShape.all:
        final path = Path()
          ..moveTo(cx, h * 0.1)
          ..lineTo(w * 0.85, h * 0.35)
          ..lineTo(cx, h * 0.9)
          ..lineTo(w * 0.15, h * 0.35)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawLine(Offset(w * 0.15, h * 0.35), Offset(w * 0.85, h * 0.35), paint);
        canvas.drawLine(Offset(cx, h * 0.1), Offset(w * 0.38, h * 0.35), paint);
        canvas.drawLine(Offset(cx, h * 0.1), Offset(w * 0.62, h * 0.35), paint);
        canvas.drawLine(Offset(w * 0.38, h * 0.35), Offset(cx, h * 0.9), paint);
        canvas.drawLine(Offset(w * 0.62, h * 0.35), Offset(cx, h * 0.9), paint);
        break;

      case DiamondShape.round:
        canvas.drawCircle(Offset(cx, cy), w * 0.45, paint);
        final tableRadius = w * 0.22;
        final Path tablePath = Path();
        for (int i = 0; i < 8; i++) {
          final angle = i * math.pi / 4;
          final x = cx + tableRadius * math.cos(angle);
          final y = cy + tableRadius * math.sin(angle);
          if (i == 0) {
            tablePath.moveTo(x, y);
          } else {
            tablePath.lineTo(x, y);
          }
        }
        tablePath.close();
        canvas.drawPath(tablePath, paint);

        for (int i = 0; i < 8; i++) {
          final angle = i * math.pi / 4;
          final innerX = cx + tableRadius * math.cos(angle);
          final innerY = cy + tableRadius * math.sin(angle);
          final outerX = cx + (w * 0.45) * math.cos(angle);
          final outerY = cy + (w * 0.45) * math.sin(angle);
          canvas.drawLine(Offset(innerX, innerY), Offset(outerX, outerY), paint);

          final midAngle = (i + 0.5) * math.pi / 4;
          final outerMidX = cx + (w * 0.45) * math.cos(midAngle);
          final outerMidY = cy + (w * 0.45) * math.sin(midAngle);
          canvas.drawLine(Offset(innerX, innerY), Offset(outerMidX, outerMidY), paint);

          final nextAngle = (i + 1) * math.pi / 4;
          final nextInnerX = cx + tableRadius * math.cos(nextAngle);
          final nextInnerY = cy + tableRadius * math.sin(nextAngle);
          canvas.drawLine(Offset(nextInnerX, nextInnerY), Offset(outerMidX, outerMidY), paint);
        }
        break;

      case DiamondShape.princess:
        final r = Rect.fromLTRB(w * 0.15, h * 0.15, w * 0.85, h * 0.85);
        canvas.drawRect(r, paint);
        final Path diamondTable = Path()
          ..moveTo(cx, h * 0.35)
          ..lineTo(w * 0.65, cy)
          ..lineTo(cx, h * 0.65)
          ..lineTo(w * 0.35, cy)
          ..close();
        canvas.drawPath(diamondTable, paint);
        canvas.drawLine(Offset(w * 0.15, h * 0.15), Offset(w * 0.35, h * 0.35), paint);
        canvas.drawLine(Offset(w * 0.85, h * 0.15), Offset(w * 0.65, h * 0.35), paint);
        canvas.drawLine(Offset(w * 0.85, h * 0.85), Offset(w * 0.65, h * 0.65), paint);
        canvas.drawLine(Offset(w * 0.15, h * 0.85), Offset(w * 0.35, h * 0.65), paint);
        canvas.drawLine(Offset(cx, h * 0.15), Offset(cx, h * 0.35), paint);
        canvas.drawLine(Offset(cx, h * 0.85), Offset(cx, h * 0.65), paint);
        canvas.drawLine(Offset(w * 0.15, cy), Offset(w * 0.35, cy), paint);
        canvas.drawLine(Offset(w * 0.85, cy), Offset(w * 0.65, cy), paint);
        break;

      case DiamondShape.oval:
        final r = Rect.fromLTRB(w * 0.18, h * 0.1, w * 0.82, h * 0.9);
        canvas.drawOval(r, paint);
        final tableRx = w * 0.18;
        final tableRy = h * 0.22;
        final Path tablePath = Path();
        for (int i = 0; i < 8; i++) {
          final angle = i * math.pi / 4;
          final x = cx + tableRx * math.cos(angle);
          final y = cy + tableRy * math.sin(angle);
          if (i == 0) {
            tablePath.moveTo(x, y);
          } else {
            tablePath.lineTo(x, y);
          }
        }
        tablePath.close();
        canvas.drawPath(tablePath, paint);

        for (int i = 0; i < 8; i++) {
          final angle = i * math.pi / 4;
          final cosA = math.cos(angle);
          final sinA = math.sin(angle);
          final innerX = cx + tableRx * cosA;
          final innerY = cy + tableRy * sinA;
          final outerX = cx + (w * 0.32) * cosA;
          final outerY = cy + (h * 0.4) * sinA;
          canvas.drawLine(Offset(innerX, innerY), Offset(outerX, outerY), paint);

          final midAngle = (i + 0.5) * math.pi / 4;
          final outerMidX = cx + (w * 0.32) * math.cos(midAngle);
          final outerMidY = cy + (h * 0.4) * math.sin(midAngle);
          canvas.drawLine(Offset(innerX, innerY), Offset(outerMidX, outerMidY), paint);

          final nextAngle = (i + 1) * math.pi / 4;
          final nextInnerX = cx + tableRx * math.cos(nextAngle);
          final nextInnerY = cy + tableRy * math.sin(nextAngle);
          canvas.drawLine(Offset(nextInnerX, nextInnerY), Offset(outerMidX, outerMidY), paint);
        }
        break;

      case DiamondShape.cushion:
        final r = RRect.fromRectAndRadius(
          Rect.fromLTRB(w * 0.15, h * 0.15, w * 0.85, h * 0.85),
          const Radius.circular(12),
        );
        canvas.drawRRect(r, paint);
        final innerR = RRect.fromRectAndRadius(
          Rect.fromLTRB(w * 0.35, h * 0.35, w * 0.65, h * 0.65),
          const Radius.circular(6),
        );
        canvas.drawRRect(innerR, paint);
        canvas.drawLine(Offset(w * 0.22, h * 0.22), Offset(w * 0.35, h * 0.35), paint);
        canvas.drawLine(Offset(w * 0.78, h * 0.22), Offset(w * 0.65, h * 0.35), paint);
        canvas.drawLine(Offset(w * 0.78, h * 0.78), Offset(w * 0.65, h * 0.65), paint);
        canvas.drawLine(Offset(w * 0.22, h * 0.78), Offset(w * 0.35, h * 0.65), paint);
        canvas.drawLine(Offset(cx, h * 0.15), Offset(cx, h * 0.35), paint);
        canvas.drawLine(Offset(cx, h * 0.85), Offset(cx, h * 0.65), paint);
        canvas.drawLine(Offset(w * 0.15, cy), Offset(w * 0.35, cy), paint);
        canvas.drawLine(Offset(w * 0.85, cy), Offset(w * 0.65, cy), paint);
        break;

      case DiamondShape.pear:
        final Path pearPath = Path();
        pearPath.moveTo(cx, h * 0.15);
        pearPath.cubicTo(w * 0.82, h * 0.45, w * 0.82, h * 0.85, cx, h * 0.88);
        pearPath.cubicTo(w * 0.18, h * 0.85, w * 0.18, h * 0.45, cx, h * 0.15);
        pearPath.close();
        canvas.drawPath(pearPath, paint);

        final Path innerPath = Path();
        innerPath.moveTo(cx, h * 0.35);
        innerPath.cubicTo(w * 0.65, h * 0.52, w * 0.65, h * 0.72, cx, h * 0.75);
        innerPath.cubicTo(w * 0.35, h * 0.72, w * 0.35, h * 0.52, cx, h * 0.35);
        innerPath.close();
        canvas.drawPath(innerPath, paint);

        canvas.drawLine(Offset(cx, h * 0.15), Offset(cx, h * 0.35), paint);
        canvas.drawLine(Offset(cx, h * 0.88), Offset(cx, h * 0.75), paint);
        canvas.drawLine(Offset(w * 0.24, h * 0.6), Offset(w * 0.38, h * 0.56), paint);
        canvas.drawLine(Offset(w * 0.76, h * 0.6), Offset(w * 0.62, h * 0.56), paint);
        canvas.drawLine(Offset(w * 0.32, h * 0.76), Offset(w * 0.42, h * 0.68), paint);
        canvas.drawLine(Offset(w * 0.72, h * 0.76), Offset(w * 0.58, h * 0.68), paint);
        break;

      case DiamondShape.emerald:
        final Path outerPath = Path()
          ..moveTo(w * 0.28, h * 0.12)
          ..lineTo(w * 0.72, h * 0.12)
          ..lineTo(w * 0.88, h * 0.28)
          ..lineTo(w * 0.88, h * 0.72)
          ..lineTo(w * 0.72, h * 0.88)
          ..lineTo(w * 0.28, h * 0.88)
          ..lineTo(w * 0.12, h * 0.72)
          ..lineTo(w * 0.12, h * 0.28)
          ..close();
        canvas.drawPath(outerPath, paint);

        final Path midPath = Path()
          ..moveTo(w * 0.34, h * 0.22)
          ..lineTo(w * 0.66, h * 0.22)
          ..lineTo(w * 0.78, h * 0.34)
          ..lineTo(w * 0.78, h * 0.66)
          ..lineTo(w * 0.66, h * 0.78)
          ..lineTo(w * 0.34, h * 0.78)
          ..lineTo(w * 0.22, h * 0.66)
          ..lineTo(w * 0.22, h * 0.34)
          ..close();
        canvas.drawPath(midPath, paint);

        final Path innerPath = Path()
          ..moveTo(w * 0.4, h * 0.32)
          ..lineTo(w * 0.6, h * 0.32)
          ..lineTo(w * 0.68, h * 0.4)
          ..lineTo(w * 0.68, h * 0.6)
          ..lineTo(w * 0.6, h * 0.68)
          ..lineTo(w * 0.4, h * 0.68)
          ..lineTo(w * 0.32, h * 0.6)
          ..lineTo(w * 0.32, h * 0.4)
          ..close();
        canvas.drawPath(innerPath, paint);

        canvas.drawLine(Offset(w * 0.12, h * 0.28), Offset(w * 0.32, h * 0.4), paint);
        canvas.drawLine(Offset(w * 0.88, h * 0.28), Offset(w * 0.62, h * 0.4), paint);
        canvas.drawLine(Offset(w * 0.88, h * 0.72), Offset(w * 0.62, h * 0.6), paint);
        canvas.drawLine(Offset(w * 0.12, h * 0.72), Offset(w * 0.32, h * 0.6), paint);
        break;

      case DiamondShape.radiant:
        final Path outerRadiant = Path()
          ..moveTo(w * 0.25, h * 0.12)
          ..lineTo(w * 0.75, h * 0.12)
          ..lineTo(w * 0.88, h * 0.28)
          ..lineTo(w * 0.88, h * 0.72)
          ..lineTo(w * 0.75, h * 0.88)
          ..lineTo(w * 0.25, h * 0.88)
          ..lineTo(w * 0.12, h * 0.72)
          ..lineTo(w * 0.12, h * 0.28)
          ..close();
        canvas.drawPath(outerRadiant, paint);

        final Path midRadiant = Path()
          ..moveTo(w * 0.32, h * 0.22)
          ..lineTo(w * 0.68, h * 0.22)
          ..lineTo(w * 0.78, h * 0.35)
          ..lineTo(w * 0.78, h * 0.65)
          ..lineTo(w * 0.68, h * 0.78)
          ..lineTo(w * 0.32, h * 0.78)
          ..lineTo(w * 0.22, h * 0.65)
          ..lineTo(w * 0.22, h * 0.35)
          ..close();
        canvas.drawPath(midRadiant, paint);

        final Path innerRadiant = Path()
          ..moveTo(w * 0.38, h * 0.32)
          ..lineTo(w * 0.62, h * 0.32)
          ..lineTo(w * 0.68, h * 0.42)
          ..lineTo(w * 0.68, h * 0.58)
          ..lineTo(w * 0.62, h * 0.68)
          ..lineTo(w * 0.38, h * 0.68)
          ..lineTo(w * 0.32, h * 0.58)
          ..lineTo(w * 0.32, h * 0.42)
          ..close();
        canvas.drawPath(innerRadiant, paint);

        canvas.drawLine(Offset(w * 0.12, h * 0.28), Offset(w * 0.32, h * 0.42), paint);
        canvas.drawLine(Offset(w * 0.88, h * 0.28), Offset(w * 0.62, h * 0.42), paint);
        canvas.drawLine(Offset(w * 0.88, h * 0.72), Offset(w * 0.62, h * 0.58), paint);
        canvas.drawLine(Offset(w * 0.12, h * 0.72), Offset(w * 0.32, h * 0.58), paint);
        canvas.drawLine(Offset(w * 0.25, h * 0.12), Offset(w * 0.38, h * 0.32), paint);
        canvas.drawLine(Offset(w * 0.75, h * 0.12), Offset(w * 0.62, h * 0.32), paint);
        canvas.drawLine(Offset(w * 0.75, h * 0.88), Offset(w * 0.62, h * 0.68), paint);
        canvas.drawLine(Offset(w * 0.25, h * 0.88), Offset(w * 0.38, h * 0.68), paint);
        canvas.drawLine(Offset(cx, h * 0.12), Offset(cx, h * 0.32), paint);
        canvas.drawLine(Offset(cx, h * 0.88), Offset(cx, h * 0.68), paint);
        break;

      case DiamondShape.marquise:
        final Path marquisePath = Path();
        marquisePath.moveTo(w * 0.5, h * 0.08);
        marquisePath.cubicTo(w * 0.88, h * 0.3, w * 0.88, h * 0.7, w * 0.5, h * 0.92);
        marquisePath.cubicTo(w * 0.12, h * 0.7, w * 0.12, h * 0.3, w * 0.5, h * 0.08);
        marquisePath.close();
        canvas.drawPath(marquisePath, paint);

        final Path innerMarquise = Path();
        innerMarquise.moveTo(w * 0.5, h * 0.3);
        innerMarquise.cubicTo(w * 0.68, h * 0.42, w * 0.68, h * 0.58, w * 0.5, h * 0.7);
        innerMarquise.cubicTo(w * 0.32, h * 0.58, w * 0.32, h * 0.42, w * 0.5, h * 0.3);
        innerMarquise.close();
        canvas.drawPath(innerMarquise, paint);

        canvas.drawLine(Offset(w * 0.5, h * 0.08), Offset(w * 0.5, h * 0.3), paint);
        canvas.drawLine(Offset(w * 0.5, h * 0.92), Offset(w * 0.5, h * 0.7), paint);
        canvas.drawLine(Offset(w * 0.2, h * 0.42), Offset(w * 0.38, h * 0.44), paint);
        canvas.drawLine(Offset(w * 0.8, h * 0.42), Offset(w * 0.62, h * 0.44), paint);
        canvas.drawLine(Offset(w * 0.2, h * 0.58), Offset(w * 0.38, h * 0.56), paint);
        canvas.drawLine(Offset(w * 0.8, h * 0.58), Offset(w * 0.62, h * 0.56), paint);
        canvas.drawLine(Offset(w * 0.3, h * 0.3), Offset(w * 0.42, h * 0.38), paint);
        canvas.drawLine(Offset(w * 0.7, h * 0.3), Offset(w * 0.58, h * 0.38), paint);
        canvas.drawLine(Offset(w * 0.3, h * 0.7), Offset(w * 0.42, h * 0.62), paint);
        canvas.drawLine(Offset(w * 0.7, h * 0.7), Offset(w * 0.58, h * 0.62), paint);
        break;

      case DiamondShape.asscher:
        final Path outerAsscher = Path()
          ..moveTo(w * 0.25, h * 0.08)
          ..lineTo(w * 0.75, h * 0.08)
          ..lineTo(w * 0.92, h * 0.25)
          ..lineTo(w * 0.92, h * 0.75)
          ..lineTo(w * 0.75, h * 0.92)
          ..lineTo(w * 0.25, h * 0.92)
          ..lineTo(w * 0.08, h * 0.75)
          ..lineTo(w * 0.08, h * 0.25)
          ..close();
        canvas.drawPath(outerAsscher, paint);

        final Path step1 = Path()
          ..moveTo(w * 0.32, h * 0.18)
          ..lineTo(w * 0.68, h * 0.18)
          ..lineTo(w * 0.82, h * 0.32)
          ..lineTo(w * 0.82, h * 0.68)
          ..lineTo(w * 0.68, h * 0.82)
          ..lineTo(w * 0.32, h * 0.82)
          ..lineTo(w * 0.18, h * 0.68)
          ..lineTo(w * 0.18, h * 0.32)
          ..close();
        canvas.drawPath(step1, paint);

        final Path step2 = Path()
          ..moveTo(w * 0.39, h * 0.28)
          ..lineTo(w * 0.61, h * 0.28)
          ..lineTo(w * 0.72, h * 0.39)
          ..lineTo(w * 0.72, h * 0.61)
          ..lineTo(w * 0.61, h * 0.72)
          ..lineTo(w * 0.39, h * 0.72)
          ..lineTo(w * 0.28, h * 0.61)
          ..lineTo(w * 0.28, h * 0.39)
          ..close();
        canvas.drawPath(step2, paint);

        canvas.drawLine(Offset(w * 0.08, h * 0.25), Offset(w * 0.28, h * 0.39), paint);
        canvas.drawLine(Offset(w * 0.92, h * 0.25), Offset(w * 0.72, h * 0.39), paint);
        canvas.drawLine(Offset(w * 0.92, h * 0.75), Offset(w * 0.72, h * 0.61), paint);
        canvas.drawLine(Offset(w * 0.08, h * 0.75), Offset(w * 0.28, h * 0.61), paint);
        canvas.drawLine(Offset(w * 0.25, h * 0.08), Offset(w * 0.39, h * 0.28), paint);
        canvas.drawLine(Offset(w * 0.75, h * 0.08), Offset(w * 0.61, h * 0.28), paint);
        canvas.drawLine(Offset(w * 0.75, h * 0.92), Offset(w * 0.61, h * 0.72), paint);
        canvas.drawLine(Offset(w * 0.25, h * 0.92), Offset(w * 0.39, h * 0.72), paint);
        canvas.drawLine(Offset(w * 0.18, h * 0.32), Offset(w * 0.28, h * 0.39), paint);
        canvas.drawLine(Offset(w * 0.82, h * 0.32), Offset(w * 0.72, h * 0.39), paint);
        canvas.drawLine(Offset(w * 0.82, h * 0.68), Offset(w * 0.72, h * 0.61), paint);
        canvas.drawLine(Offset(w * 0.18, h * 0.68), Offset(w * 0.28, h * 0.61), paint);
        break;

      case DiamondShape.heart:
        final Path heartOuter = Path();
        heartOuter.moveTo(cx, h * 0.85);
        heartOuter.cubicTo(w * 0.05, h * 0.55, w * 0.05, h * 0.15, cx, h * 0.25);
        heartOuter.cubicTo(w * 0.2, h * 0.12, w * 0.38, h * 0.15, cx, h * 0.35);
        heartOuter.cubicTo(w * 0.62, h * 0.15, w * 0.8, h * 0.12, cx, h * 0.25);
        heartOuter.cubicTo(w * 0.95, h * 0.15, w * 0.95, h * 0.55, cx, h * 0.85);
        heartOuter.close();
        canvas.drawPath(heartOuter, paint);

        final Path heartInner = Path();
        heartInner.moveTo(cx, h * 0.62);
        heartInner.cubicTo(w * 0.28, h * 0.48, w * 0.28, h * 0.3, cx, h * 0.38);
        heartInner.cubicTo(w * 0.42, h * 0.3, w * 0.48, h * 0.35, cx, h * 0.45);
        heartInner.cubicTo(w * 0.52, h * 0.35, w * 0.58, h * 0.3, cx, h * 0.38);
        heartInner.cubicTo(w * 0.72, h * 0.3, w * 0.72, h * 0.48, cx, h * 0.62);
        heartInner.close();
        canvas.drawPath(heartInner, paint);

        canvas.drawLine(Offset(cx, h * 0.25), Offset(cx, h * 0.38), paint);
        canvas.drawLine(Offset(cx, h * 0.85), Offset(cx, h * 0.62), paint);
        canvas.drawLine(Offset(w * 0.2, h * 0.35), Offset(w * 0.34, h * 0.4), paint);
        canvas.drawLine(Offset(w * 0.8, h * 0.35), Offset(w * 0.66, h * 0.4), paint);
        canvas.drawLine(Offset(w * 0.15, h * 0.5), Offset(w * 0.3, h * 0.48), paint);
        canvas.drawLine(Offset(w * 0.85, h * 0.5), Offset(w * 0.7, h * 0.48), paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
