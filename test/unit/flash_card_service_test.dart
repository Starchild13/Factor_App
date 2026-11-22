import 'package:flutter_test/flutter_test.dart';
import 'package:jess_13/services/flash_card_service.dart';

void main() {
  group('FlashCardService', () {
    const service = FlashCardService();

    test('generates correct flash cards for a specific table', () {
      final cards = service.getFlashCardsForTable(5, maxMultiplier: 5);
      expect(cards.length, equals(5));
      expect(cards[0].multiplier1, equals(5));
      expect(cards[0].multiplier2, equals(1));
      expect(cards[0].answer, equals(5));
      expect(cards[4].multiplier2, equals(5));
      expect(cards[4].answer, equals(25));
    });

    test('returns empty list for out of range table numbers', () {
      expect(service.getFlashCardsForTable(0), isEmpty);
      expect(service.getFlashCardsForTable(21), isEmpty);
    });

    test('generates all flash cards for tables 1 to 20', () {
      final allCards = service.getAllFlashCards(maxMultiplier: 10);
      expect(allCards.length, equals(20 * 10));
      expect(allCards.first.multiplier1, equals(1));
      expect(allCards.first.multiplier2, equals(1));
      expect(allCards.last.multiplier1, equals(20));
      expect(allCards.last.multiplier2, equals(10));
    });
  });
}
