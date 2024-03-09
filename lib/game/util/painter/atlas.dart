import 'dart:ui' as ui;

import 'package:flame/components.dart';

class AtlasPainter {
  final int _limit;

  final ui.Image _image;
  final Vector2 _imageSize;
  final ui.Canvas _canvas;

  AtlasPainter({
    int limit = 10000,
    required ui.Image image,
    required Vector2 imageSize,
    required ui.Canvas canvas,
  })  : _limit = limit,
        _image = image,
        _imageSize = imageSize,
        _canvas = canvas;

  final _data = <_Data>[];

  add({
    required Vector2 position,
    double rotation = 0.0,
    Vector2? size,
  }) {
    _Data data;
    if (_data.isEmpty || _data.last.transforms.length >= _limit) {
      data = _Data(transforms: [], rects: []);
      _data.add(data);
    } else {
      data = _data.last;
    }

    data.transforms.add(
      ui.RSTransform.fromComponents(
        rotation: rotation,
        scale: 1,
        anchorX: 0,
        anchorY: 0,
        translateX: position.x,
        translateY: position.y,
      ),
    );

    data.rects.add(
      ui.Rect.fromLTWH(
        0,
        0,
        size?.x ?? _imageSize.x,
        size?.y ?? _imageSize.y,
      ),
    );
  }

  paint() {
    for (var entry in _data) {
      _canvas.drawAtlas(
        _image,
        entry.transforms,
        entry.rects,
        [],
        ui.BlendMode.src,
        null,
        ui.Paint(),
      );
    }
  }
}

class _Data {
  final List<ui.RSTransform> transforms;
  final List<ui.Rect> rects;

  _Data({
    required this.transforms,
    required this.rects,
  });
}
