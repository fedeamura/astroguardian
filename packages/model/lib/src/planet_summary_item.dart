import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';

part 'planet_summary_item.g.dart';

@JsonSerializable(explicitToJson: true)
class PlanetSummaryItem {
  final String uid;
  final PointDouble position;
  final double radius;
  final double satelliteMaxOrbitDistance;

  PlanetSummaryItem({
    required this.uid,
    required this.position,
    required this.radius,
    required this.satelliteMaxOrbitDistance,
  });

  factory PlanetSummaryItem.fromJson(Map<String, dynamic> json) => _$PlanetSummaryItemFromJson(json);

  Map<String, dynamic> toJson() => _$PlanetSummaryItemToJson(this);
}
