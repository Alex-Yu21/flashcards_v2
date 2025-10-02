import 'package:flashcards_v2/features/learning/domain/entities/card_category.dart';

abstract class FlashcardEntity {
  FlashcardEntity({
    required this.id,
    required this.title,
    this.category = CardCategory.newWords,
  });

  final String id;
  final String title;
  CardCategory category;
}

final class LanguageCardEntity extends FlashcardEntity {
  LanguageCardEntity({
    required super.id,
    required super.title,
    super.category = CardCategory.newWords,

    required this.translation,
    this.transcription,
    this.audioPath,
    this.example,
    this.description,
  });

  final String translation;
  final String? transcription;
  final String? audioPath;
  final String? description;
  final String? example;
}

final class CodeCardEntity extends FlashcardEntity {
  CodeCardEntity({
    required super.id,
    required super.title,
    super.category = CardCategory.newWords,

    required this.answer,
    this.answerType,
    this.hint,
    this.example,
  });

  final String? answerType;
  final String? hint;
  final String answer;
  final String? example;
}

//TODO добавить sealed, когда добавится третий-четвёртый подтип или понадобится строгий switch
// TODO Equatable, когда начнутся проблемы с сравнениями/перерисовками. сравнивать по айди и так можно но наверно лучше перестраховаться
