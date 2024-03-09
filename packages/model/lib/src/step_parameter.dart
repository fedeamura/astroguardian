import 'package:json_annotation/json_annotation.dart';
import 'package:util/util.dart';

part 'step_parameter.g.dart';

@JsonSerializable(explicitToJson: true)
class StepParameter {
  int _level;
  int _maxLevel;
  final double _minValue;
  final double _maxValue;

  StepParameter({
    required int level,
    required int maxLevel,
    required double minValue,
    required double maxValue,
  })  : _level = level,
        _maxLevel = maxLevel,
        _minValue = minValue,
        _maxValue = maxValue {
    _fix();
  }

  // Level
  int get level => _level;

  set level(int level) {
    _level = level;
    _fix();
  }

  // Max level
  int get maxLevel => _maxLevel;

  set maxLevel(int level) {
    _maxLevel = level;
    _fix();
  }

  double get value => MathRangeUtil.range(
        _level.toDouble(),
        0.0,
        _maxLevel.toDouble(),
        _minValue,
        _maxValue,
      );

  double get minValue => _minValue;

  double get maxValue => _maxValue;

  _fix() {
    _level = _level.clamp(0, _maxLevel);
  }

  factory StepParameter.fromJson(Map<String, dynamic> json) => _$StepParameterFromJson(json);

  Map<String, dynamic> toJson() => _$StepParameterToJson(this);
}
