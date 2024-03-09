// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationData _$ConversationDataFromJson(Map<String, dynamic> json) =>
    ConversationData(
      speaker: $enumDecode(_$ConversationSpeakerEnumMap, json['speaker']),
      messages:
          (json['messages'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ConversationDataToJson(ConversationData instance) =>
    <String, dynamic>{
      'speaker': _$ConversationSpeakerEnumMap[instance.speaker]!,
      'messages': instance.messages,
    };

const _$ConversationSpeakerEnumMap = {
  ConversationSpeaker.captainDash: 'captainDash',
  ConversationSpeaker.shipBot: 'shipBot',
  ConversationSpeaker.planetPresident: 'planetPresident',
};
