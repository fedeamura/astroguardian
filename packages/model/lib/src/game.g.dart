// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      uid: json['uid'] as String,
      chunkSize: json['chunkSize'] as int,
      tutorialDistance: (json['tutorialDistance'] as num).toDouble(),
      seed: json['seed'] as int,
      ship: Ship.fromJson(json['ship'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastAccessAt: DateTime.parse(json['lastAccessAt'] as String),
      experience: json['experience'] as int,
      totalExperience: json['totalExperience'] as int,
      abilityPoints: json['abilityPoints'] as int,
      planetProbability: (json['planetProbability'] as num).toDouble(),
      initialPlanetUid: json['initialPlanetUid'] as String,
      initialPlanetGlobalPosition: PointDouble.fromJson(
          json['initialPlanetGlobalPosition'] as Map<String, dynamic>),
      initialPlanetSatelliteCount: json['initialPlanetSatelliteCount'] as int,
      initialPlanetRadius: (json['initialPlanetRadius'] as num).toDouble(),
      initialPlanetSatelliteMinDistance:
          (json['initialPlanetSatelliteMinDistance'] as num).toDouble(),
      initialPlanetSatelliteMaxDistance:
          (json['initialPlanetSatelliteMaxDistance'] as num).toDouble(),
      planetSatelliteMaxCount: json['planetSatelliteMaxCount'] as int,
      planetWithSatellitesProbability:
          (json['planetWithSatellitesProbability'] as num).toDouble(),
      tutorial: json['tutorial'] as bool,
      conversations: mapConversationFromJson(json['conversations'] as String),
      mapMarker:
          PointDouble.fromJson(json['mapMarker'] as Map<String, dynamic>),
      mapMarkerColor: json['mapMarkerColor'] as int,
      mapMarkerVisible: json['mapMarkerVisible'] as bool,
      mapMarkerTag: json['mapMarkerTag'] as String,
    );

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'uid': instance.uid,
      'chunkSize': instance.chunkSize,
      'tutorialDistance': instance.tutorialDistance,
      'seed': instance.seed,
      'ship': instance.ship.toJson(),
      'initialPlanetGlobalPosition':
          instance.initialPlanetGlobalPosition.toJson(),
      'planetProbability': instance.planetProbability,
      'initialPlanetSatelliteCount': instance.initialPlanetSatelliteCount,
      'planetSatelliteMaxCount': instance.planetSatelliteMaxCount,
      'planetWithSatellitesProbability':
          instance.planetWithSatellitesProbability,
      'initialPlanetUid': instance.initialPlanetUid,
      'initialPlanetRadius': instance.initialPlanetRadius,
      'initialPlanetSatelliteMinDistance':
          instance.initialPlanetSatelliteMinDistance,
      'initialPlanetSatelliteMaxDistance':
          instance.initialPlanetSatelliteMaxDistance,
      'mapMarker': instance.mapMarker.toJson(),
      'mapMarkerColor': instance.mapMarkerColor,
      'mapMarkerVisible': instance.mapMarkerVisible,
      'mapMarkerTag': instance.mapMarkerTag,
      'tutorial': instance.tutorial,
      'conversations': mapConversationToJson(instance.conversations),
      'createdAt': instance.createdAt.toIso8601String(),
      'lastAccessAt': instance.lastAccessAt.toIso8601String(),
      'experience': instance.experience,
      'totalExperience': instance.totalExperience,
      'abilityPoints': instance.abilityPoints,
    };
