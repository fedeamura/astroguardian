import 'package:astro_guardian/widgets/common/shader_crt/shader_crt.dart';
import 'package:astro_guardian/widgets/screen/splash/splash.dart';
import 'package:device_sim/device_sim.dart';
import 'package:flutter/material.dart';
import 'package:util/util.dart';

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DeviceSim(
      isEnabled: false,
      devices: const [
        iphoneSeGen3,
        iphone13Mini,
        iphone13,
        iphone13Pro,
        iphone13ProMax,
      ],
      builder: (context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Astro Guardian',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            brightness: Brightness.dark,
          ),
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        // home: const TestSatelliteScreen(),
        builder: (context, child) => CustomShaderCRT(
          enabled: GameConstants.crtEnabled,
          child: child!,
        ),
      ),
    );
  }
}

Future<T?> openScreen<T>(
  BuildContext context,
  Widget child, {
  bool opaque = true,
}) {
  return Navigator.of(context).push<T>(
    PageRouteBuilder(
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      opaque: opaque,
    ),
  );
}

void replaceScreen(BuildContext context, Widget child) {
  Navigator.of(context).pushAndRemoveUntil(
    PageRouteBuilder(
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) => child,
    ),
    (route) => false,
  );
}
