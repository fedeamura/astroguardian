import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game_hud/game_hud.dart';
import 'package:astro_guardian/widgets/common/shader_noise/shader_noise.dart';
import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/conversation/conversation.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/menu/index.dart';
import 'package:astro_guardian/widgets/screen/game/dialog/ship/ship.dart';
import 'package:astro_guardian/widgets/screen/game_exit/game_exit.dart';
import 'package:astro_guardian/widgets/screen/game_new/game_new.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:service/service.dart';
import 'package:util/util.dart';

class GameScreen extends StatefulWidget {
  final String uid;

  const GameScreen({super.key, required this.uid});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameService get _gameService => GetIt.I.get();
  final ValueNotifier<GameComponent?> _gameComponent = ValueNotifier(null);
  final ValueNotifier<GameHudComponent?> _gameHudComponent = ValueNotifier(null);
  final ValueNotifier<double> _noise = ValueNotifier(0.0);
  final ValueNotifier<bool> _visible = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomShaderNoise(
                enabled: GameConstants.noiseEnabled,
                percentage: _noise,
                child: ValueListenableBuilder(
                  valueListenable: _gameComponent,
                  builder: (context, value, child) {
                    final game = _gameComponent.value;
                    if (game == null) return Container();
                    return GameWidget(game: game);
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: ValueListenableBuilder(
                valueListenable: _gameHudComponent,
                builder: (context, value, child) {
                  final game = _gameHudComponent.value;
                  if (game == null) return Container();
                  return GameWidget(game: game);
                },
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: ValueListenableBuilder(
                  valueListenable: _visible,
                  builder: (context, value, child) => AnimatedOpacity(
                    opacity: _visible.value ? 0.0 : 1.0,
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    child: child,
                  ),
                  child: Container(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _init());
  }

  @override
  void dispose() {
    _gameComponent.value?.removeFromParent();
    _gameHudComponent.value?.removeFromParent();
    super.dispose();
  }

  _init() async {
    final GameService gameService = GetIt.I.get();

    final game = await gameService.getByUid(widget.uid);
    if (game == null) {
      _exitGame();
      return;
    }

    await gameService.openGame(game);

    _gameComponent.value = GameComponent(
      game: game,
      paddingProvider: () => MediaQuery.of(context).padding,
      createNewGame: _createNewGame,
      recreate: _recreate,
      noiseChanged: (noise) => _noise.value = noise,
      onMounted: () => _loadHud(),
      openShip: () async {
        final gameComponent = _gameComponent.value;
        if (gameComponent == null) return;
        await showGameDialogShip(
          context,
          game: gameComponent,
        );
      },
      showConversation: (type) async {
        final gameComponent = _gameComponent.value;
        if (gameComponent == null) return;
        await showGameConversation(
          context,
          game: gameComponent,
          type: type,
        );
      },
      show: () => _visible.value = true,
    );
  }

  _loadHud() {
    final gameComponent = _gameComponent.value;
    if (gameComponent == null) return;

    _gameHudComponent.value = GameHudComponent(
      gameComponent: gameComponent,
      createNewGame: _createNewGame,
      recreate: _recreate,
      menuCallback: () async {
        final component = _gameComponent.value;
        if (component == null) return;
        await showGameDialogMenu(
          context,
          game: component,
        );
      },
    );
  }

  _createNewGame() => Navigator.of(context).screenReplace(const GameNewScreen(deleteAll: true));

  _recreate() => Navigator.of(context).screenReplace(GameScreen(uid: _gameService.currentGameUid));

  _exitGame() => Navigator.of(context).screenReplace(const GameExitScreen());
}
