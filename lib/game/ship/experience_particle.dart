import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/game_mask.dart';
import 'package:astro_guardian/game/util/painter/image.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:util/util.dart';

class ExperienceParticleComponent extends BodyComponent<GameComponent> {
  final Vector2 startPosition;

  ExperienceParticleComponent({
    super.key,
    required this.startPosition,
  });

  late SpriteComponent _spriteComponent;

  final _rnd = RandomUtil();

  late final double _size = _calculateSize();

  late final Color _color = _calculateColor();

  bool _animating = true;

  double _calculateSize() {
    final value = _rnd.nextDouble();
    return MathRangeUtil.range(value, 0.0, 1.0, 0.1, 0.5);
  }

  Color _calculateColor() {
    var value = _rnd.nextDouble().range(0.0, 1.0, 0.5, 0.9);
    Color amberColor = Colors.amber;
    HSLColor hslColor = HSLColor.fromColor(amberColor);
    HSLColor adjustedColor = hslColor.withLightness(value);
    return adjustedColor.toColor();
  }

  final List<String> _particleData = [
    '''
    ..x..
    ..x..
    .xxx.
    ..x..
    ..x..
    ''',
    '''
    .....
    ..x..
    .xxx.
    ..x..
    .....
    ''',
  ];

  @override
  Future<void> onLoad() async {
    final particleData = _particleData.random;

    _spriteComponent = SpriteComponent(
      anchor: Anchor.center,
      size: Vector2.all(_size),
      sprite: Sprite(
        ImagePainterUtil.drawPixelsString(
          paint: Paint()..color = _color,
          data: particleData,
        ),
        srcSize: Vector2.all(5),
      ),
      scale: Vector2.zero(),
    );

    await add(_spriteComponent);

    await _spriteComponent.add(
      ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(
          duration: 1.0,
          curve: Curves.elasticOut,
        ),
        onComplete: () => _animating = false,
      ),
    );

    await add(
      TimerComponent(
        period: 2.0,
        autoStart: true,
        removeOnFinish: true,
        onTick: () {
          _spriteComponent.add(
            ScaleEffect.to(
              Vector2.all(0.0),
              EffectController(
                duration: 0.4,
                curve: Curves.decelerate,
              ),
              onComplete: () => removeFromParent(),
            ),
          );
        },
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
    );

    final shape = PolygonShape()
      ..setAsBoxXY(
        _size * 0.5,
        _size * 0.5,
      );
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
    _move(dt);
  }

  void _move(double dt) {
    if (_animating) return;

    final ship = game.game.ship;
    final distance = body.position - game.world.shipComponent.body.position;
    final minDistance = ship.bagDistance;

    if (distance.length < minDistance) {
      final sqrtDistance = distance.length2;
      if (sqrtDistance < 1.0) {
        _consume();
      } else {
        const scaleFactor = 30.0;
        final gravityForce = 1.0 / sqrtDistance * scaleFactor;
        final gravityDirection = -distance.normalized();
        final force = gravityDirection * gravityForce;
        body.applyForce(force);
      }
    }
  }

  _consume() async {
    removeFromParent();
    final levelUp = game.gameService.increaseExperience(game.game, 1);
    if (levelUp) {
      await Future.delayed(const Duration(seconds: 1));
      await game.showConversation?.call(ConversationType.tutorialLevelUp);
      await game.openShip?.call();
    }
  }
}
