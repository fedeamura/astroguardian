import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/ship_ability/view/content.dart';
import 'package:flutter/cupertino.dart';
import 'package:model/model.dart';

Future showGameDialogShipAbility(
  BuildContext context, {
  required GameComponent game,
  required ShipAbility shipAbility,
}) {
  return Navigator.of(context).openDialog(
    (animation) => GameDialogShipAbilityContent(
      shipAbility: shipAbility,
      game: game,
      animation: animation,
    ),
  );
}
