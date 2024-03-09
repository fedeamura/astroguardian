import 'package:astro_guardian/widgets/extensions/navigator.dart';
import 'package:astro_guardian/widgets/screen/game/view/screen.dart';
import 'package:astro_guardian/widgets/screen/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:service/service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
    if (_gameService.currentGameUid.trim().isNotEmpty) {
      Navigator.of(context).screenReplace(GameScreen(uid: _gameService.currentGameUid));
    } else {
      Navigator.of(context).screenReplace(const HomeScreen());
    }
  }
}
