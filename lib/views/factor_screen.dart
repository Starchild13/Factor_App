import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/factor_viewmodel.dart';
import 'widgets/empty_factor_state.dart';
import 'widgets/factor_input_section.dart';
import 'widgets/factor_list_section.dart';

/// Main screen displaying the Factor Finder user interface.
class FactorScreen extends StatelessWidget {
  const FactorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 20,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Factor Finder',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              const FactorInputSection(),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<FactorViewModel>(
                  builder: (context, viewModel, child) {
                    final result = viewModel.result;

                    if (!result.hasSearched) {
                      return const SizedBox.shrink();
                    }

                    if (result.hasError) {
                      return EmptyFactorState(
                        message: result.errorMessage ?? 'An error occurred.',
                        icon: Icons.error_outline,
                      );
                    }

                    if (result.factors.isEmpty) {
                      return const EmptyFactorState(
                        message: 'No factors found.',
                        icon: Icons.do_not_disturb,
                      );
                    }

                    return FactorListSection(result: result);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
