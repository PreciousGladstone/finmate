import 'package:finmate/core/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:finmate/core/constants/app_constants.dart';

/// Reusable transaction filter and search widget
class TransactionFilterBar extends StatelessWidget {
  final String? selectedFilter;
  final String? searchQuery;
  final ValueChanged<String?> onFilterChanged;
  final ValueChanged<String?> onSearchChanged;

  const TransactionFilterBar({
    super.key,
    required this.selectedFilter,
    required this.searchQuery,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: AppStrings.search,
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const Gap(12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip(context, 'All', null),
                const Gap(8),
                _buildChip(context, 'Income', 'Income'),
                const Gap(8),
                _buildChip(context, 'Expense', 'Expense'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, String? value) {
    final isSelected = selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onFilterChanged(selected ? value : null),
      backgroundColor: AppColors.grey200,
      selectedColor: AppColors.primaryDefault,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
