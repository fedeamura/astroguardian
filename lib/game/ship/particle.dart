import 'dart:math' as math;

import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/game_mask.dart';
import 'package:astro_guardian/game/util/painter/image.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class ShipParticleComponent extends BodyComponent<GameComponent> {
  final Vector2 startPosition;
  final double radius;
  final double moveAngle;
  final double speed;
  final Color? color;

  ShipParticleComponent({
    super.paint,
    super.children,
    super.priority,
    super.renderBody,
    super.bodyDef,
    super.fixtureDefs,
    super.key,
    this.color,
    required this.startPosition,
    required this.radius,
    required this.moveAngle,
    required this.speed,
  });

  late SpriteComponent _spriteComponent;

  @override
  Future<void> onLoad() {
    String particleData = '''
    .xx.
    x..x
    x..x
    .xx.
    ''';

    _spriteComponent = SpriteComponent(
      anchor: Anchor.center,
      size: Vector2.all(radius * 2),
      sprite: Sprite(
        ImagePainterUtil.drawPixelsString(
          paint: Paint()..color = color ?? Colors.white,
          data: particleData,
        ),
        srcSize: Vector2.all(4),
      ),
    );

    add(_spriteComponent);

    add(
      TimerComponent(
        period: 0.3,
        autoStart: true,
        repeat: false,
        // onTick: () => removeFromParent(),
      ),
    );
    return super.onLoad();
  }

  @override
  Body createBody() {
    setColor(Colors.white);
    renderBody = false;

    final bodyDef = BodyDef(
      userData: this,
      position: startPosition,
      type: BodyType.dynamic,
      linearVelocity: Vector2(
        speed * math.cos(moveAngle),
        speed * math.sin(moveAngle),
      ),
    );

    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(
      shape,
      restitution: 1.0,
      friction: 0.0,
      filter: Filter()
        ..maskBits = particleMask
        ..categoryBits = particleCategory,
    );
    final body = world.createBody(bodyDef);
    body.createFixture(fixtureDef);
    return body;
  }

  @override
  void update(double dt) {
    super.update(dt);

    const t = 5.0;
    _spriteComponent.scale = Vector2(
      _spriteComponent.scale.x * (1 - (t * dt)),
      _spriteComponent.scale.y * (1 - (t * dt)),
    );

    if (_spriteComponent.scale.x <= 0.05 || _spriteComponent.scale.y <= 0.05) {
      // log("Particle removed");
      removeFromParent();
    }
  }
}
