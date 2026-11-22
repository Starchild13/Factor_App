import 'package:flutter_test/flutter_test.dart';
import 'package:jess_13/viewmodels/factor_viewmodel.dart';

void main() {
  group('FactorViewModel', () {
    late FactorViewModel viewModel;

    setUp(() {
      viewModel = FactorViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state is unsearched and empty', () {
      expect(viewModel.result.hasSearched, isFalse);
      expect(viewModel.result.factors, isEmpty);
      expect(viewModel.result.errorMessage, isNull);
    });

    test('calculates factors for valid positive number', () {
      viewModel.inputController.text = '12';
      viewModel.calculateFactors();

      expect(viewModel.result.hasSearched, isTrue);
      expect(viewModel.result.isSuccess, isTrue);
      expect(viewModel.result.factors, equals([1, 2, 3, 4, 6, 12]));
      expect(viewModel.result.inputNumber, equals(12));
    });

    test('sets error message for non-numeric input', () {
      viewModel.inputController.text = 'abc';
      viewModel.calculateFactors();

      expect(viewModel.result.hasSearched, isTrue);
      expect(viewModel.result.hasError, isTrue);
      expect(viewModel.result.errorMessage, contains('valid integer'));
    });

    test('sets error message for zero or negative input', () {
      viewModel.inputController.text = '-5';
      viewModel.calculateFactors();

      expect(viewModel.result.hasSearched, isTrue);
      expect(viewModel.result.hasError, isTrue);
      expect(viewModel.result.errorMessage, contains('positive number'));
    });

    test('clear resets controller and state', () {
      viewModel.inputController.text = '12';
      viewModel.calculateFactors();

      viewModel.clear();

      expect(viewModel.inputController.text, isEmpty);
      expect(viewModel.result.hasSearched, isFalse);
      expect(viewModel.result.factors, isEmpty);
      expect(viewModel.result.errorMessage, isNull);
    });
  });
}
