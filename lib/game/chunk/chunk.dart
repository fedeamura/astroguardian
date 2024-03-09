import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/planet/planet.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:model/model.dart';

class ChunkComponent extends BodyComponent<GameComponent> {
  final Chunk chunk;

  ChunkComponent({
    required this.chunk,
  });

  PlanetComponent? _planetComponent;

  @override
  Future<void> onLoad() async {
    renderBody = false;

    final planet = chunk.planet;
    if (planet != null) {
      _planetComponent = PlanetComponent(planet: planet);
      game.world.planetLayer.add(_planetComponent!);
    }

    return super.onLoad();
  }

  @override
  void onRemove() {
    _planetComponent?.removeFromParent();
    super.onRemove();
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(type: BodyType.static, userData: this);
    return world.createBody(bodyDef);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update position
    final chunkSize = game.game.chunkSize;
    final pos = chunk.position.toDouble() * chunkSize;
    body.position.x = pos.x;
    body.position.y = pos.y;
  }
}
