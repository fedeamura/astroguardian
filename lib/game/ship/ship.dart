import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/game_mask.dart';
import 'package:astro_guardian/game/planet_satellite/planet_satellite.dart';
import 'package:astro_guardian/game/ship/experience_particle.dart';
import 'package:astro_guardian/game/ship/ray.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:util/util.dart';

import 'attraction_area.dart';
import 'particle.dart';

class ShipComponent extends BodyComponent<GameComponent> {
  final Vector2 startPosition;
  final double startRotation;

  late ShipAttractionAreaComponent _attractionAreaComponent;
  late ShipRayComponent rayComponent;
  late SpriteComponent _spriteComponent;

  ShipComponent({
    required this.startPosition,
    required this.startRotation,
  });

  bool get isGhost => false;

  bool isStopping = false;

  bool get _moving => body.linearVelocity != Vector2.zero();

  bool get _rotating => body.angularVelocity != 0;

  bool? _currentIsGhost;

  double _elapsedStopTime = 0.0;

  double get _animMoveShipDelay => 0.1;
  double _animMoveShipUpdate = 1.0;

  final _rnd = RandomUtil();

  bool _recycling = false;

  TimerComponent? _timerRecycle;

  bool _shaking = false;
  double _shakingAmplitude = 1.0;

  @override
  Future<void> onLoad() async {
    renderBody = false;

    _attractionAreaComponent = ShipAttractionAreaComponent();
    await add(_attractionAreaComponent);

    const s = 2.0;
    _spriteComponent = SpriteComponent(
      size: Vector2.all(s),
      position: Vector2.all(-s * 0.5),
      sprite: Sprite(
        game.images.fromCache("ship.png"),
        srcSize: Vector2.all(36),
      ),
    );
    await add(_spriteComponent);

    rayComponent = ShipRayComponent();
    await game.world.shipRayLayer.add(rayComponent);

    await super.onLoad();
  }

  @override
  Body createBody() {
    final body = world.createBody(
      BodyDef(
        position: startPosition,
        type: BodyType.dynamic,
        userData: this,
        angle: startRotation,
      ),
    );

    return body;
  }

  _updatePhysics() {
    final ship = game.game.ship;

    if (_currentIsGhost == isGhost) return;
    _currentIsGhost = isGhost;

    final currentFixtures = List.from(body.fixtures);
    for (var element in currentFixtures) {
      body.destroyFixture(element);
    }

    const shipScale = 1.0;

    // Bag
    body.createFixture(
      FixtureDef(
        PolygonShape()..setAsBox(0.5, 0.5, Vector2(0.0, 2.0), 0.0),
        restitution: 0,
        friction: 0,
        density: 0,
        filter: !isGhost
            ? (Filter()
              ..maskBits = shipMask
              ..categoryBits = shipCategory)
            : (Filter()
              ..maskBits = ghostMask
              ..categoryBits = ghostCategory),
      ),
    );

    // Ship
    body.createFixture(
      FixtureDef(
        PolygonShape()
          ..set(
            [
              Vector2(-1.00 * shipScale, 1.00 * shipScale),
              Vector2(-1.00 * shipScale, 0.12 * shipScale),
              Vector2(-0.63 * shipScale, -0.62 * shipScale),
              Vector2(-0.25 * shipScale, -1.00 * shipScale),
              Vector2(0.25 * shipScale, -1.0 * shipScale),
              Vector2(0.63 * shipScale, -0.62 * shipScale),
              Vector2(1.00 * shipScale, 0.12 * shipScale),
              Vector2(1.00 * shipScale, 1.00 * shipScale),
            ],
          ),
        restitution: 0,
        friction: 0,
        density: ship.density,
        filter: !isGhost
            ? (Filter()
              ..maskBits = shipMask
              ..categoryBits = shipCategory)
            : (Filter()
              ..maskBits = ghostMask
              ..categoryBits = ghostCategory),
      ),
    );

    body.resetMassData();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updatePhysics();
    _processMove(dt);
    _processMapLimit(dt);
    _processTutorialMapLimit(dt);
    _updateNoise(dt);
    _updateConversations();

    body.linearVelocity.clamp(Vector2.all(-10), Vector2.all(10.0));
  }

  _updateNoise(double dt) {
    final satellites = game.world.physicsWorld.bodies.map((e) => e.userData).where((e) => e != null && e is PlanetSatelliteComponent).toList();
    final count = satellites.length;
    final maxCount = GameConstants.noiseCount;
    final p = (count / maxCount).clamp(0.0, 1.0);
    game.noiseChanged?.call(p);
  }

  _processMapLimit(double dt) {
    final ship = game.game.ship;
    var dampingMultiplier = MathRangeUtil.multiRange(
      distanceToCenter,
      [0.00, 0.90, 1.00],
      [0.00, 0.00, 1.00],
      curve: Curves.easeInQuint,
    );

    const f = 1.0;
    final angle = shipAngleFromOrigin;
    final fx = f * (1 / ship.density) * dampingMultiplier * math.sin(angle);
    final fy = f * (1 / ship.density) * dampingMultiplier * math.cos(angle);
    final mass = body.mass;
    final force = Vector2(
      mass * fx,
      mass * fy,
    );

    if (force != Vector2.zero()) {
      body.applyForce(force);
    }
  }

