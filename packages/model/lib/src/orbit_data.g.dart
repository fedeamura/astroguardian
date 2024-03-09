// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orbit_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrbitData _$OrbitDataFromJson(Map<String, dynamic> json) => OrbitData(
      a: (json['a'] as num).toDouble(),
      b: (json['b'] as num).toDouble(),
      inclination: (json['inclination'] as num).toDouble(),
    );

Map<String, dynamic> _$OrbitDataToJson(OrbitData instance) => <String, dynamic>{
      'a': instance.a,
      'b': instance.b,
      'inclination': instance.inclination,
    };
