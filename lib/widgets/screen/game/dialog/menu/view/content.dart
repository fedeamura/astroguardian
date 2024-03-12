import 'dart:ui' as ui;

import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/util/painter/image.dart';
import 'package:astro_guardian/widgets/app.dart';
import 'package:astro_guardian/widgets/common/animated_fade_visibility/index.dart';
import 'package:astro_guardian/widgets/common/game_dialog_content/game_dialog_content.dart';
import 'package:astro_guardian/widgets/common/game_list_tile/game_list_tile.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/planets/index.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/ship/ship.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/stellar_map/index.dart';
import 'package:astro_guardian/widgets/screen/game_exit/view/screen.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

class GameDialogMenuContent extends StatefulWidget {
  final Animation<double> animation;
  final GameComponent game;

  const GameDialogMenuContent({super.key, required this.game, required this.animation});

  @override
  State<GameDialogMenuContent> createState() => _GameDialogMenuContentState();
}

class _GameDialogMenuContentState extends State<GameDialogMenuContent> {
  late ui.Image _exclamationPointImage;

  @override
  Widget build(BuildContext context) {
    final game = widget.game.game;
    final conversations = game.conversations;
    final tutorial = game.tutorial;
    final shipVisible = !tutorial || conversations[ConversationType.tutorialLevelUp] == true;
    final withPoints = game.ship.pendingAbilityPoints > 0;
    final shipIndicatorVisible = withPoints;

    return GameDialogContent(
      animation: widget.animation,
      game: widget.game,
      onBackgroundPressed: () => Navigator.of(context).pop(),
      closeButtonVisible: true,
      onCloseButtonPressed: () => Navigator.of(context).pop(),
      title: "Menu",
      builder: (context) => Column(
        children: [
          if (shipVisible) ...[
            GameListTile(
              title: "SHIP",
              onPressed: _goToShip,
              trailingBuilder: (context) => CustomAnimatedFadeVisibility(
                visible: shipIndicatorVisible,
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: RawImage(
                    image: _exclamationPointImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
          ],
          if (!tutorial) ...[
            GameListTile(
              title: "STELLAR MAP",
              onPressed: () => showGameDialogStellarMap(
                context,
                game: widget.game,
              ),
            ),
            const SizedBox(height: 8.0),
            GameListTile(
              title: "PLANETS",
              onPressed: () => showGameDialogPlanets(
                context,
                game: widget.game,
              ),
            ),
            const SizedBox(height: 8.0),
          ],
          GameListTile(
            title: "EXIT",
            onPressed: () => _exitGame(context),
          ),
        ],
      ),
    );
  }

  _exitGame(BuildContext context) => replaceScreen(
        context,
        const GameExitScreen(),
      );

  _goToShip() async {
    await showGameDialogShip(context, game: widget.game);
    setState(() {});
  }

  @override
  void initState() {
    widget.game.save();

    _exclamationPointImage = ImagePainterUtil.drawPixelsString(
      paint: Paint()..color = Colors.amber,
      data: '''
      .........
      ...xxx...
      ...xxx...
      ...xxx...
      ...xxx...
      .........
      ...xxx...
      ...xxx...
      .........
      ''',
    );

    super.initState();
  }
}
