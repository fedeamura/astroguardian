import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/menu/view/content.dart';
import 'package:flutter/cupertino.dart';

Future<void> showGameDialogMenu(
  BuildContext context, {
  required GameComponent game,
}) async {
  await Navigator.of(context).openDialog(
    (animation) => GameDialogMenuContent(
      animation: animation,
      game: game,
    ),
  );
}
