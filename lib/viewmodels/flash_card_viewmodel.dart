import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/flash_card.dart';
import '../services/flash_card_service.dart';

/// ViewModel managing state and user interactions for times tables flash cards (1 to 20).
class FlashCardViewModel extends ChangeNotifier {
  final FlashCardService _service;

  int _selectedTable = 1; // 1 to 20, or 0 for "All Tables (1-20)"
  int _maxMultiplier = 12; // 1 to 12 or up to 20
  List<FlashCard> _cards = [];
  int _currentIndex = 0;
  bool _isFlipped = false;
  bool _isQuizMode = false;
  int? _userAnswer;
  bool? _isAnswerCorrect;
  int _score = 0;
  int _streak = 0;

  FlashCardViewModel({
    FlashCardService service = const FlashCardService(),
  }) : _service = service {
    loadCards();
  }

  int get selectedTable => _selectedTable;
  int get maxMultiplier => _maxMultiplier;
  List<FlashCard> get cards => _cards;
  int get currentIndex => _currentIndex;
  FlashCard? get currentCard => _cards.isNotEmpty && _currentIndex < _cards.length ? _cards[_currentIndex] : null;
  bool get isFlipped => _isFlipped;
  bool get isQuizMode => _isQuizMode;
  int? get userAnswer => _userAnswer;
  bool? get isAnswerCorrect => _isAnswerCorrect;
  int get score => _score;
  int get streak => _streak;

  void loadCards() {
    if (_selectedTable == 0) {
      _cards = _service.getAllFlashCards(maxMultiplier: _maxMultiplier);
    } else {
      _cards = _service.getFlashCardsForTable(_selectedTable, maxMultiplier: _maxMultiplier);
    }
    _currentIndex = 0;
    _isFlipped = false;
    _userAnswer = null;
    _isAnswerCorrect = null;
    _score = 0;
    _streak = 0;
    notifyListeners();
  }

  void selectTable(int table) {
    if (table < 0 || table > 20) return;
    _selectedTable = table;
    loadCards();
  }

  void setMaxMultiplier(int max) {
    if (max < 1 || max > 20) return;
    _maxMultiplier = max;
    loadCards();
  }

  void toggleQuizMode(bool enabled) {
    _isQuizMode = enabled;
    _isFlipped = false;
    _userAnswer = null;
    _isAnswerCorrect = null;
    notifyListeners();
  }

  void flipCard() {
    _isFlipped = !_isFlipped;
    notifyListeners();
  }

  void nextCard() {
    if (_cards.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _cards.length;
    _isFlipped = false;
    _userAnswer = null;
    _isAnswerCorrect = null;
    notifyListeners();
  }

  void previousCard() {
    if (_cards.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _cards.length) % _cards.length;
    _isFlipped = false;
    _userAnswer = null;
    _isAnswerCorrect = null;
    notifyListeners();
  }

  void shuffleCards() {
    if (_cards.isEmpty) return;
    final rng = Random();
    _cards.shuffle(rng);
    _currentIndex = 0;
    _isFlipped = false;
    _userAnswer = null;
    _isAnswerCorrect = null;
    notifyListeners();
  }

  void submitAnswer(int answer) {
    final card = currentCard;
    if (card == null) return;
    _userAnswer = answer;
    _isAnswerCorrect = answer == card.answer;
    _isFlipped = true;
    if (_isAnswerCorrect == true) {
      _score++;
      _streak++;
    } else {
      _streak = 0;
    }
    notifyListeners();
  }
}
