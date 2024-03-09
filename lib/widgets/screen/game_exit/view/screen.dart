import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:astro_guardian/widgets/screen/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:service/service.dart';

class GameExitScreen extends StatefulWidget {
  const GameExitScreen({super.key});

  @override
  State<GameExitScreen> createState() => _GameExitScreenState();
}

class _GameExitScreenState extends State<GameExitScreen> {
  GameService get _gameService => GetIt.I.get();

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _init());
  }

  _init() async {
    await _gameService.clearCurrentGame();
    if (!mounted) return;
    Navigator.of(context).screenReplace(const HomeScreen());
  }
}
