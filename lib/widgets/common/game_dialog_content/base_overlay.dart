import 'dart:developer';

import 'package:astro_guardian/game/game.dart';
import 'package:flutter/material.dart';
int _gameOverlayCount = 0;

class GameBaseOverlay extends StatefulWidget {
  final GameComponent game;
  final Widget child;

  const GameBaseOverlay({
    super.key,
    required this.game,
    required this.child,
  });

  @override
  State<GameBaseOverlay> createState() => _GameBaseOverlayState();
}

class _GameBaseOverlayState extends State<GameBaseOverlay> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    _gameOverlayCount += 1;
    _update();
    super.initState();
  }

  @override
  void dispose() {
    _gameOverlayCount -= 1;
    _update();
    super.dispose();
  }

  _update() {
    if (_gameOverlayCount <= 0) {
      widget.game.paused = false;
      log("Game paused false");
    } else {
      widget.game.paused = true;
      log("Game paused true");
    }
  }
}
