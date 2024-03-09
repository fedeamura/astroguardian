import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';

part 'planet_info.g.dart';

@JsonSerializable(explicitToJson: true)
class PlanetInfo extends Equatable {
  final String uid;
  final PointDouble position;
  final double radius;
  final double percentage;
  final double spinSpeed;
  final int createdAt;
  final int updatedAt;

  const PlanetInfo({
    required this.uid,
    required this.position,
    required this.radius,
    required this.percentage,
    required this.spinSpeed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlanetInfo.fromJson(Map<String, dynamic> json) => _$PlanetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PlanetInfoToJson(this);

  @override
  List<Object?> get props => [
        uid,
        position,
        radius,
        percentage,
        spinSpeed,
        createdAt,
        updatedAt,
      ];
}
