import 'package:flashcards_v2/features/learning/domain/entities/card_category.dart';
import 'package:flashcards_v2/features/learning/domain/entities/flashcard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'study_deck_dto.g.dart';

@JsonSerializable()
class StudyCardDto {
  StudyCardDto({
    required this.id,
    required this.title,
    required this.answer,
    this.answerType,
    this.hint,
    this.example,
  });

  final String id;
  final String title;
  final String answer;
  final String? answerType;
  final String? hint;
  final String? example;

  factory StudyCardDto.fromJson(Map<String, dynamic> json) =>
      _$StudyCardDtoFromJson(json);
  Map<String, dynamic> toJson() => _$StudyCardDtoToJson(this);

  StudyCardEntity toEntity() => StudyCardEntity(
    id: id,
    title: title,
    category: CardCategory.newWords,
    answer: answer,
    answerType: answerType,
    hint: hint,
    example: example,
  );

  static String slug(String title) =>
      's_${title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'_+'), '_').replaceAll(RegExp(r'^_+|_+$'), '')}';
}

@JsonSerializable(explicitToJson: true)
class StudyDeckDto {
  StudyDeckDto({required this.id, required this.name, required this.cards});

  final String id;
  final String name;
  final List<StudyCardDto> cards;

  factory StudyDeckDto.fromJson(Map<String, dynamic> json) {
    final dto = _$StudyDeckDtoFromJson(json);
    final fixed = dto.cards
        .map(
          (c) => c.id.isEmpty
              ? StudyCardDto(
                  id: StudyCardDto.slug(c.title),
                  title: c.title,
                  answer: c.answer,
                  answerType: c.answerType,
                  hint: c.hint,
                  example: c.example,
                )
              : c,
        )
        .toList(growable: false);
    return StudyDeckDto(id: dto.id, name: dto.name, cards: fixed);
  }

  Map<String, dynamic> toJson() => _$StudyDeckDtoToJson(this);
}
