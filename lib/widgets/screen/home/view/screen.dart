import 'package:astro_guardian/widgets/common/game_button/game_button.dart';
import 'package:astro_guardian/widgets/common/game_title/game_title.dart';
import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:astro_guardian/widgets/screen/game/view/screen.dart';
import 'package:astro_guardian/widgets/screen/game_list/game_list.dart';
import 'package:astro_guardian/widgets/screen/game_new/game_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:model/model.dart';
import 'package:service/service.dart';

class HomeScreen extends StatefulHookWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GameService get _gameService => GetIt.I.get();

  bool _loading = true;
  var _games = <Game>[];

  @override
  Widget build(BuildContext context) {
    final p = MediaQuery.paddingOf(context);
    Game? lastGame;
    if (_games.isNotEmpty) {
      lastGame = _games.first;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: _loading
          ? Container()
          : Column(
              children: [
                SizedBox(height: p.top),
                const GameTitle(
                  title: "ASTRO GUARDIAN",
                  textAlign: TextAlign.center,
                  alignment: Alignment.center,
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_games.isEmpty)
                            GameButton(
                              width: 250.0,
                              margin: const EdgeInsets.only(bottom: 16.0),
                              text: "START",
                              onPressed: () => Navigator.of(context).screenReplace(const GameNewScreen()),
                            ),
                          if (_games.isNotEmpty && lastGame != null)
                            GameButton(
                              width: 250.0,
                              margin: const EdgeInsets.only(bottom: 16.0),
                              text: "RESUME",
                              onPressed: () => Navigator.of(context).screenReplace(GameScreen(uid: lastGame?.uid ?? "")),
                            ),
                          if (_games.isNotEmpty)
                            GameButton(
                              width: 250.0,
                              margin: const EdgeInsets.only(bottom: 16.0),
                              text: "GAMES",
                              onPressed: _openGameList,
                            ),
                        ],
                      ),
                    ),
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

  _openGameList() async {
    await Navigator.of(context).openDialog(
      (animation) => GameListScreenContent(
        animation: animation,
      ),
    );
    if (!mounted) return;
    _refresh();
  }
}
