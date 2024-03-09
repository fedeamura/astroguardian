import 'package:astro_guardian/widgets/app.dart';
import 'package:astro_guardian/widgets/common/game_button/game_button.dart';
import 'package:astro_guardian/widgets/common/game_dialog/game_dialog.dart';
import 'package:astro_guardian/widgets/common/game_dialog_content/game_dialog_content.dart';
import 'package:astro_guardian/widgets/common/game_list_tile/game_list_tile.dart';
import 'package:astro_guardian/widgets/screen/game/view/screen.dart';
import 'package:astro_guardian/widgets/screen/game_new/game_new.dart';
import 'package:astro_guardian/widgets/screen/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:model/model.dart';
import 'package:service/service.dart';

class GameListScreenContent extends StatefulHookWidget {
  final Animation<double> animation;

  const GameListScreenContent({
    super.key,
    required this.animation,
  });

  @override
  State<GameListScreenContent> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreenContent> {
  GameService get _gameService => GetIt.I.get();

  bool _loading = false;
  var _games = <Game>[];

  @override
  Widget build(BuildContext context) {
    return GameDialogContent(
      animation: widget.animation,
      title: "Games",
      onCloseButtonPressed: () => _goBack(context),
      closeButtonVisible: true,
      onBackgroundPressed: () => _goBack(context),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GameButton(
            width: double.infinity,
            text: "CREATE NEW",
            enabled: !_loading,
            onPressed: () => _createNew(context),
          ),
          const SizedBox(height: 8.0),
          ..._games.map(
            (game) => GameListTile(
              margin: const EdgeInsets.only(top: 8.0),
              title: game.createdAt.toIso8601String(),
              onPressed: () => _openGame(context, game),
              onLongPressed: () => _showGameDialog(context, game),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _refresh());
  }

  _refresh() async {
    setState(() => _loading = true);
    final data = await _gameService.getAll();
    setState(() {
      _loading = false;
      _games = data;
    });
  }

  _goBack(BuildContext context) => replaceScreen(
        context,
        const SplashScreen(),
      );

  _createNew(BuildContext context) => replaceScreen(
        context,
        const GameNewScreen(),
      );

  _openGame(BuildContext context, Game game) => replaceScreen(
        context,
        GameScreen(uid: game.uid),
      );

  _showGameDialog(BuildContext context, Game game) async {
    final delete = await showGameDialogConfirmation(
      context,
      title: "Delete game",
      message: "Are you sure?",
      yesButton: "Delete",
      noButton: "Cancel",
    );
    if (!mounted) return;
    if (delete) {
      setState(() => _loading = true);
      await _gameService.delete(game.uid);
      await _refresh();
    }
  }
}
