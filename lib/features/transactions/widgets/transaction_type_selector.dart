import 'package:finmate/core/themes/app_color.dart';
import 'package:finmate/core/themes/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Reusable transaction type selector widget - Income/Expense buttons
/// Can be used anywhere in the app for type selection
class TransactionTypeSelector extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String> onTypeChanged;
  final List<String> types;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    this.types = const ['Income', 'Expense'],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        types.length,
        (index) {
          final type = types[index];
          return Expanded(
            child: _buildTypeButton(context, type),
          );
        },
      ).separated(const Gap(12)),
    );
  }

  /// Build individual type button with proper styling
  Widget _buildTypeButton(BuildContext context, String value) {
    final isSelected = selectedType == value;
    final color = value == 'Income' ? Colors.green : Colors.red;

    return GestureDetector(
      onTap: () => onTypeChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : AppColors.grey300,
            width: isSelected ? 2 : 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              value == 'Income' ? Icons.trending_up : Icons.trending_down,
              color: isSelected ? color : AppColors.grey500,
              size: 20,
            ),
            const Gap(8),
            Text(
              value,
              style: AppTextStyles.p1Medium.copyWith(
                color: isSelected ? color : AppColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension to add separated method to list
extension SeparatedList<T> on List<Widget> {
  List<Widget> separated(Widget separator) {
    if (isEmpty) return this;
    final result = <Widget>[];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) result.add(separator);
    }
    return result;
  }
}
