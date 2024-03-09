library game_dialog_ship;

import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/ship/view/content.dart';
import 'package:flutter/cupertino.dart';

Future<void> showGameDialogShip(
  BuildContext context, {
  required GameComponent game,
}) {
  return Navigator.of(context).openDialog(
    (animation) => GameDialogShipContent(
      animation: animation,
      game: game,
    ),
  );
}
