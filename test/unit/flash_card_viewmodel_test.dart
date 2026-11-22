import 'package:flutter_test/flutter_test.dart';
import 'package:jess_13/viewmodels/flash_card_viewmodel.dart';

void main() {
  group('FlashCardViewModel', () {
    late FlashCardViewModel viewModel;

    setUp(() {
      viewModel = FlashCardViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state loads table 1 cards', () {
      expect(viewModel.selectedTable, equals(1));
      expect(viewModel.cards, isNotEmpty);
      expect(viewModel.currentIndex, equals(0));
      expect(viewModel.isFlipped, isFalse);
      expect(viewModel.isQuizMode, isFalse);
    });

    test('switching table updates cards', () {
      viewModel.selectTable(7);
      expect(viewModel.selectedTable, equals(7));
      expect(viewModel.currentCard?.multiplier1, equals(7));
      expect(viewModel.currentCard?.multiplier2, equals(1));
    });

    test('flipping card toggles state', () {
      expect(viewModel.isFlipped, isFalse);
      viewModel.flipCard();
      expect(viewModel.isFlipped, isTrue);
      viewModel.flipCard();
      expect(viewModel.isFlipped, isFalse);
    });

    test('navigation cycles through cards', () {
      final initialCard = viewModel.currentCard;
      viewModel.nextCard();
      expect(viewModel.currentIndex, equals(1));
      expect(viewModel.currentCard, isNot(equals(initialCard)));

      viewModel.previousCard();
      expect(viewModel.currentIndex, equals(0));
      expect(viewModel.currentCard, equals(initialCard));
    });

    test('quiz mode grading works correctly', () {
      viewModel.toggleQuizMode(true);
      expect(viewModel.isQuizMode, isTrue);

      final card = viewModel.currentCard!;
      viewModel.submitAnswer(card.answer);

      expect(viewModel.isFlipped, isTrue);
      expect(viewModel.isAnswerCorrect, isTrue);
      expect(viewModel.score, equals(1));
      expect(viewModel.streak, equals(1));
    });
  });
}
