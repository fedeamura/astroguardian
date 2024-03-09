import 'dart:developer';

import 'package:flutter/material.dart';

int _gameOverlayCount = 0;

class GameOverlay extends StatefulWidget {
  final Function() pause;
  final Function() unpause;
  final bool Function() isPaused;
  final Widget child;

  const GameOverlay({
    super.key,
    required this.child,
    required this.pause,
    required this.unpause,
    required this.isPaused,
  });

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
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
      if (widget.isPaused()) {
        log("Game unpaused");
      }
      widget.unpause();
    } else {
      if (!widget.isPaused()) {
        log("Game paused");
      }
      widget.pause();
    }
  }
}
