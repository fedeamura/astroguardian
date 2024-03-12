import 'dart:async';

import 'package:astro_guardian/game/util/painter/image.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:util/util.dart';

class ShipRayParticleComponent extends PositionComponent {
  final Vector2 Function() positionBuilder;
  final double Function() opacityBuilder;


  ShipRayParticleComponent({
    required this.positionBuilder,
    required this.opacityBuilder,
  });

  final _rnd = RandomUtil();

  late final double _size = _calculateSize();

  late final Color _color = _calculateColor();

  double _calculateSize() {
    final value = _rnd.nextDouble();
    return MathRangeUtil.range(value, 0.0, 1.0, 0.05, 0.2);
  }

  Color _calculateColor() {
    final value = _rnd.nextDoubleInRange(180.0, 300.0);
    return HSVColor.fromAHSV(1.0, value, 0.3, 1.0).toColor().withOpacity(1.0);
  }

  late SpriteComponent _spriteComponent;

  @override
  FutureOr<void> onLoad() async {
    position = positionBuilder();
    anchor = Anchor.center;
    size = Vector2.all(_size);
    scale = Vector2.zero();

    const particleData = '''
    .x.
    xxx
    .x.
    ''';

    _spriteComponent = SpriteComponent(
      size: Vector2.all(_size),
      sprite: Sprite(
        ImagePainterUtil.drawPixelsString(
          paint: Paint()..color = _color,
          data: particleData,
        ),
        srcSize: Vector2.all(3),
      ),
    );
    _spriteComponent.opacity = opacityBuilder();
    await add(_spriteComponent);

    await add(
      ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(duration: 0.2),
        onComplete: () {
          add(
            ScaleEffect.to(
              Vector2.zero(),
              EffectController(duration: 0.2),
              onComplete: () {
                removeFromParent();
              },
            ),
          );
        },
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position = positionBuilder();
    _spriteComponent.opacity = opacityBuilder();
    super.update(dt);
  }
}
