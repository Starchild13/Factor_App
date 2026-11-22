import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/flash_card_viewmodel.dart';

/// Screen displaying times tables 1 to 20 as interactive flash cards and quiz mode.
class FlashCardScreen extends StatefulWidget {
  const FlashCardScreen({super.key});

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  final TextEditingController _quizAnswerController = TextEditingController();

  @override
  void dispose() {
    _quizAnswerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FlashCardViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final card = viewModel.currentCard;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.school,
                size: 20,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Times Tables 1–20',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              viewModel.isQuizMode ? Icons.style : Icons.quiz,
              color: colorScheme.primary,
            ),
            tooltip: viewModel.isQuizMode ? 'Switch to Flash Cards' : 'Switch to Quiz Mode',
            onPressed: () {
              _quizAnswerController.clear();
              viewModel.toggleQuizMode(!viewModel.isQuizMode);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Table Selector List (Dropdown)
              Row(
                children: [
                  Text(
                    'Select Table:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<int>(
                      value: viewModel.selectedTable,
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem(
                          value: 0,
                          child: Text('All Tables (1-20)'),
                        ),
                        ...List.generate(20, (index) {
                          final tableNum = index + 1;
                          return DropdownMenuItem(
                            value: tableNum,
                            child: Text('Table $tableNum'),
                          );
                        }),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          viewModel.selectTable(val);
                          _quizAnswerController.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Sub-controls (Multiplier range & Shuffle)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Range: ×1 to ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      DropdownButton<int>(
                        value: viewModel.maxMultiplier,
                        items: const [
                          DropdownMenuItem(value: 10, child: Text('10')),
                          DropdownMenuItem(value: 12, child: Text('12')),
                          DropdownMenuItem(value: 20, child: Text('20')),
                        ],
                        onChanged: (val) {
                          if (val != null) viewModel.setMaxMultiplier(val);
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (viewModel.isQuizMode) ...[
                        Text(
                          'Score: ${viewModel.score} (Streak: ${viewModel.streak})',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      IconButton(
                        icon: const Icon(Icons.shuffle),
                        tooltip: 'Shuffle Cards',
                        onPressed: () {
                          viewModel.shuffleCards();
                          _quizAnswerController.clear();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Main Flash Card View
              Expanded(
                child: card == null
                    ? const Center(child: Text('No flash cards available'))
                    : Column(
                        children: [
                          // Progress indicator
                          Text(
                            'Card ${viewModel.currentIndex + 1} of ${viewModel.cards.length}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Flash Card
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!viewModel.isQuizMode) {
                                  viewModel.flipCard();
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: viewModel.isFlipped
                                      ? colorScheme.primaryContainer
                                      : colorScheme.surface,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: viewModel.isFlipped
                                        ? colorScheme.primary
                                        : colorScheme.outlineVariant.withValues(alpha: 0.5),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        viewModel.isQuizMode && !viewModel.isFlipped
                                            ? 'What is...'
                                            : (viewModel.isFlipped ? 'Answer' : 'Tap to reveal answer'),
                                        style: theme.textTheme.labelLarge?.copyWith(
                                          color: viewModel.isFlipped
                                              ? colorScheme.onPrimaryContainer
                                              : colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        card.question,
                                        style: theme.textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      if (viewModel.isFlipped) ...[
                                        const SizedBox(height: 16),
                                        Text(
                                          '= ${card.answer}',
                                          style: theme.textTheme.displayMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.primary,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        if (viewModel.isQuizMode && viewModel.isAnswerCorrect != null) ...[
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                viewModel.isAnswerCorrect!
                                                    ? Icons.check_circle
                                                    : Icons.cancel,
                                                color: viewModel.isAnswerCorrect!
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                viewModel.isAnswerCorrect!
                                                    ? 'Correct!'
                                                    : 'Incorrect (Your answer: ${viewModel.userAnswer})',
                                                style: theme.textTheme.titleMedium?.copyWith(
                                                  color: viewModel.isAnswerCorrect!
                                                    ? Colors.green
                                                    : Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 16),

              // Quiz Input or Navigation Controls
              if (viewModel.isQuizMode && !viewModel.isFlipped) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _quizAnswerController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Enter your answer',
                          hintText: 'e.g., 56',
                        ),
                        onSubmitted: (val) {
                          final ans = int.tryParse(val.trim());
                          if (ans != null) {
                            viewModel.submitAnswer(ans);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        final ans = int.tryParse(_quizAnswerController.text.trim());
                        if (ans != null) {
                          viewModel.submitAnswer(ans);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // Bottom Navigation Buttons (Prev / Next)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        viewModel.previousCard();
                        _quizAnswerController.clear();
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        viewModel.nextCard();
                        _quizAnswerController.clear();
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(viewModel.isFlipped || !viewModel.isQuizMode ? 'Next' : 'Skip'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
