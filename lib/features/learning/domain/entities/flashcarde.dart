import 'package:flashcards_v2/features/learning/domain/entities/card_category.dart';

class FlashcardEntity {
  FlashcardEntity({
    required this.id,
    required this.title,
    required this.translation,
    this.transcription,
    this.audioPath,
    this.example,
    this.description,
    this.category = CardCategory.newWords,
  });

  final String id;
  final String title;
  final String translation;
  final String? transcription;
  final String? audioPath;
  final String? description;
  final String? example;
  CardCategory category;
}
