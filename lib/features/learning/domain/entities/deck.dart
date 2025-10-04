import 'package:flashcards_v2/features/learning/domain/entities/flashcard.dart';

class DeckEntity<Type extends FlashcardEntity> {
  final String id;
  final String name;
  final List<Type> cards;
  DeckEntity({required this.id, required this.name, required this.cards});
}
