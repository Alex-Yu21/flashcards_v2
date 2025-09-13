enum CardCategory { defaultCat, newWords, learning, reviewing, mastered }

extension CardCategoryPromote on CardCategory {
  CardCategory get promoteNext {
    switch (this) {
      case CardCategory.newWords:
        return CardCategory.learning;
      case CardCategory.learning:
        return CardCategory.reviewing;
      case CardCategory.reviewing:
        return CardCategory.mastered;
      case CardCategory.mastered:
        return CardCategory.mastered;
      case CardCategory.defaultCat:
        return CardCategory.defaultCat;
      // ignore: unreachable_switch_default
      default:
        throw UnsupportedError('Unknown CardCategory');
    }
  }
}

extension CardCategoryRegress on CardCategory {
  CardCategory get regressNext => CardCategory.newWords;
}
