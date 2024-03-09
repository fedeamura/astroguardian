import 'package:astro_guardian/dependency_container.dart';
import 'package:flutter/material.dart';

import 'widgets/app.dart';

void main() async {
  runApp(Container(color: Colors.black));
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyContainer.init();
  runApp(const GameApp());
}
