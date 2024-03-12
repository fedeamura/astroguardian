import 'dart:async';

import 'package:astro_guardian/game/game.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'hud/hud.dart';

class GameHudComponent extends FlameGame with KeyboardEvents {
  final GameComponent gameComponent;
  final Function()? createNewGame;
  final Function()? recreate;
  final Function()? menuCallback;

  GameHudComponent({
    required this.gameComponent,
    required this.createNewGame,
    required this.recreate,
    required this.menuCallback,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  late HudComponent _hudComponent;
  bool _isInit = false;

  @override
  FutureOr<void> onLoad() async {
    _hudComponent = HudComponent();
    await camera.viewport.add(_hudComponent);
    return super.onLoad();
  }

  _init() {
    gameComponent.init();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _calculateMounted();
  }

  _calculateMounted() {
    if (!isMounted) return;
    if (_isInit) return;
    _isInit = true;
    _init();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (!isLoaded) {
      return KeyEventResult.ignored;
    }

    gameComponent.keyStopPressed = keysPressed.contains(LogicalKeyboardKey.arrowDown);
    gameComponent.keyMovePressed = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    gameComponent.keyLeftPressed = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    gameComponent.keyRightPressed = keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.space) {
      gameComponent.keyConsumePressed = !gameComponent.keyConsumePressed;
    }

    if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.keyR) {
      recreate?.call();
    }

    if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.keyN) {
      createNewGame?.call();
    }

    if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.keyQ) {
      gameComponent.consumeNearestPlanet();
    }

    if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.keyS) {
      gameComponent.game.ship.bag = 1000;
      gameComponent.save();
    }

    // if (event is RawKeyUpEvent && event.logicalKey == LogicalKeyboardKey.keyJ) {
    //   gameComponent.world.shipComponent.toggleBag();
    // }

    return KeyEventResult.handled;
  }
}
