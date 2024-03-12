import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

import 'planet_render.dart';

class PlanetPreview extends StatelessWidget {
  final String gameUid;
  final PlanetInfo planet;
  final PlanetTerrain? terrain;

  const PlanetPreview({
    super.key,
    required this.gameUid,
    required this.planet,
    required this.terrain,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: terrain == null
          ? Container(
              key: const ValueKey("empty"),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade600,
              ),
            )
          : GameWidget.controlled(
              key: const ValueKey("content"),
              gameFactory: () => PlanetInfoGame(
                info: planet,
                terrain: terrain!,
                onLoaded: () {

                },
              ),
            ),
    );
  }
}

class PlanetInfoGame extends FlameGame {
  final PlanetInfo info;
  final PlanetTerrain terrain;
  final Function()? onLoaded;

  PlanetInfoGame({
    required this.info,
    required this.terrain,
    required this.onLoaded,
  });

  late PlanetRenderComponent _planetRenderComponent;

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  FutureOr<void> onLoad() async {
    _planetRenderComponent = PlanetRenderComponent(
      info: info,
      terrain: terrain,
    );
    await add(_planetRenderComponent);

    _planetRenderComponent.loaded.then((value) => onLoaded?.call());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _planetRenderComponent.position = Vector2.all(size.x * 0.5);
    super.update(dt);
  }
}
