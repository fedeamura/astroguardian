import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';

part 'chunk.g.dart';

@JsonSerializable(explicitToJson: true)
class Chunk {
  final PointInt position;

  final Planet? planet;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool dirty;

  Chunk({
    required this.position,
    this.planet,
    this.dirty = false,
  });

  factory Chunk.fromJson(Map<String, dynamic> json) => _$ChunkFromJson(json);

  Map<String, dynamic> toJson() => _$ChunkToJson(this);
}
