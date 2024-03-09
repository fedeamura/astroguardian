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
import 'package:util/util.dart';
import 'package:service/service.dart';

class GameScreen extends StatefulWidget {
  final String uid;

  const GameScreen({super.key, required this.uid});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameService get _gameService => GetIt.I.get();

  GameComponent? _gameComponent;
  GameHudComponent? _gameHudComponent;

  final ValueNotifier<double> _noise = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            if (_gameComponent != null)
              Positioned.fill(
                child: CustomShaderNoise(
                  enabled: GameConstants.noiseEnabled,
                  percentage: _noise,
                  child: GameWidget(
                    game: _gameComponent!,
                  ),
                ),
              ),
            if (_gameHudComponent != null)
              Positioned.fill(
                child: GameWidget(
                  game: _gameHudComponent!,
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
    _gameComponent?.removeFromParent();
    _gameHudComponent?.removeFromParent();
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

    final gameComponent = GameComponent(
      game: game,
      paddingProvider: () => MediaQuery.of(context).padding,
      createNewGame: _createNewGame,
      recreate: _recreate,
      noiseChanged: (noise) => _noise.value = noise,
      onReady: () => _loadHud(),
      openShip: () => showGameDialogShip(
        context,
        game: _gameComponent!,
      ),
      showConversation: (type) => showGameConversation(
        context,
        game: _gameComponent!,
        type: type,
      ),
    );

    setState(() => _gameComponent = gameComponent);
  }

  _loadHud() {
    if (_gameComponent == null) return;

    final gameHudComponent = GameHudComponent(
      gameComponent: _gameComponent!,
      createNewGame: _createNewGame,
      recreate: _recreate,
      menuCallback: () => showGameDialogMenu(
        context,
        game: _gameComponent!,
      ),
    );

    setState(() => _gameHudComponent = gameHudComponent);
  }

  _createNewGame() => Navigator.of(context).screenReplace(const GameNewScreen(deleteAll: true));

  _recreate() => Navigator.of(context).screenReplace(GameScreen(uid: _gameService.currentGameUid));

  _exitGame() => Navigator.of(context).screenReplace(const GameExitScreen());
}
