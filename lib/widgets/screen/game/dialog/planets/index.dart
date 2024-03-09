import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:flutter/material.dart';

import 'view/content.dart';

Future<void> showGameDialogPlanets(
  BuildContext context, {
  required GameComponent game,
}) async {
  await Navigator.of(context).openDialog(
    (animation) => GameDialogPlanetsContent(
      animation: animation,
      game: game,
    ),
  );
}
