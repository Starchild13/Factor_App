import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jess_13/main.dart';

void main() {
  testWidgets('Factor Finder finds factors for entered number', (WidgetTester tester) async {
    // Set a realistic screen size for testing
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const FactorApp());

    // Verify initial UI elements
    expect(find.text('Factor Finder'), findsOneWidget);
    expect(find.text('Enter a number to find its factors'), findsOneWidget);

    // Enter a number in the input field
    await tester.enterText(find.byType(TextField), '12');
    await tester.tap(find.text('Find Factors'));
    await tester.pumpAndSettle();

    // Verify factors for 12 are displayed in 6 ListTiles
    expect(find.text('Factors of 12 (6 total)'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(6));

    // Tap on Tuples view mode
    await tester.tap(find.text('Tuples'));
    await tester.pumpAndSettle();

    // Verify tuple view is displayed with (1, 2, 3, 4, 6, 12)
    expect(find.text('(1, 2, 3, 4, 6, 12)'), findsOneWidget);
  });
}
