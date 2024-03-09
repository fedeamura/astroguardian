import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:astro_guardian/widgets/screen/game/view/screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:service/service.dart';

class GameNewScreen extends StatefulWidget {
  final bool deleteAll;

  const GameNewScreen({
    super.key,
    this.deleteAll = false,
  });

  @override
  State<GameNewScreen> createState() => _GameNewScreenState();
}

class _GameNewScreenState extends State<GameNewScreen> {
  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _create());
  }

  _create() async {
    final GameService service = GetIt.I.get();

    if (widget.deleteAll) {
      await service.deleteAll();
    }

    final game = await service.createGame();
    if (!mounted) return;

    Navigator.of(context).screenReplace(GameScreen(uid: game.uid));
  }
}
