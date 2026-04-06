// import 'package:finmate/core/constants/app_constants.dart';
// import 'package:finmate/presentation/widgets/customtextformfield.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:intl/intl.dart';
// //TODO MOVE WIDGET TO REUSABLE COMPONENT AND THIS SHOULD BE THE FORM SCREEN
// /// Reusable transaction form fields component
// class TransactionFormFields extends StatelessWidget {
//   final TextEditingController amountController;
//   final TextEditingController notesController;
//   final String? selectedType;
//   final String? selectedCategory;
//   final DateTime? selectedDate;
//   final ValueChanged<String?> onTypeChanged;
//   final ValueChanged<String?> onCategoryChanged;
//   final VoidCallback onDateTap;

//   const TransactionFormFields({
//     super.key,
//     required this.amountController,
//     required this.notesController,
//     required this.selectedType,
//     required this.selectedCategory,
//     required this.selectedDate,
//     required this.onTypeChanged,
//     required this.onCategoryChanged,
//     required this.onDateTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// Type Selector
//         _buildLabel(context, 'Type'),
//         const Gap(8),
//         _buildTypeSelector(),
//         const Gap(24),

//         /// Amount Field
//         CustomTextFieldWithLabel(
//           label: AppStrings.amount,
//           hintText: 'Enter amount',
//           controller: amountController,
//           keyboardType: TextInputType.number,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Amount is required';
//             }
//             if (double.tryParse(value) == null || double.parse(value) <= 0) {
//               return 'Enter a valid amount';
//             }
//             return null;
//           },
//           textInputAction: TextInputAction.next,
//         ),
//         const Gap(24),

//         /// Category Dropdown
//         _buildLabel(context, AppStrings.category),
//         const Gap(8),
//         _buildCategoryDropdown(),
//         const Gap(24),

//         /// Date Picker
//         _buildLabel(context, AppStrings.date),
//         const Gap(8),
//         _buildDatePicker(),
//         const Gap(24),

//         /// Notes Field
//         CustomTextFieldWithLabel(
//           label: AppStrings.notes,
//           hintText: 'Add notes (optional)',
//           controller: notesController,
//           maxLines: 3,
//           isOptional: true,
//           validator: (value) {
//             // Notes are optional
//             return null;
//           },
//           textInputAction: TextInputAction.done,
//         ),
//       ],
//     );
//   }

//   Widget _buildLabel(BuildContext context, String text) =>
//       Text(text,
//           style: Theme.of(context).textTheme.bodyMedium
//               ?.copyWith(fontWeight: FontWeight.w600));

//   Widget _buildTypeSelector() => Row(
//         children: [
//           Expanded(child: _buildTypeButton('Income', 'Income')),
//           const Gap(12),
//           Expanded(child: _buildTypeButton('Expense', 'Expense')),
//         ],
//       );

//   Widget _buildTypeButton(String label, String value) {
//     final isSelected = selectedType == value;
//     final color = value == 'Income' ? Colors.green : Colors.red;
//     return GestureDetector(
//       onTap: () => onTypeChanged(value),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           border: Border.all(
//               color: isSelected ? color : Colors.grey[300]!,
//               width: isSelected ? 2 : 1),
//           borderRadius: BorderRadius.circular(8),
//           color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(value == 'Income' ? Icons.trending_up : Icons.trending_down,
//                 color: isSelected ? color : Colors.grey),
//             const Gap(8),
//             Text(label,
//                 style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: isSelected ? color : Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDatePicker() => GestureDetector(
//         onTap: onDateTap,
//         child: Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey[300]!),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             children: [
//               const Icon(Icons.calendar_today, size: 20),
//               const Gap(12),
//               Text(DateFormat(AppConstants.dateFormat)
//                   .format(selectedDate ?? DateTime.now())),
//             ],
//           ),
//         ),
//       );

//   Widget _buildCategoryDropdown() =>
//       DropdownButtonFormField<String>(
//         value: selectedCategory,
//         items: TransactionCategory.all
//             .map((category) => DropdownMenuItem(
//                   value: category,
//                   child: Text(
//                       '${TransactionCategory.icons[category]} $category'),
//                 ))
//             .toList(),
//         onChanged: onCategoryChanged,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           hintText: 'Select category',
//         ),
//       );
// }
