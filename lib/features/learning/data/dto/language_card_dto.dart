import 'package:flashcards_v2/features/learning/domain/entities/card_category.dart';
import 'package:flashcards_v2/features/learning/domain/entities/flashcard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'language_card_dto.g.dart';

@JsonSerializable()
class LanguageCardDto {
  LanguageCardDto({
    required this.id,
    required this.title,
    required this.translation,
    this.transcription,
    this.audioPath,
    this.description,
    this.example,
  });

  final String id;
  final String title;
  final String translation;
  final String? transcription;
  final String? audioPath;
  final String? description;
  final String? example;

  factory LanguageCardDto.fromJson(Map<String, dynamic> json) =>
      _$LanguageCardDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageCardDtoToJson(this);

  LanguageCardEntity toEntity() => LanguageCardEntity(
    id: id,
    title: title,
    category: CardCategory.newWords,
    translation: translation,
    transcription: transcription,
    audioPath: audioPath,
    description: description,
    example: example,
  );

  static String slug(String title) =>
      'l_${title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'_+'), '_').replaceAll(RegExp(r'^_+|_+$'), '')}';
}

@JsonSerializable(explicitToJson: true)
class LanguageDeckDto {
  LanguageDeckDto({required this.id, required this.name, required this.cards});

  final String id;
  final String name;
  final List<LanguageCardDto> cards;

  factory LanguageDeckDto.fromJson(Map<String, dynamic> json) {
    final dto = _$LanguageDeckDtoFromJson(json);
    final fixed = dto.cards
        .map(
          (c) => c.id.isEmpty
              ? LanguageCardDto(
                  id: LanguageCardDto.slug(c.title),
                  title: c.title,
                  translation: c.translation,
                  transcription: c.transcription,
                  audioPath: c.audioPath,
                  description: c.description,
                  example: c.example,
                )
              : c,
        )
        .toList(growable: false);
    return LanguageDeckDto(id: dto.id, name: dto.name, cards: fixed);
  }

  Map<String, dynamic> toJson() => _$LanguageDeckDtoToJson(this);
}
