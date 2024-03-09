import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/widgets/common/game_button/game_button.dart';
import 'package:astro_guardian/widgets/common/game_dialog_content/game_dialog_content.dart';
import 'package:astro_guardian/widgets/common/game_message/game_message.dart';
import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:flutter/material.dart';

Future<T?> showGameDialog<T>(
  BuildContext context, {
  GameComponent? game,
  String title = "",
  TextAlign? titleTextAlign,
  Alignment? titleAlignment,
  String message = "",
  Widget Function(BuildContext context)? contentBuilder,
  Widget Function(BuildContext context)? builder,
  bool closeButtonVisible = false,
  Function()? onCloseButtonPressed,
  Function()? onBackgroundPressed,
}) {
  return Navigator.of(context).openDialog(
    (animation) =>
        builder?.call(context) ??
        GameDialogContent(
          animation: animation,
          game: game,
          title: title,
          titleAlignment: titleAlignment,
          titleTextAlign: titleTextAlign,
          onCloseButtonPressed: onCloseButtonPressed,
          closeButtonVisible: closeButtonVisible,
          onBackgroundPressed: onBackgroundPressed,
          builder: contentBuilder ?? (context) => Text(message),
        ),
  );
}

Future<bool> showGameDialogConfirmation(
  BuildContext context, {
  GameComponent? game,
  String title = "",
  String message = "",
  String yesButton = "Yes",
  String noButton = "No",
  bool yesButtonVisible = true,
  bool noButtonVisible = true,
  Function(bool result)? onButtonPressed,
}) async {
  final result = await showGameDialog(
    context,
    game: game,
    closeButtonVisible: true,
    onBackgroundPressed: () => Navigator.of(context).pop(false),
    onCloseButtonPressed: () => Navigator.of(context).pop(false),
    title: title,
    contentBuilder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: GameMessage(text: message),
        ),
        SizedBox(height: yesButtonVisible || noButtonVisible ? 16.0 : 0.0),
        if (yesButtonVisible)
          GameButton(
            margin: const EdgeInsets.only(top: 16),
            width: double.infinity,
            text: yesButton,
            onPressed: onButtonPressed != null ? () => onButtonPressed.call(true) : () => Navigator.of(context).pop(true),
          ),
        if (noButtonVisible)
          GameButton(
            margin: const EdgeInsets.only(top: 8.0),
            width: double.infinity,
            text: noButton,
            onPressed: onButtonPressed != null ? () => onButtonPressed.call(false) : () => Navigator.of(context).pop(false),
          ),
      ],
    ),
  );

  return result ?? false;
}
