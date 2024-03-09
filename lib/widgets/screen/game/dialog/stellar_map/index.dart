import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/stellar_map/view/content.dart';
import 'package:flutter/material.dart';

Future showGameDialogStellarMap(
  BuildContext context, {
  required GameComponent game,
}) {
  return Navigator.of(context).openDialog(
    (animation) => GameDialogStellarMapContent(
      game: game,
      animation: animation,
    ),
  );
}
