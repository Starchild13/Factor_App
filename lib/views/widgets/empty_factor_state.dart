import 'package:flutter/material.dart';

/// Reusable empty state view displayed when no factors have been calculated yet or on error.
class EmptyFactorState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyFactorState({
    super.key,
    this.message = 'No factors to display.',
    this.icon = Icons.numbers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