  _processTutorialMapLimit(double dt) {
    if (!game.game.tutorial) return;

    final ship = game.game.ship;
    var dampingMultiplier = MathRangeUtil.multiRange(
      tutorialDistanceToCenter,
      [0.00, 0.90, 1.00],
      [0.00, 0.00, 1.00],
      curve: Curves.easeInQuint,
    );

    const f = 1.0;
    final angle = shipAngleFromOrigin;
    final fx = f * (1 / ship.density) * dampingMultiplier * math.sin(angle);
    final fy = f * (1 / ship.density) * dampingMultiplier * math.cos(angle);
    final mass = body.mass;
    final force = Vector2(
      mass * fx,
      mass * fy,
    );

    if (force != Vector2.zero()) {
      if (!_informed && force.length > 1.5) {
        _informed = true;
        game.showConversation?.call(ConversationType.tutorialMapLimit);
      }
      body.applyForce(force);
    } else {
      _informed = false;
    }
  }

  bool _informed = false;

  _processMove(double dt) {
    bool moving = false;

    // Rotate left
    if (game.keyLeftPressed && !_recycling) {
      final canRotate = !isStopping;
      if (canRotate) {
        moving = true;
        _rotateShip(dt, left: true);
      }
    }

    // Rotate right
    if (game.keyRightPressed && !_recycling) {
      final canRotate = !isStopping;
      if (canRotate) {
        moving = true;
        _rotateShip(dt, left: false);
      }
    }

    if (game.keyMovePressed && !_recycling) {
      // Moving
      final canMove = !isStopping;

      if (canMove) {
        moving = true;
        _animateMoveShip(dt);
        _moveShip(dt);
      }
    } else {
      // Not moving
      _animMoveShipUpdate = _animMoveShipDelay;
    }

    // Stop
    if (game.keyStopPressed || _recycling) {
      if (_moving || _rotating) {
        final canStop = !isStopping;
        if (canStop) {
          isStopping = true;
        }
      } else {
        isStopping = false;
      }
    } else {
      isStopping = false;
    }

    if (isStopping) {
      _animateMoveRockets(dt);
      _stopShip(dt);
    } else {
      _elapsedStopTime = 0;
    }

    if (!moving) {
      _animMoveShipUpdate = _animMoveShipDelay;
    }
  }

  _rotateShip(double dt, {bool left = false}) {
    final ship = game.game.ship;
    final force = ship.rotationForce;
    if (left) {
      body.setTransform(body.position, body.angle - force * dt);
    } else {
      body.setTransform(body.position, body.angle + force * dt);
    }

    body.angularVelocity = 0.0;
  }

  _moveShip(double dt) {
    final ship = game.game.ship;
    final force = ship.moveForce;
    var forceX = force * math.cos(body.angle - math.pi * 0.5);
    var forceY = force * math.sin(body.angle - math.pi * 0.5);
    body.applyForce(Vector2(forceX, forceY) * dt);

    body.angularVelocity = 0.0;
  }

  _stopShip(double dt) {
    final ship = game.game.ship;
    final stopTime = ship.stopTime;
    if (_elapsedStopTime < stopTime) {
      final dampingForceMagnitude = body.linearVelocity.length * (_elapsedStopTime / stopTime);
      final dampingForce = body.linearVelocity.normalized().scaled(-dampingForceMagnitude);
      body.applyForce(dampingForce);

      final torque = body.angularVelocity * (1 - _elapsedStopTime / stopTime);
      body.applyTorque(-torque);

      _elapsedStopTime += dt;
    } else {
      isStopping = false;
      body.linearVelocity = Vector2.zero();
      body.angularVelocity = 0.0;
      _elapsedStopTime = 0.0;
    }
  }

  void _animateMoveShip(double dt) {
    _animateMoveRockets(dt);
    _animateMoveTrail(dt);
  }

  double _animMoveRockets = 0.0;

  void _animateMoveRockets(double dt) {
    _animMoveRockets += dt;
    if (_animMoveRockets < 0.1) return;
    _animMoveRockets = 0;

    for (int i = 0; i < 10; i++) {
      final d = _rnd.nextDoubleInRange(0.0, 0.6);
      final angle = _rnd.nextDouble() * math.pi;
      final x = 0.0 + d * math.cos(angle);
      final y = 0.9 + d * math.sin(angle);
      final colorValue = _rnd.nextDoubleInRange(0, 50);
      final color = HSVColor.fromAHSV(1.0, colorValue, 1.0, 1.0).toColor();
      final radius = _rnd.nextDoubleInRange(0.15, 0.25);

      final particle = ShipParticleComponent(
        startPosition: Vector2(x, y),
        radius: radius,
        moveAngle: 0,
        speed: 0,
        color: color,
      );
      add(particle);
    }
  }

