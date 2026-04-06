import 'package:finmate/core/utils/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/core/utils/app_logger.dart';
import 'package:finmate/domain/entities/goal.dart';
import 'package:finmate/features/shared/providers/index.dart';
import 'package:finmate/features/goals/widgets/goal_form_fields.dart';
import 'package:finmate/features/goals/widgets/goal_date_picker.dart';
import 'package:finmate/features/goals/widgets/goal_progress_dialog.dart';
import 'package:finmate/features/goals/widgets/goal_action_buttons.dart';

/// Goal Form Screen (Add/Edit)
class GoalFormScreen extends ConsumerStatefulWidget {
  final String? goalId;

  const GoalFormScreen({super.key, this.goalId});

  @override
  ConsumerState<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends ConsumerState<GoalFormScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _targetAmountController;
  late TextEditingController _currentAmountController;
  DateTime? _endDate;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _targetAmountController = TextEditingController();
    _currentAmountController = TextEditingController(text: '0');
    _endDate = DateTime.now().add(const Duration(days: 30));

    if (widget.goalId != null) {
      _loadGoalData();
    }
  }

  Future<void> _loadGoalData() async {
    if (widget.goalId == null) return;

    setState(() => _isLoading = true);

    try {
      final goalAsync = ref.read(goalProvider);
      goalAsync.whenData((state) {
        final goals = state.goals;
        Goal? foundGoal;

        for (final goal in goals) {
          if (goal.id == widget.goalId) {
            foundGoal = goal;
            break;
          }
        }

        if (foundGoal != null) {
          final goal = foundGoal;
          setState(() {
            _titleController.text = goal.title;
            _descriptionController.text = goal.description ?? '';
            _targetAmountController.text = goal.targetAmount.toString();
            _currentAmountController.text = goal.currentAmount.toString();
            _endDate = goal.endDate;
          });
        }
      });
    } catch (e) {
      AppLogger.error('Error loading goal', e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.goalId != null;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Goal' : 'Create New Goal'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoalFormFields(
                formKey: _formKey,
                titleController: _titleController,
                descriptionController: _descriptionController,
                targetAmountController: _targetAmountController,
                currentAmountController: _currentAmountController,
                endDate: _endDate,
                onDateTap: () {},
              ),
            const Gap(24),
            GoalDatePicker(
              selectedDate: _endDate,
              onDateTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );
                if (date != null) {
                  setState(() => _endDate = date);
                }
              },
            ),
            const Gap(32),
            GoalActionButtons(
              onSaveGoal: _saveGoal,
              onAddProgress: _showAddProgressDialogInForm,
              isEditing: widget.goalId != null,
            ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddProgressDialogInForm() {
    if (widget.goalId == null) return;

    // Create a temporary goal object for the dialog
    final targetAmount = double.tryParse(_targetAmountController.text) ?? 0;
    final currentAmount = double.tryParse(_currentAmountController.text);

    final tempGoal = Goal(
      id: widget.goalId!,
      title: _titleController.text,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      startDate: DateTime.now(),
      endDate: _endDate ?? DateTime.now(),
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      achieved: false,
      createdAt: DateTime.now(),
    );

    showDialog(
      context: context,
      builder: (_) => GoalProgressDialog(
        goal: tempGoal,
        onProgressAdded: () {
          // Refresh the current amount display
          _refreshCurrentAmount();
        },
      ),
    );
  }

  Future<void> _refreshCurrentAmount() async {
    try {
      final goalAsync = ref.read(goalProvider);
      goalAsync.whenData((state) {
        final goals = state.goals;

        // Find the updated goal
        for (final goal in goals) {
          if (goal.id == widget.goalId) {
            setState(() {
              _currentAmountController.text = goal.currentAmount.toString();

              // Check if goal is now achieved
              if (goal.currentAmount! >= goal.targetAmount) {
                AppSnackBar.success(
                  context,
                  'Congratulations! Goal achieved!',
                );
              }
            });
            return;
          }
        }
      });
    } catch (e) {
      AppLogger.error('Error refreshing current amount', e);
    }
  }

  Future<void> _saveGoal() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final targetAmount = double.parse(_targetAmountController.text);
    final currentAmount = double.parse(
      _currentAmountController.text.isEmpty ? '0' : _currentAmountController.text,
    );
    
    // Check if goal is achieved
    final isAchieved = currentAmount >= targetAmount;

    final goal = Goal(
      id: widget.goalId ?? const Uuid().v4(),
      title: _titleController.text,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      startDate: DateTime.now(),
      endDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      achieved: isAchieved,
      createdAt: DateTime.now(),
    );

    if (widget.goalId != null) {
      await ref.read(goalProvider.notifier).updateGoal(goal);
    } else {
      await ref.read(goalProvider.notifier).addGoal(goal);
    }

    if (!mounted) return;
    
    final message = isAchieved 
      ? 'Goal achieved and archived!' 
      : (widget.goalId != null ? 'Goal updated' : 'Goal created');
    
    AppSnackBar.success(context, message);

    Navigator.pop(context);
  }
}
