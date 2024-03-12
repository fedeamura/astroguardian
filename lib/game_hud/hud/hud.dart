import 'dart:async';

import 'package:astro_guardian/game/util/painter/image.dart';
import 'package:astro_guardian/game_hud/game_hud.dart';
import 'package:astro_guardian/game_hud/hud/bag.dart';
import 'package:astro_guardian/game_hud/hud/menu_button.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:util/util.dart';

import 'button.dart';
import 'center_tap.dart';
import 'experience.dart';
import 'fps.dart';
import 'map_camera/map_camera.dart';

class HudComponent extends PositionComponent with HasGameRef<GameHudComponent> {
  late HudMapCameraComponent _mapComponent;
  late HudButtonComponent _buttonLeftComponent;
  late HudButtonComponent _buttonRightComponent;
  late HudButtonComponent _buttonMoveComponent;
  late HudButtonComponent _buttonStopComponent;
  late HudButtonComponent _buttonConsumeComponent;
  late HudFpsComponent _hudFpsComponent;
  late HudCenterTapComponent _hudCenterTapComponent;
  late HudExperienceComponent _hudExperienceComponent;
  late HudBagComponent _hudBagComponent;
  late HudMenuButtonComponent _hudMenuButtonComponent;

  bool get _mustLevelUpShip {
    final g = game.gameComponent.game;
    final completed = g.conversations.entries.where((e) => e.value == true).map((e) => e.key).toList();
    completed.sort((a, b) => b.value.compareTo(a.value));

    if (completed.isEmpty) return false;
    if (completed[0] == ConversationType.tutorialLevelUp) return true;
    return false;
  }

  @override
  FutureOr<void> onLoad() async {
    String arrowLeft = '''
    .......
    ..x....
    .x.....
    xxxxxxx
    .x.....
    ..x....
    .......
    ''';

    String arrowRight = '''
    .......
    ....x..
    .....x.
    xxxxxxx
    .....x.
    ....x..
    .......
    ''';


    _mapComponent = HudMapCameraComponent();
    await add(_mapComponent);

    _buttonLeftComponent = HudButtonComponent(
      callbackTapDown: () => game.gameComponent.keyLeftPressed = true,
      callbackTapUp: () => game.gameComponent.keyLeftPressed = false,
      image: ImagePainterUtil.drawPixelsString(
        paint: Paint()..color = Colors.white,
        data: arrowLeft,
      ),
      imageSize: PointInt(7, 7),
    );
    await add(_buttonLeftComponent);

    _buttonRightComponent = HudButtonComponent(
      callbackTapDown: () => game.gameComponent.keyRightPressed = true,
      callbackTapUp: () => game.gameComponent.keyRightPressed = false,
      image: ImagePainterUtil.drawPixelsString(
        paint: Paint()..color = Colors.white,
        data: arrowRight,
      ),
      imageSize: PointInt(7, 7),
    );
    await add(_buttonRightComponent);

    _buttonMoveComponent = HudButtonComponent(
      callbackTapDown: () => game.gameComponent.keyMovePressed = true,
      callbackTapUp: () => game.gameComponent.keyMovePressed = false,
      color: Colors.green.shade600,
    );
    await add(_buttonMoveComponent);

    _buttonStopComponent = HudButtonComponent(
      callbackTapDown: () => game.gameComponent.keyStopPressed = true,
      callbackTapUp: () => game.gameComponent.keyStopPressed = false,
      color: Colors.red.shade600,
    );
    await add(_buttonStopComponent);

    _buttonConsumeComponent = HudButtonComponent(
      callbackTapUp: () => game.gameComponent.keyConsumePressed = !game.gameComponent.keyConsumePressed,
      color: Colors.blue.shade600,
    );
    _buttonConsumeComponent.visible = _isButtonConsumeVisible;
    await add(_buttonConsumeComponent);

    _hudFpsComponent = HudFpsComponent();
    await add(_hudFpsComponent);

    _hudCenterTapComponent = HudCenterTapComponent();
    await add(_hudCenterTapComponent);

    _hudMenuButtonComponent = HudMenuButtonComponent();
    await add(_hudMenuButtonComponent);

    _hudExperienceComponent = HudExperienceComponent();
    await add(_hudExperienceComponent);

    _hudBagComponent = HudBagComponent();
    await add(_hudBagComponent);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final p = game.gameComponent.paddingProvider();
    final scale = game.gameComponent.gameScale;
    final padding = 4.0 * scale;
    final s = game.camera.viewport.size;
    final debug = GameConstants.debug;
    final bottomPadding = p.bottom + padding + (debug ? (10 + padding) : 0);

    const arrowButtonSize = 80.0;
    final innerPadding = scale * 1.0;

    _buttonLeftComponent.size = Vector2.all(arrowButtonSize);
    _buttonLeftComponent.position = Vector2(
      padding + p.left + arrowButtonSize * 0.5,
      s.y - arrowButtonSize - bottomPadding + arrowButtonSize * 0.5,
    );

    _buttonRightComponent.size = Vector2.all(arrowButtonSize);
    _buttonRightComponent.position = Vector2(
      p.left + padding + arrowButtonSize + innerPadding + arrowButtonSize * 0.5,
      s.y - arrowButtonSize - bottomPadding + arrowButtonSize * 0.5,
    );

    _buttonConsumeComponent.visible = _isButtonConsumeVisible;
    _buttonConsumeComponent.size = Vector2.all(arrowButtonSize);
    _buttonConsumeComponent.position = Vector2(
      s.x - p.right - padding - arrowButtonSize * 1.5 + arrowButtonSize * 0.5,
      s.y - arrowButtonSize - bottomPadding - arrowButtonSize - innerPadding + arrowButtonSize * 0.5,
    );

    _buttonStopComponent.size = Vector2.all(arrowButtonSize);
    _buttonStopComponent.position = Vector2(
      s.x - p.right - padding - arrowButtonSize * 1 + arrowButtonSize * 0.5,
      s.y - arrowButtonSize - bottomPadding + arrowButtonSize * 0.5,
    );

    _buttonMoveComponent.size = Vector2.all(arrowButtonSize);
    _buttonMoveComponent.position = Vector2(
      s.x - p.right - padding - arrowButtonSize * 2 - innerPadding + arrowButtonSize * 0.5,
      s.y - arrowButtonSize - bottomPadding + arrowButtonSize * 0.5,
    );
  }

  bool get _isButtonConsumeVisible {
    if (!game.gameComponent.game.tutorial) return true;
    if (_mustLevelUpShip) return false;
    final conversations = game.gameComponent.game.conversations;
    return conversations[ConversationType.tutorialPlanetFound] == true;
  }
}
