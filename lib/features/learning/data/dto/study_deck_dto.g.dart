// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_deck_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyCardDto _$StudyCardDtoFromJson(Map<String, dynamic> json) => StudyCardDto(
  id: json['id'] as String,
  title: json['title'] as String,
  answer: json['answer'] as String,
  answerType: json['answerType'] as String?,
  hint: json['hint'] as String?,
  example: json['example'] as String?,
);

Map<String, dynamic> _$StudyCardDtoToJson(StudyCardDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'answer': instance.answer,
      'answerType': instance.answerType,
      'hint': instance.hint,
      'example': instance.example,
    };

StudyDeckDto _$StudyDeckDtoFromJson(Map<String, dynamic> json) => StudyDeckDto(
  id: json['id'] as String,
  name: json['name'] as String,
  cards: (json['cards'] as List<dynamic>)
      .map((e) => StudyCardDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StudyDeckDtoToJson(StudyDeckDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cards': instance.cards.map((e) => e.toJson()).toList(),
    };
