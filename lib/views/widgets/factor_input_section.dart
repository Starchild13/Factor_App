import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/factor_viewmodel.dart';

/// UI component containing the input text field and action buttons.
class FactorInputSection extends StatelessWidget {
  const FactorInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FactorViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: viewModel.inputController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => viewModel.calculateFactors(),
            decoration: InputDecoration(
              labelText: 'Enter a number to find its factors',
              hintText: 'e.g., 24',
              prefixIcon: Icon(
                Icons.pin_outlined,
                color: colorScheme.primary,
              ),
              errorText: viewModel.result.errorMessage,
              suffixIcon: viewModel.inputController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => viewModel.clear(),
                      tooltip: 'Clear input',
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => viewModel.calculateFactors(),
                  icon: const Icon(Icons.calculate),
                  label: const Text('Find Factors'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: 'Random Number',
                child: OutlinedButton(
                  onPressed: () {
                    final randomNum = (Random().nextInt(100) + 1) * 2;
                    viewModel.inputController.text = randomNum.toString();
                    viewModel.calculateFactors();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Icon(Icons.shuffle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
