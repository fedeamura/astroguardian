import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

import 'view/content.dart';

Future<void> showGameDialogPlanetDetail(
  BuildContext context, {
  required GameComponent game,
  required PlanetInfo planetInfo,
}) async {
  await Navigator.of(context).openDialog(
    (animation) => GameDialogPlanetDetailContent(
      animation: animation,
      game: game,
      planetInfo: planetInfo,
    ),
  );
}
