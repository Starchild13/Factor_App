import 'package:flutter/foundation.dart';

/// Immutable model representing the result of a factor calculation operation.
@immutable
class FactorResult {
  final int inputNumber;
  final List<int> factors;
  final String? errorMessage;
  final bool hasSearched;

  const FactorResult({
    required this.inputNumber,
    required this.factors,
    this.errorMessage,
    required this.hasSearched,
  });

  /// Factory constructor for an empty / initial state.
  factory FactorResult.initial() {
    return const FactorResult(
      inputNumber: 0,
      factors: [],
      errorMessage: null,
      hasSearched: false,
    );
  }

  /// Factory constructor for an error state.
  factory FactorResult.error(String message) {
    return FactorResult(
      inputNumber: 0,
      factors: const [],
      errorMessage: message,
      hasSearched: true,
    );
  }

  /// Factory constructor for a successful calculation result.
  factory FactorResult.success(int number, List<int> factors) {
    return FactorResult(
      inputNumber: number,
      factors: List.unmodifiable(factors),
      errorMessage: null,
      hasSearched: true,
    );
  }

  bool get isSuccess => hasSearched && errorMessage == null;
  bool get hasError => errorMessage != null;

  /// Returns true if the calculated number is a prime number (has exactly 2 factors: 1 and itself).
  bool get isPrime => inputNumber > 1 && factors.length == 2;

  /// Returns true if the calculated number is a perfect square.
  bool get isPerfectSquare => inputNumber > 0 && factors.length % 2 == 1;

  /// Returns unique factor pairs (f1, f2) such that f1 * f2 = inputNumber.
  List<MapEntry<int, int>> get factorPairs {
    final List<MapEntry<int, int>> pairs = [];
    final count = factors.length;
    for (int i = 0; i < (count + 1) ~/ 2; i++) {
      pairs.add(MapEntry(factors[i], factors[count - 1 - i]));
    }
    return pairs;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FactorResult &&
          runtimeType == other.runtimeType &&
          inputNumber == other.inputNumber &&
          listEquals(factors, other.factors) &&
          errorMessage == other.errorMessage &&
          hasSearched == other.hasSearched;

  @override
  int get hashCode =>
      inputNumber.hashCode ^
      Object.hashAll(factors) ^
      errorMessage.hashCode ^
      hasSearched.hashCode;
}
