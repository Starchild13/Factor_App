/// Service responsible for factor calculations.
///
/// Separated from UI/ViewModel to follow Clean Architecture principles,
/// enabling isolation, reusability, and unit testing.
class FactorCalculatorService {
  const FactorCalculatorService();

  /// Calculates all positive integer factors of [number] in ascending order.
  ///
  /// Returns an empty list if [number] is less than or equal to 0.
  /// Uses an O(√N) algorithm for optimal performance with large inputs.
  List<int> calculateFactors(int number) {
    if (number <= 0) {
      return const [];
    }

    final List<int> smallFactors = [];
    final List<int> largeFactors = [];

    for (int i = 1; i * i <= number; i++) {
      if (number % i == 0) {
        smallFactors.add(i);
        final int divisor = number ~/ i;
        if (divisor != i) {
          largeFactors.add(divisor);
        }
      }
    }

    return [...smallFactors, ...largeFactors.reversed];
  }
}
