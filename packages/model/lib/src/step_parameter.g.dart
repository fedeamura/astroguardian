// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepParameter _$StepParameterFromJson(Map<String, dynamic> json) =>
    StepParameter(
      level: json['level'] as int,
      maxLevel: json['maxLevel'] as int,
      minValue: (json['minValue'] as num).toDouble(),
      maxValue: (json['maxValue'] as num).toDouble(),
    );

Map<String, dynamic> _$StepParameterToJson(StepParameter instance) =>
    <String, dynamic>{
      'level': instance.level,
      'maxLevel': instance.maxLevel,
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
    };
