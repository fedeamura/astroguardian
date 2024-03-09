import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ImagePainterUtil {
  ImagePainterUtil._();

  static ui.Image createRectangle({
    required double w,
    required double h,
    required ui.Color color,
  }) {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, w, h));
    canvas.drawColor(color, BlendMode.src);
    return recorder.endRecording().toImageSync(w.floor(), h.floor());
  }

  static ui.Image draw({
    required double w,
    required double h,
    required Function(Canvas canvas, Size size) callback,
  }) {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, w, h));
    callback(canvas, Size(w, h));
    return recorder.endRecording().toImageSync(w.floor(), h.floor());
  }

  static ui.Image drawPixels({
    required int w,
    required int h,
    required List<CanvasPixelModel> points,
    ui.Paint? paint,
  }) {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(
      recorder,
      ui.Rect.fromLTWH(
        0,
        0,
        w.toDouble(),
        h.toDouble(),
      ),
    );

    for (var element in points) {
      canvas.drawRect(
        ui.Rect.fromLTWH(
          element.x.toDouble(),
          element.y.toDouble(),
          1,
          1,
        ),
        element.paint ?? paint ?? ui.Paint(),
      );
    }

    return recorder.endRecording().toImageSync(w.floor(), h.floor());
  }

  static ui.Image drawPixelsString({
    required ui.Paint paint,
    required String data,
  }) {
    final lines = data.trim().split("\n").toList();
    final w = lines[0].length;
    final h = lines.length;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(
      recorder,
      ui.Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
    );

    for (int j = 0; j < h; j++) {
      for (int i = 0; i < w; i++) {
        final value = lines[j].trim()[i];

        if (value == "x") {
          canvas.drawRect(
            ui.Rect.fromLTWH(
              i.toDouble(),
              j.toDouble(),
              1,
              1,
            ),
            paint,
          );
        }
      }
    }

    return recorder.endRecording().toImageSync(w, h);
  }
}

class CanvasPixelModel {
  final int x;
  final int y;
  final ui.Paint? paint;

  CanvasPixelModel({required this.x, required this.y, this.paint});
}
