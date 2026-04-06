import 'package:finmate/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// Reusable transaction category dropdown widget
/// Handles category selection with icons and styling
class TransactionCategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  const TransactionCategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      items: TransactionCategory.all
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Text('${TransactionCategory.icons[category]} $category'),
            ),
          )
          .toList(),
      onChanged: onCategoryChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        hintText: 'Select category',
      ),
    );
  }
}
