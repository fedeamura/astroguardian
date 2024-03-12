import 'package:astro_guardian/game/game.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:touchable/touchable.dart';

class MapPainter extends CustomPainter {
  final BuildContext context;
  final GameComponent game;
  final List<PlanetSummaryItem> planets;
  final double zoomScale;
  final Offset shipPosition;
  final Function(PlanetSummaryItem planet)? onPressed;
  final String selectedUid;

  MapPainter({
    required this.context,
    required this.game,
    required this.planets,
    required this.zoomScale,
    required this.shipPosition,
    required this.selectedUid,
    this.onPressed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context, canvas);

    const multiplier = 2.0;

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final planet in planets) {
      final pos = Offset(planet.position.x, planet.position.y);
      minX = minX < pos.dx ? minX : pos.dx;
      minY = minY < pos.dy ? minY : pos.dy;
      maxX = maxX > pos.dx ? maxX : pos.dx;
      maxY = maxY > pos.dy ? maxY : pos.dy;
    }

    final width = maxX - minX;
    final height = maxY - minY;
    final scaleX = size.width / width;
    final scaleY = size.height / height;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    bool forceCenter = false;
    if (width == 0.0 && height == 0.0) {
      forceCenter = true;
    }

    for (final planet in planets) {
      final pos = Offset(planet.position.x, planet.position.y);
      final s = 8.0 * multiplier * (1 / zoomScale);

      double x, y;
      if (forceCenter) {
        x = size.width * 0.5;
        y = size.height * 0.5;
      } else {
        x = (pos.dx - minX) * scale + (size.width - width * scale) / 2;
        y = (pos.dy - minY) * scale + (size.height - height * scale) / 2;
      }

      if (!s.isNaN && !x.isNaN && !y.isNaN) {
        myCanvas.drawCircle(
          Offset(x - s * 0.5, y - s * 0.5),
          s,
          Paint()..color = selectedUid == planet.uid ? Colors.amber : Colors.white.withOpacity(0.7),
          onTapUp: (details) {
            onPressed?.call(planet);
          },
        );
      }
    }

    final s = 8.0 * multiplier * (1 / zoomScale);
    double x, y;
    if (forceCenter) {
      x = size.width * 0.5;
      y = size.height * 0.5;
    } else {
      x = (shipPosition.dx - minX) * scale + (size.width - width * scale) / 2;
      y = (shipPosition.dy - minY) * scale + (size.height - height * scale) / 2;
    }

    if (!s.isNaN && !x.isNaN && !y.isNaN) {
      final path = Path();
      path.moveTo(
        0,
        -s * 0.5,
      );
      path.lineTo(
        s * 0.5,
        s * 0.5,
      );
      path.lineTo(
        -s * 0.5,
        s * 0.5,
      );
      path.close();

      canvas.save();

      canvas.translate(x - s * 0.5, y - s * 0.5);
      canvas.drawPath(
        path,
        Paint()..color = Colors.amber,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    if (oldDelegate.planets != planets) return true;
    if (oldDelegate.zoomScale != zoomScale) return true;
    if (oldDelegate.shipPosition != shipPosition) return true;
    if (oldDelegate.selectedUid != selectedUid) return true;
    return false;
  }
}
