import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';
import 'package:model/src/converter/map_conversation.dart';

part 'game.g.dart';

@JsonSerializable(explicitToJson: true)
class Game {
  final String uid;
  final int chunkSize;
  final double tutorialDistance;
  final int seed;
  final Ship ship;
  final PointDouble initialPlanetGlobalPosition;
  final double planetProbability;
  final int initialPlanetSatelliteCount;
  final int planetSatelliteMaxCount;
  final double planetWithSatellitesProbability;

  final String initialPlanetUid;
  final double initialPlanetRadius;
  final double initialPlanetSatelliteMinDistance;
  final double initialPlanetSatelliteMaxDistance;

  PointDouble mapMarker;
  int mapMarkerColor;
  bool mapMarkerVisible;
  String mapMarkerTag;

  bool tutorial;

  @JsonKey(toJson: mapConversationToJson, fromJson: mapConversationFromJson)
  final Map<ConversationType, bool> conversations;

  final DateTime createdAt;
  DateTime lastAccessAt;

  int experience;
  int totalExperience;
  int abilityPoints;

  @JsonKey(includeToJson: false, includeFromJson: false)
  Array<Chunk> chunks;

  @JsonKey(includeToJson: false, includeFromJson: false)
  final List<PointInt> currentChunksList;

  @JsonKey(includeToJson: false, includeFromJson: false)
  final Array<bool> currentChunksArray;

  Game({
    required this.uid,
    required this.chunkSize,
    required this.tutorialDistance,
    required this.seed,
    required this.ship,
    required this.createdAt,
    required this.lastAccessAt,
    required this.experience,
    required this.totalExperience,
    required this.abilityPoints,
    required this.planetProbability,
    required this.initialPlanetUid,
    required this.initialPlanetGlobalPosition,
    required this.initialPlanetSatelliteCount,
    required this.initialPlanetRadius,
    required this.initialPlanetSatelliteMinDistance,
    required this.initialPlanetSatelliteMaxDistance,
    required this.planetSatelliteMaxCount,
    required this.planetWithSatellitesProbability,
    required this.tutorial,
    required this.conversations,
    required this.mapMarker,
    required this.mapMarkerColor,
    required this.mapMarkerVisible,
    required this.mapMarkerTag,
  })  : chunks = Array(),
        currentChunksList = [],
        currentChunksArray = Array();

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Game generateCopy() => Game(
        uid: uid,
        seed: seed,
        chunkSize: chunkSize,
        ship: ship,
        createdAt: createdAt,
        experience: experience,
        totalExperience: totalExperience,
        abilityPoints: abilityPoints,
        lastAccessAt: lastAccessAt,
        planetProbability: planetProbability,
        tutorialDistance: tutorialDistance,
        initialPlanetUid: initialPlanetUid,
        initialPlanetSatelliteCount: initialPlanetSatelliteCount,
        initialPlanetGlobalPosition: initialPlanetGlobalPosition,
        initialPlanetRadius: initialPlanetRadius,
        initialPlanetSatelliteMinDistance: initialPlanetSatelliteMinDistance,
        initialPlanetSatelliteMaxDistance: initialPlanetSatelliteMaxDistance,
        planetSatelliteMaxCount: planetSatelliteMaxCount,
        planetWithSatellitesProbability: planetWithSatellitesProbability,
        conversations: conversations,
        tutorial: tutorial,
        mapMarker: mapMarker,
        mapMarkerColor: mapMarkerColor,
        mapMarkerVisible: mapMarkerVisible,
        mapMarkerTag: mapMarkerTag,
      );

  Map<String, dynamic> toJson() => _$GameToJson(this);

  double get experiencePercentage => (experience / totalExperience).clamp(0.0, 1.0);

  bool shouldShowConversation(ConversationType conversationType) {
    if (!tutorial) return false;
    if (!conversationType.once) return true;
    return conversations[conversationType] != true;
  }
}
