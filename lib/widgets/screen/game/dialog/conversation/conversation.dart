import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/conversation/view/content.dart';
import 'package:flutter/cupertino.dart';
import 'package:model/model.dart';

Future<void> showGameConversation(
  BuildContext context, {
  required GameComponent game,
  required ConversationType type,
}) async {
  if (!game.game.shouldShowConversation(type)) return;
  game.clearMovement();

  await Navigator.of(context).openDialog(
    (animation) => GameConversationContent(
      game: game,
      type: type,
    ),
  );
  game.game.conversations[type] = true;
  game.save();
}
