import 'package:astro_guardian/widgets/screen/planet_test/view/planet.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:usecase/usecase.dart';

class PlanetTestScreen extends StatefulWidget {
  const PlanetTestScreen({super.key});

  @override
  State<PlanetTestScreen> createState() => _PlanetTestScreenState();
}

class _PlanetTestScreenState extends State<PlanetTestScreen> {
  var _data = <PlanetTerrain>[];
  final _generatePlanetTerrainUseCase = GeneratePlanetTerrainUseCase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planet test"),
        actions: [
          IconButton(
            onPressed: _recreate,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: _data.length,
        itemBuilder: (context, index) => PlanetTerrainItem(
          terrain: _data[index],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _recreate());
  }

  _recreate() {
    setState(
      () => _data = [],
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      const count = 10;
      final data = <PlanetTerrain>[];
      for (int i = 0; i < count; i++) {
        final terrain = _generatePlanetTerrainUseCase();
        data.add(terrain);
      }

      setState(() => _data = data);
    });
  }
}
