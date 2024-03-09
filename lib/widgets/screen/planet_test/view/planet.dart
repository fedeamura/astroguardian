import 'dart:ui' as ui;

import 'package:astro_guardian/game/util/extension/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:model/model.dart';

class PlanetTerrainItem extends StatefulWidget {
  final PlanetTerrain terrain;

  const PlanetTerrainItem({
    super.key,
    required this.terrain,
  });

  @override
  State<PlanetTerrainItem> createState() => _PlanetTerrainItemState();
}

class _PlanetTerrainItemState extends State<PlanetTerrainItem> with SingleTickerProviderStateMixin {
  late ui.Image _terrain1;
  late ui.Image _terrain2;
  late ui.Image _atmosphere1;
  late ui.Image _atmosphere2;

  double _angleTerrain = 0.0;
  double _angleAtmosphere = 0.0;

  bool _toggleTerrain = true;
  bool _toggleAtmosphere = true;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Stack(
        children: [
          FractionalTranslation(
            translation: Offset((_angleTerrain % 360) / 360, 0.0),
            child: Stack(
              children: [
                Positioned(
                  child: FractionalTranslation(
                    translation: Offset(_toggleTerrain ? 0.0 : -1.0, 0.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: RawImage(
                        image: _terrain1,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: FractionalTranslation(
                    translation: Offset(_toggleTerrain ? -1.0 : 0.0, 0.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: RawImage(
                        image: _terrain2,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          FractionalTranslation(
            translation: Offset((_angleAtmosphere % 360) / 360, 0.0),
            child: Stack(
              children: [
                Positioned(
                  child: FractionalTranslation(
                    translation: Offset(_toggleAtmosphere ? 0.0 : -1.0, 0.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: RawImage(
                        image: _atmosphere1,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: FractionalTranslation(
                    translation: Offset(_toggleAtmosphere ? -1.0 : 0.0, 0.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: RawImage(
                        image: _atmosphere2,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.9),
                  ],
                )
              ),
            ),
          ),
          Text(_angleTerrain.toString()),
        ],
      ),
    );

    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: RawImage(
              image: _terrain1,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: RawImage(
              image: _terrain2,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: RawImage(
              image: _terrain1,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _terrain1 = _createTerrainImage(first: true);
    _terrain2 = _createTerrainImage(first: false);
    _atmosphere1 = _createAtmosphereImage(first: true);
    _atmosphere2 = _createAtmosphereImage(first: false);
    _ticker = createTicker((Duration elapsed) => _tick());
    _ticker.start();
  }

  _tick() {
    _angleTerrain -= 1.0;
    _angleTerrain = (_angleTerrain % 360);
    if (_angleTerrain == 360 || _angleTerrain == 0) {
      _toggleTerrain = !_toggleTerrain;
    }

    _angleAtmosphere -= 0.8;
    _angleAtmosphere = (_angleAtmosphere % 360);
    if (_angleAtmosphere == 360 || _angleAtmosphere == 0) {
      _toggleAtmosphere = !_toggleAtmosphere;
    }

    setState(() {});
  }

  _createTerrainImage({first = true}) {
    final resolution = widget.terrain.resolution;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawColor(Colors.white, ui.BlendMode.src);

    final colors = widget.terrain.colors;

    for (int j = 0; j < resolution.floor() * 2; j++) {
      for (int i = 0; i < resolution.floor() * 2; i++) {
        final elevation = widget.terrain.terrain.getByIndex(i + (first ? 0 : (resolution.floor() * 2)), j);
        final colorIndex = ((elevation ?? 0) * colors.length).floor();

        canvas.drawRect(
          Rect.fromLTWH(
            i.toDouble(),
            j.toDouble(),
            1.0,
            1.0,
          ),
          Paint()..color = colors[colorIndex].color,
        );
      }
    }

    final picture = recorder.endRecording();
    return picture.toImageSync(resolution.floor() * 2, resolution.floor() * 2);
  }

  _createAtmosphereImage({first = true}) {
    final resolution = widget.terrain.resolution;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    for (int j = 0; j < resolution.floor() * 2; j++) {
      for (int i = 0; i < resolution.floor() * 2; i++) {
        final elevation = widget.terrain.atmosphere.getByIndex(i + (first ? 0 : (resolution.floor() * 2)), j) ?? 0.0;

        if (elevation > 0.6) {
          canvas.drawRect(
            Rect.fromLTWH(
              i.toDouble(),
              j.toDouble(),
              1.0,
              1.0,
            ),
            Paint()..color = Colors.white.withOpacity(0.6),
          );
        }
      }
    }

    final picture = recorder.endRecording();
    return picture.toImageSync(resolution.floor() * 2, resolution.floor() * 2);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
