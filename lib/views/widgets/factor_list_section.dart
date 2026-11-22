import 'package:flutter/material.dart';
import '../../models/factor_result.dart';

/// UI component displaying the calculated list of factors with interactive views and statistics.
class FactorListSection extends StatefulWidget {
  final FactorResult result;

  const FactorListSection({
    super.key,
    required this.result,
  });

  @override
  State<FactorListSection> createState() => _FactorListSectionState();
}

class _FactorListSectionState extends State<FactorListSection> {
  int _selectedView = 0; // 0: List, 1: Pairs, 2: Tuples

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final result = widget.result;
    final factors = result.factors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header line (compatible with test suite)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Factors of ${result.inputNumber} (${factors.length} total)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Insights / Stats Badges
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildBadge(
                context,
                icon: result.isPrime ? Icons.verified : Icons.hub_outlined,
                label: result.isPrime ? 'Prime Number' : 'Composite',
                color: result.isPrime ? Colors.green : colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              if (result.isPerfectSquare) ...[
                _buildBadge(
                  context,
                  icon: Icons.crop_square,
                  label: 'Perfect Square',
                  color: Colors.amber.shade800,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),

        // View Switcher
        Row(
          children: [
            Text(
              'View Mode:',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(
                    value: 0,
                    icon: Icon(Icons.format_list_bulleted, size: 16),
                    label: Text('List'),
                  ),
                  ButtonSegment(
                    value: 1,
                    icon: Icon(Icons.join_inner, size: 16),
                    label: Text('Pairs'),
                  ),
                  ButtonSegment(
                    value: 2,
                    icon: Icon(Icons.data_object, size: 16),
                    label: Text('Tuples'),
                  ),
                ],
                selected: {_selectedView},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedView = newSelection.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: colorScheme.primaryContainer,
                  selectedForegroundColor: colorScheme.onPrimaryContainer,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Factor Content Views
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _buildSelectedView(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedView(BuildContext context) {
    switch (_selectedView) {
      case 1:
        return _buildPairsView(context);
      case 2:
        return _buildTupleView(context);
      case 0:
      default:
        return _buildListView(context);
    }
  }

  Widget _buildListView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final factors = widget.result.factors;

    return ListView.builder(
      key: const ValueKey('list_view'),
      itemCount: factors.length,
      itemBuilder: (context, index) {
        final factor = factors[index];
        final counterpart = widget.result.inputNumber ~/ factor;

        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              factor.toString(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '$factor × $counterpart = ${widget.result.inputNumber}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPairsView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pairs = widget.result.factorPairs;

    return ListView.builder(
      key: const ValueKey('pairs_view'),
      itemCount: pairs.length,
      itemBuilder: (context, index) {
        final pair = pairs[index];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '${pair.key}  ×  ${pair.value}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '= ${widget.result.inputNumber}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTupleView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final factors = widget.result.factors;
    final tupleString = '(${factors.join(', ')})';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          key: const ValueKey('tuple_view'),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'All Factors Tuple',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  tupleString,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Total factors: ${factors.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
