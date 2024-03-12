import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:astro_guardian/game/planet_satellite/planet_satellite.dart';
import 'package:astro_guardian/game/ship/experience_particle.dart';
import 'package:astro_guardian/game/util/extension/point.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:model/model.dart';
import 'package:service/service.dart';
import 'package:util/util.dart';

import 'background/background.dart';
import 'util/images.dart';
import 'world.dart';

class GameComponent extends Forge2DGame<GameWorld> {
  final Game game;
  final EdgeInsets Function() paddingProvider;
  final Function()? createNewGame;
  final Function()? recreate;
  final Function()? gameLost;
  final Function()? mapDebug;
  final Function(double noise)? noiseChanged;
  final Function()? onMounted;
  final Function()? show;
  final Function()? openShip;
  final Future<void> Function(ConversationType type)? showConversation;

  GameComponent({
    required this.game,
    required this.paddingProvider,
    this.createNewGame,
    this.recreate,
    this.gameLost,
    this.mapDebug,
    this.noiseChanged,
    this.onMounted,
    this.openShip,
    this.showConversation,
    this.show,
  }) : super(world: GameWorld());

  double _generateMapUpdate = 0.1;
  bool _isInit = false;

  GameService get gameService => GetIt.I.get();

  bool _keyMovePressed = false;
  bool _keyLeftPressed = false;
  bool _keyRightPressed = false;
  bool _keyConsumePressed = false;
  bool _keyStopPressed = false;

  bool get keyMovePressed => !_keyStopPressed && _keyMovePressed && !animatingCamera;

  set keyMovePressed(bool value) => _keyMovePressed = value;

  bool get keyLeftPressed => !_keyStopPressed && _keyLeftPressed && !animatingCamera;

  set keyLeftPressed(bool value) => _keyLeftPressed = value;

  bool get keyRightPressed => !_keyStopPressed && _keyRightPressed && !animatingCamera;

  set keyRightPressed(bool value) => _keyRightPressed = value;

  bool get keyStopPressed => _keyStopPressed && !animatingCamera;

  set keyStopPressed(bool value) => _keyStopPressed = value;

  bool get keyConsumePressed => _keyConsumePressed && !animatingCamera;

  set keyConsumePressed(bool value) {
    if (_keyConsumePressed == value) return;

    if (value) {
      if (game.ship.bagPercentage == 1.0) {
        _keyConsumePressed = false;
        return;
      }
    }

    _keyConsumePressed = value;
  }

  bool animatingCamera = false;

  @override
  FutureOr<void> onLoad() async {
    for (var element in GameImages.values) {
      await images.load(element.path);
    }

    camera.viewfinder.visibleGameSize = Vector2.all(GameConstants.chunkSize * 0.25);
    await camera.backdrop.add(BackgroundComponent());
    return super.onLoad();
  }

  _init() {
    camera.follow(world.shipComponent);
    onMounted?.call();
  }

