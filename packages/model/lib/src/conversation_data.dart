import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';

part 'conversation_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ConversationData {
  final ConversationSpeaker speaker;
  final List<String> messages;

  ConversationData({
    required this.speaker,
    required this.messages,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) => _$ConversationDataFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationDataToJson(this);
}
