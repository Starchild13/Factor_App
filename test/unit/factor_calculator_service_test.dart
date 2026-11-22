import 'package:flutter_test/flutter_test.dart';
import 'package:jess_13/services/factor_calculator_service.dart';

void main() {
  group('FactorCalculatorService', () {
    const service = FactorCalculatorService();

    test('returns correct factors for composite numbers', () {
      expect(service.calculateFactors(12), equals([1, 2, 3, 4, 6, 12]));
      expect(service.calculateFactors(20), equals([1, 2, 4, 5, 10, 20]));
    });

    test('returns correct factors for perfect squares', () {
      expect(service.calculateFactors(16), equals([1, 2, 4, 8, 16]));
      expect(service.calculateFactors(25), equals([1, 5, 25]));
    });

    test('returns correct factors for prime numbers', () {
      expect(service.calculateFactors(7), equals([1, 7]));
      expect(service.calculateFactors(13), equals([1, 13]));
    });

    test('returns [1] for 1', () {
      expect(service.calculateFactors(1), equals([1]));
    });

    test('returns empty list for non-positive numbers', () {
      expect(service.calculateFactors(0), isEmpty);
      expect(service.calculateFactors(-10), isEmpty);
    });
  });
}
