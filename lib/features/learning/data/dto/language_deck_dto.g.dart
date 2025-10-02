// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_deck_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageCardDto _$LanguageCardDtoFromJson(Map<String, dynamic> json) =>
    LanguageCardDto(
      id: json['id'] as String,
      title: json['title'] as String,
      translation: json['translation'] as String,
      transcription: json['transcription'] as String?,
      audioPath: json['audioPath'] as String?,
      description: json['description'] as String?,
      example: json['example'] as String?,
    );

Map<String, dynamic> _$LanguageCardDtoToJson(LanguageCardDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'translation': instance.translation,
      'transcription': instance.transcription,
      'audioPath': instance.audioPath,
      'description': instance.description,
      'example': instance.example,
    };

LanguageDeckDto _$LanguageDeckDtoFromJson(Map<String, dynamic> json) =>
    LanguageDeckDto(
      id: json['id'] as String,
      name: json['name'] as String,
      cards: (json['cards'] as List<dynamic>)
          .map((e) => LanguageCardDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LanguageDeckDtoToJson(LanguageDeckDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cards': instance.cards.map((e) => e.toJson()).toList(),
    };