  void init() {
    final vf = camera.viewfinder;
    final initialZoom = vf.zoom;
    show?.call();

    vf.add(
      ScaleEffect.to(
        Vector2.all(initialZoom * 10),
        EffectController(duration: 0.1),
        onComplete: () {
          vf.add(
            ScaleEffect.to(
              Vector2.all(initialZoom),
              EffectController(
                duration: 2.0,
                curve: Curves.easeInOut,
              ),
              onComplete: () {
                showConversation?.call(ConversationType.tutorialInit);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _calculateMounted();
    _generateMap(dt);
    _updateTutorial();
  }

  _calculateMounted() {
    if (!world.isMounted) return;
    if (_isInit) return;
    _isInit = true;
    _init();
  }

  _updateTutorial() {
    if (!game.tutorial) return;

    final ability = game.ship.abilities.entries.any((e) => e.value.level > 0);

    if (ability) {
      showConversation?.call(ConversationType.tutorialImproveShip);
    }
  }

  _generateMap(double dt) {
    _generateMapUpdate += dt;
    if (_generateMapUpdate < GameConstants.generateMapDelay) return;
    _generateMapUpdate = 0;

    final shipPos = world.shipComponent.position;
    gameService.moveShip(
      game,
      PointDouble(shipPos.x, shipPos.y),
    );
  }

  void onShipPressed() {
    _keyConsumePressed = !keyConsumePressed;
  }

  void onShipLongPressedStart() {
    _keyStopPressed = true;
  }

  void onShipLongPressedEnd() {
    _keyStopPressed = false;
  }

  Future<void> save() async {
    if (!isMounted) {
      return;
    }

    game.ship.position.x = world.shipComponent.position.x;
    game.ship.position.y = world.shipComponent.position.y;
    game.ship.rotation = world.shipComponent.angle;

    try {
      await gameService.save(game);
    } catch (e) {
      log("Error saving");
      rethrow;
    }
  }

  focusPlanet(Planet planet) {
    if (animatingCamera) return;
    animatingCamera = true;

    var experience = (planet.satellitesCount * 0.1).floor();
    experience += planet.satellites.length;

    planet.satellites.clear();
    planet.recalculateSatelliteMaxOrbitDistance();
    gameService.onPlanetVisible(game: game, planet: planet);
    save();

    final satellites = world.physicsWorld.bodies
        .where((e) => e.userData != null)
        .map((e) => e.userData!)
        .whereType<PlanetSatelliteComponent>()
        .where((e) => e.planet.uid == planet.uid)
        .toList();
    for (var element in satellites) {
      element.removeFromParent();
    }

    camera.stop();

    world.shipComponent.body.linearVelocity = Vector2.zero();
    world.shipComponent.body.angularVelocity = 0.0;
    _keyConsumePressed = false;
    _keyLeftPressed = false;
    _keyMovePressed = false;
    _keyRightPressed = false;
    _keyStopPressed = false;

    final planetPosition = planet.globalPosition.vector2;
    final shipPosition = world.shipComponent.position;

    final vf = camera.viewfinder;

    final currentZoom = vf.zoom;
    final screen = math.min(camera.viewport.size.x, camera.viewport.size.y);
    final finalZoom = screen / (((planet.radius * 2) + (screen * 0.05)));
    const idleTime = 2.0;

    final zoomInController = EffectController(duration: 2.0);
    vf.add(ScaleEffect.to(Vector2.all(finalZoom), zoomInController));
    vf.add(
      MoveToEffect(
        planetPosition,
        zoomInController,
        onComplete: () async {
          await showConversation?.call(ConversationType.tutorialPlanetCompleted);

          vf.add(
            TimerComponent(
              period: idleTime,
              autoStart: true,
              removeOnFinish: true,
              onTick: () {
                final zoomOutController = EffectController(duration: 2.0);
                vf.add(ScaleEffect.to(Vector2.all(currentZoom), zoomOutController));
                vf.add(
                  MoveToEffect(
                    world.shipComponent.position,
                    zoomOutController,
                    onComplete: () {
                      animatingCamera = false;
                      camera.stop();
                      camera.follow(world.shipComponent);

                      // Add particles
                      if (experience > 0) {
                        for (int i = 0; i < experience; i++) {
                          final angle = _rnd.nextDouble() * 2 * math.pi;
                          final d = _rnd.nextDoubleInRange(2.0, 3.0);
                          final delay = _rnd.nextDoubleInRange(0, 1.0);
                          final x = shipPosition.x + d * math.cos(angle);
                          final y = shipPosition.y + d * math.sin(angle);

                          add(
                            TimerComponent(
                              period: delay,
                              autoStart: true,
                              removeOnFinish: true,
                              onTick: () {
                                final c = ExperienceParticleComponent(
                                  startPosition: Vector2(x, y),
                                );
                                world.shipExperienceLayer.add(c);
                              },
                            ),
                          );
                        }
                      }

                      // End tutorial
                      add(
                        TimerComponent(
                          period: 5.0,
                          autoStart: true,
                          removeOnFinish: true,
                          onTick: () {
                            showConversation?.call(ConversationType.tutorialStartAdventure);
                            game.mapMarkerVisible = false;
                            game.tutorial = false;
                            save();
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  final _rnd = RandomUtil();

  consumeNearestPlanet() {
    final shipPosition = world.shipComponent.position;
    final planets = game.chunks.entries.where((e) => e.value.planet != null).map((e) => e.value.planet!).toList();
    if (planets.isEmpty) {
      log("No planets nearby");
      return;
    }

    planets.sort((a, b) {
      final p1 = a.globalPosition.vector2.distanceTo(shipPosition);
      final p2 = b.globalPosition.vector2.distanceTo(shipPosition);
      return p1.compareTo(p2);
    });

    final planet = planets.first;
    log("Planet ${planet.uid}");
    focusPlanet(planet);
  }


  clearMovement(){
    keyLeftPressed = false;
    keyMovePressed = false;
    keyRightPressed = false;
    keyStopPressed = false;
    world.shipComponent.body.linearVelocity.x = 0;
    world.shipComponent.body.linearVelocity.y = 0;
    world.shipComponent.body.angularVelocity = 0;
  }

  double get gameScale => math.max(size.x, size.y) * 0.005;
}
