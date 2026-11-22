import 'package:flutter/foundation.dart';

/// Immutable model representing a times table flash card.
@immutable
class FlashCard {
  final int multiplier1;
  final int multiplier2;

  const FlashCard({
    required this.multiplier1,
    required this.multiplier2,
  });

  /// The product of the two multipliers.
  int get answer => multiplier1 * multiplier2;

  /// Display string for the question (e.g., "7 × 8").
  String get question => '$multiplier1 × $multiplier2';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashCard &&
          runtimeType == other.runtimeType &&
          multiplier1 == other.multiplier1 &&
          multiplier2 == other.multiplier2;

  @override
  int get hashCode => multiplier1.hashCode ^ multiplier2.hashCode;
}
