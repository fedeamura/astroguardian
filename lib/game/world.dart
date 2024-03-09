import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:util/util.dart';
import 'package:model/model.dart';

import 'chunk/chunk.dart';
import 'game.dart';
import 'ship/ship.dart';

class GameWorld extends Forge2DWorld with HasGameRef<GameComponent> {
  late ShipComponent shipComponent;
  late PositionComponent _chunkLayer;
  late PositionComponent _backgroundLayer;

  late PositionComponent planetLayer;
  late PositionComponent planetOrbitLayer;
  late PositionComponent shipLayer;
  late PositionComponent shipRayLayer;
  late PositionComponent shipParticleLayer;
  late PositionComponent shipExperienceLayer;
  late PositionComponent planetPercentageLayer;
  late PositionComponent planetSatelliteLayer;

  final _chunks = Array<ChunkComponent>();

  int _recreateChunksCurrentChunksVersion = -1;

  @override
  FutureOr<void> onLoad() async {
    gravity = Vector2.zero();

    _backgroundLayer = RectangleComponent(position: Vector2.zero());
    await add(_backgroundLayer);

    _chunkLayer = RectangleComponent(position: Vector2.zero());
    await add(_chunkLayer);

    planetOrbitLayer = PositionComponent();
    await add(planetOrbitLayer);

    shipRayLayer = PositionComponent();
    await add(shipRayLayer);

    planetLayer = PositionComponent();
    await add(planetLayer);

    planetSatelliteLayer = PositionComponent();
    await add(planetSatelliteLayer);

    planetPercentageLayer = PositionComponent();
    await add(planetPercentageLayer);

    shipLayer = PositionComponent();
    await add(shipLayer);

    shipParticleLayer = PositionComponent();
    await add(shipParticleLayer);

    shipExperienceLayer = PositionComponent();
    await add(shipExperienceLayer);

    final ship = game.game.ship;
    shipComponent = ShipComponent(
      startRotation: ship.rotation,
      startPosition: Vector2(ship.position.x, ship.position.y),
    );
    await shipLayer.add(shipComponent);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _recreateChunks();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final camera = CameraComponent.currentCamera;
    if (camera != game.camera) {
      _drawShip(canvas);
    }
  }

  _drawShip(Canvas canvas) {
    final shipPosition = shipComponent.position;
    final indicatorSize = GameConstants.minimapSize * 0.1;

    final path = Path();
    path.moveTo(
      0,
      -indicatorSize * 0.5,
    );
    path.lineTo(
      indicatorSize * 0.5,
      indicatorSize * 0.5,
    );
    path.lineTo(
      -indicatorSize * 0.5,
      indicatorSize * 0.5,
    );
    path.close();

    canvas.save();
    canvas.translate(shipPosition.x, shipPosition.y);
    canvas.rotate(shipComponent.angle);

    canvas.drawPath(
      path,
      Paint()..color = Colors.amber,
    );

    canvas.drawPath(
      path,
      Paint()
        ..strokeWidth = indicatorSize * 0.15
        ..style = PaintingStyle.stroke
        ..color = Colors.white,
    );

    canvas.restore();
  }

  void _recreateChunks() {
    final v = game.game.chunks.version;
    if (_recreateChunksCurrentChunksVersion == v) return;
    _recreateChunksCurrentChunksVersion = v;

    // Add chunks
    for (var entry in game.game.chunks.entries) {
      final chunkPosition = entry.position;

      var chunkComponent = _chunks.get(chunkPosition);
      if (chunkComponent == null) {
        chunkComponent = ChunkComponent(chunk: entry.value);
        _chunks.put(chunkPosition, chunkComponent);
        _chunkLayer.add(chunkComponent);
      }
    }

    // Remove old chunks
    final addedChunks = _chunks.entries.toList();
    for (var element in addedChunks) {
      final pos = element.position;
      if (game.game.chunks.get(pos) == null) {
        final chunk = _chunks.get(pos);
        if (chunk != null) {
          if (chunk.chunk.dirty) {
            game.gameService.saveChunk(game.game, chunk.chunk);
          }

          _chunks.remove(pos);
          chunk.removeFromParent();
        }
      }
    }
  }
}
