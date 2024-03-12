import 'package:astro_guardian/widgets/screen/game/dialog/planets/view/planet_preview.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:usecase/usecase.dart';
import 'package:util/util.dart';

class HomeBackground extends HookWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final rnd = useMemoized(() => RandomUtil());
    final terrain = useMemoized(() => GeneratePlanetTerrainUseCase().call());
    final dx = useMemoized(() => rnd.nextDoubleInRange(0.3, 0.6));
    final dxNegative = useMemoized(() => rnd.nextDouble() > 0.5);
    final dy = useMemoized(() => rnd.nextDoubleInRange(0.1, 0.3));
    final dyNegative = useMemoized(() => rnd.nextDouble() > 0.5);
    final scale = useMemoized(() => rnd.nextDoubleInRange(1.0, 2.0));
    final spinSpeed = useMemoized(() => rnd.nextDoubleInRange(0.05, 0.3));
    final visible = useState(false);

    final planet = PlanetInfo(
      uid: "dummy",
      radius: 10,
      spinSpeed: spinSpeed,
      position: PointDouble(0, 0),
      createdAt: 0,
      percentage: 1,
      updatedAt: 0,
    );

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.all(32.0),
            child: FractionalTranslation(
              translation: Offset(
                dx * (dxNegative ? -1 : 1),
                dy * (dyNegative ? -1 : 1),
              ),
              child: Transform.scale(
                scale: scale,
                child: AnimatedOpacity(
                  opacity: visible.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GameWidget.controlled(
                        gameFactory: () => PlanetInfoGame(
                          info: planet,
                          terrain: terrain,
                          onLoaded: () => visible.value = true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
