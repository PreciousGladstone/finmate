import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/core/utils/validators/field_validators.dart';
import 'package:finmate/features/shared/widgets/customtextformfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Goal Form Fields Widget - Uses centralized CustomTextFieldWithLabel
class GoalFormFields extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController targetAmountController;
  final TextEditingController currentAmountController;
  final DateTime? endDate;
  final VoidCallback onDateTap;

  const GoalFormFields({
    super.key,
    this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.targetAmountController,
    required this.currentAmountController,
    required this.endDate,
    required this.onDateTap,
  });

  @override
  State<GoalFormFields> createState() => _GoalFormFieldsState();
}

class _GoalFormFieldsState extends State<GoalFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Goal Title Field
        CustomTextFieldWithLabel(
          label: 'Goal Title',
          hintText: 'e.g., Emergency Fund',
          controller: widget.titleController,
          validator: (value) => FieldValidators.minLength(value, 3, fieldName: 'Goal Title'),
          formKey: widget.formKey,
          showLabel: true,
          textInputAction: TextInputAction.next,
        ),
        const Gap(24),

        /// Description Field (Optional)
        CustomTextFieldWithLabel(
          label: 'Description',
          hintText: 'What\'s this goal for? (optional)',
          controller: widget.descriptionController,
          maxLines: 2,
          isOptional: true,
          validator: (value) => null,
          formKey: widget.formKey,
          showLabel: true,
          textInputAction: TextInputAction.next,
        ),
        const Gap(24),

        /// Target Amount Field
        CustomTextFieldWithLabel(
          label: AppStrings.targetAmount,
          hintText: 'Enter target amount',
          controller: widget.targetAmountController,
          keyboardType: TextInputType.number,
          validator: (value) => FieldValidators.positiveNumber(value, fieldName: 'Target Amount'),
          formKey: widget.formKey,
          showLabel: true,
          textInputAction: TextInputAction.next,
        ),
        const Gap(24),

        /// Current Amount Field
        CustomTextFieldWithLabel(
          label: 'Current Amount',
          hintText: 'Current amount saved',
          controller: widget.currentAmountController,
          keyboardType: TextInputType.number,
          validator: (value) => FieldValidators.number(value, fieldName: 'Current Amount'),
          formKey: widget.formKey,
          showLabel: true,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
