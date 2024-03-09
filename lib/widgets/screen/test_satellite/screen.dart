import 'dart:ui' as ui;

import 'package:astro_guardian/game/util/painter/image.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:usecase/usecase.dart';

class TestSatelliteScreen extends StatefulWidget {
  const TestSatelliteScreen({super.key});

  @override
  State<TestSatelliteScreen> createState() => _TestSatelliteScreenState();
}

class _TestSatelliteScreenState extends State<TestSatelliteScreen> {
  final _useCase = GeneratePlanetSatelliteTerrainUseCase();
  ui.Image? _image;
  ui.Image? _borderImage;

  PlanetSatelliteTerrain? _planetSatelliteTerrain;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _init,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            if (_image != null)
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  color: Colors.white,
                  child: RawImage(
                    image: _image!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    filterQuality: ui.FilterQuality.none,
                  ),
                ),
              ),
            if (_borderImage != null)
              AspectRatio(
                aspectRatio: 1.0,
                child: RawImage(
                  image: _borderImage!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  filterQuality: ui.FilterQuality.none,
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
    _init();
  }

  _init() {
    final terrain = _useCase();
    _planetSatelliteTerrain = terrain;
    _image = _createImage(terrain);
    _borderImage = _createBorderImage(terrain);
    setState(() {});
  }

  ui.Image _createImage(PlanetSatelliteTerrain terrain) => ImagePainterUtil.drawPixels(
        w: terrain.resolution,
        h: terrain.resolution,
        paint: Paint()..color = Color(terrain.color),
        points: terrain.terrain.entries
            .where((e) => e.value == true)
            .map(
              (e) => CanvasPixelModel(
                x: e.position.x,
                y: e.position.y,
              ),
            )
            .toList(),
      );

  ui.Image _createBorderImage(PlanetSatelliteTerrain terrain) {
    final result = <CanvasPixelModel>[];
    for (var element in terrain.border.entries.where((e) => e.value == true)) {
      result.add(
        CanvasPixelModel(
          x: element.position.x,
          y: element.position.y,
        ),
      );
    }

    return ImagePainterUtil.drawPixels(
      w: terrain.resolution,
      h: terrain.resolution,
      paint: Paint()..color = Colors.white.withOpacity(0.4),
      points: result,
    );
  }
}