  void _animateMoveTrail(double dt) {
    _animMoveShipUpdate += dt;
    if (_animMoveShipUpdate < _animMoveShipDelay) return;
    _animMoveShipUpdate = 0;

    final radius = _rnd.nextDoubleInRange(0.15, 0.25);
    final colorValue = _rnd.nextDoubleInRange(0, 50);
    final color = HSVColor.fromAHSV(1.0, colorValue, 1.0, 1.0).toColor();

    final particle = ShipParticleComponent(
      startPosition: localToParent(
        Vector2(
          0.0,
          0.9 * 1.0,
        ),
      ),
      radius: radius,
      moveAngle: body.angle + math.pi * 0.5,
      speed: 1,
      color: color,
    );
    game.world.shipParticleLayer.add(particle);
  }

  double get distanceToCenter {
    final pos = Vector2(body.position.x, body.position.y);
    return (pos.distanceTo(Vector2.zero()) / GameConstants.gameLimit).clamp(0.0, 1.0);
  }

  double get tutorialDistanceToCenter {
    final pos = Vector2(body.position.x, body.position.y);
    final max = game.game.chunkSize * GameConstants.tutorialDistance * 0.75;
    return (pos.distanceTo(Vector2.zero()) / max).clamp(0.0, 1.0);
  }

  double get shipAngleRotationFromOrigin {
    final origin = Vector2.zero();
    final player = body.position;
    final specificPoint = localToParent(Vector2(0, -10));
    final vector1 = Vector2(player.x - origin.x, player.y - origin.y);
    final vector2 = Vector2(specificPoint.x - player.x, specificPoint.y - player.y);
    final angle = math.atan2(vector2.y, vector2.x) - math.atan2(vector1.y, vector1.x);
    if (angle.isNaN) return 0;
    return angle;
  }

  double get shipAngleFromOrigin {
    final origin = Vector2.zero();
    final player = body.position;
    final specificPoint = Vector2(0, -10);
    final vector1 = Vector2(player.x - origin.x, player.y - origin.y);
    final vector2 = Vector2(specificPoint.x - origin.x, specificPoint.y - origin.y);

    final signedAngle = math.atan2(vector2.y, vector2.x) - math.atan2(vector1.y, vector1.x);

    return signedAngle;
  }

  void toggleRecycle() {
    final recycling = !_recycling;
    final ship = game.game.ship;
    final step = (ship.bagSize.value * 0.1).floor().clamp(1, 100);
    if (recycling && ship.bag < step) {
      log("Bag its empty, cannot recycle");
      _timerRecycle?.removeFromParent();
      _recycling = false;
      return;
    }

    _timerRecycle?.removeFromParent();
    _recycling = recycling;
    _stopShaking();

    if (recycling) {
      _startToShake();
      _timerRecycle = TimerComponent(
        period: 0.2,
        autoStart: true,
        repeat: true,
        onTick: () {
          final currentStep = step.clamp(0, ship.bag);

          if (currentStep > 0) {
            ship.bag -= currentStep;
            _addBagParticle(currentStep);
          }

          if (ship.bag == 0) {
            _timerRecycle?.removeFromParent();
            _recycling = false;
            _recycleFinished();
            _stopShaking();
          }
        },
      );

      add(_timerRecycle!);
    }
  }

  _recycleFinished() {
    game.showConversation?.call(ConversationType.tutorialRecycle);
  }

  Future _startToShake() async {
    _shaking = true;
    _shakingAmplitude = 0.1;

    while (_shaking) {
      await _shake(amplitude: _shakingAmplitude);
      _shakingAmplitude *= 1.1;
    }
  }

  void _stopShaking() {
    _shaking = false;
  }

  Future<void> _shake({double period = 0.2, double amplitude = 0.2}) async {
    final t = period / 2;
    final randomDirection = Vector2(
      _rnd.nextDouble() * amplitude,
      _rnd.nextDouble() * amplitude,
    );

    await _shakeMove(randomDirection, duration: t);
    await _shakeMove(-randomDirection, duration: t);
  }

  Future<void> _shakeMove(Vector2 move, {double duration = 0.05}) {
    final completer = Completer();
    _spriteComponent.add(
      MoveEffect.by(
        move,
        EffectController(duration: duration),
        onComplete: () => completer.complete(),
      ),
    );

    return completer.future;
  }

  void _addBagParticle(int experience) {
    for (int i = 0; i < experience; i++) {
      final d = _rnd.nextDoubleInRange(2.0, 3.0);
      final angle = _rnd.nextDouble() * math.pi * 2;
      final x = d * math.cos(angle);
      final y = d * math.sin(angle);
      final delay = _rnd.nextDoubleInRange(0, 1.0);

      add(
        TimerComponent(
          period: delay,
          autoStart: true,
          removeOnFinish: true,
          onTick: () {
            game.world.shipExperienceLayer.add(
              ExperienceParticleComponent(
                startPosition: body.position + Vector2(x, y),
              ),
            );
          },
        ),
      );
    }
  }

  _updateConversations() {
    final bagFull = game.game.ship.bagPercentage == 1.0;
    if (bagFull) {
      game.showConversation?.call(ConversationType.tutorialBagFull);
    }
  }
}
