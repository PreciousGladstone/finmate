import 'dart:developer';
import 'package:finmate/core/utils/helpers/snackbar_helper.dart';
import 'package:finmate/core/utils/validators/field_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finmate/domain/entities/goal.dart';
import 'package:finmate/features/shared/providers/index.dart';
import 'package:finmate/features/shared/widgets/customtextformfield.dart';

/// Goal Progress Dialog Widget
class GoalProgressDialog extends ConsumerStatefulWidget {
  final Goal goal;
  final VoidCallback? onProgressAdded;

  const GoalProgressDialog({
    super.key,
    required this.goal,
    this.onProgressAdded,
  });

  @override
  ConsumerState<GoalProgressDialog> createState() => _GoalProgressDialogState();
}

class _GoalProgressDialogState extends ConsumerState<GoalProgressDialog>
    with SingleTickerProviderStateMixin {
  late TextEditingController _amountController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    
    // Initialize animation controller for smooth dialog closing
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _popWithAnimation() async {
    // Play the scale-down animation
    await _animationController.forward();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation.drive(Tween<double>(begin: 1.0, end: 0.95)),
      child: AlertDialog(
        title: const Text('Add Progress'),
        content: Form(
          key: _formKey,
          child: CustomTextFieldWithLabel(
            label: 'Amount',
            hintText: 'Enter amount',
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) => FieldValidators.positiveNumber(value, fieldName: 'Amount'),
            formKey: _formKey,
            showLabel: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _popWithAnimation,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _handleAddProgress,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAddProgress() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final amount = double.parse(_amountController.text);
      log(' Dialog: User entered amount: $amount for goal: ${widget.goal.id}');

      final goalNotifier = ref.read(goalProvider.notifier);
      log('Dialog: Current goal state - currentAmount: ${widget.goal.currentAmount}, targetAmount: ${widget.goal.targetAmount}');
      
      // Wait for progress to be added and data to be fully reloaded
      log('Dialog: Awaiting updateGoalProgress...');
      await goalNotifier.updateGoalProgress(widget.goal.id, amount);
      log('Dialog: updateGoalProgress completed');

      if (!mounted) return;

      // Fetch the updated goal from provider (now guaranteed to have fresh data)
      Goal? updatedGoal;
      final goalState = ref.read(goalProvider);
      
      if (goalState.hasValue) {
        for (final goal in goalState.value!.goals) {
          if (goal.id == widget.goal.id) {
            updatedGoal = goal;
            log('Dialog: Found updated goal - currentAmount: ${goal.currentAmount}, targetAmount: ${goal.targetAmount}, achieved: ${goal.achieved}');
            break;
          }
        }
      }

      if (updatedGoal == null) {
        log('Dialog: Updated goal not found in provider state!');
      }

      if (!mounted) return;
      await _popWithAnimation();
      
      if (updatedGoal != null) {
        final isAchieved = updatedGoal.achieved;
        final message = isAchieved
            ? 'Goal achieved! Marked as Completed'
            : 'Progress added: ${amount.toStringAsFixed(2)}';
        if(!mounted) return;
        AppSnackBar.success(context, message);
      }
      
      widget.onProgressAdded?.call();
    } catch (e) {
      log('Dialog: Error in _handleAddProgress: $e');
      if(!mounted) return;
      AppSnackBar.error(context, 'Invalid amount');
    }
  }
}
