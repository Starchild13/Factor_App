import 'package:flutter/material.dart';
import '../models/factor_result.dart';
import '../services/factor_calculator_service.dart';

/// ViewModel managing presentation state and user interactions for factor calculations.
///
/// Follows the MVVM architecture pattern with Provider state management.
class FactorViewModel extends ChangeNotifier {
  final FactorCalculatorService _calculatorService;
  final TextEditingController _inputController = TextEditingController();

  FactorResult _result = FactorResult.initial();

  FactorViewModel({
    FactorCalculatorService calculatorService = const FactorCalculatorService(),
  }) : _calculatorService = calculatorService;

  TextEditingController get inputController => _inputController;
  FactorResult get result => _result;

  /// Calculates factors for the text currently in the input controller,
  /// or for the optional [rawInput] string if supplied.
  void calculateFactors([String? rawInput]) {
    final String text = (rawInput ?? _inputController.text).trim();

    if (text.isEmpty) {
      _result = FactorResult.initial();
      notifyListeners();
      return;
    }

    final int? parsedNumber = int.tryParse(text);
    if (parsedNumber == null) {
      _result = FactorResult.error('Please enter a valid integer');
      notifyListeners();
      return;
    }

    if (parsedNumber <= 0) {
      _result = FactorResult.error('Please enter a positive number greater than 0');
      notifyListeners();
      return;
    }

    final List<int> factors = _calculatorService.calculateFactors(parsedNumber);
    _result = FactorResult.success(parsedNumber, factors);
    notifyListeners();
  }

  /// Clears the input field and resets factor result to initial state.
  void clear() {
    _inputController.clear();
    _result = FactorResult.initial();
    notifyListeners();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
