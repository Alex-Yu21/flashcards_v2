import 'package:flashcards_v2/features/learning/domain/entities/flashcard.dart';

abstract class FlashcardRepository {
  Future<List<FlashcardEntity>> fetchAllFlashcards();
  Future<void> saveFlashcard(FlashcardEntity card);
}
