import '../models/flash_card.dart';

/// Service responsible for generating times tables flash cards from 1 to 20.
class FlashCardService {
  const FlashCardService();

  /// Generates flash cards for a specific table [tableNumber] (1 to 20)
  /// with multipliers from 1 to [maxMultiplier] (default 20).
  List<FlashCard> getFlashCardsForTable(int tableNumber, {int maxMultiplier = 20}) {
    if (tableNumber < 1 || tableNumber > 20) {
      return [];
    }
    final List<FlashCard> cards = [];
    for (int i = 1; i <= maxMultiplier; i++) {
      cards.add(FlashCard(multiplier1: tableNumber, multiplier2: i));
    }
    return cards;
  }

  /// Generates all flash cards for times tables 1 to 20
  /// with multipliers from 1 to [maxMultiplier] (default 20).
  List<FlashCard> getAllFlashCards({int maxMultiplier = 20}) {
    final List<FlashCard> cards = [];
    for (int t = 1; t <= 20; t++) {
      for (int m = 1; m <= maxMultiplier; m++) {
        cards.add(FlashCard(multiplier1: t, multiplier2: m));
      }
    }
    return cards;
  }
}
