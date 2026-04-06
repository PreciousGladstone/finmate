import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/core/utils/helpers/snackbar_helper.dart';
import 'package:finmate/domain/entities/transaction.dart';
import 'package:finmate/features/shared/providers/index.dart';
import 'package:finmate/features/shared/widgets/index.dart';
import 'package:finmate/features/transactions/widgets/transaction_category_dropdown.dart';
import 'package:finmate/features/transactions/widgets/transaction_date_picker.dart';
import 'package:finmate/features/transactions/widgets/transaction_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

/// Transaction form screen - create and edit transactions
class TransactionFormScreen extends ConsumerStatefulWidget {
  final String? transactionId;

  const TransactionFormScreen({super.key, this.transactionId});

  @override
  ConsumerState<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  String? _selectedType;
  String? _selectedCategory;
  DateTime? _selectedDate;
  Transaction? _existingTransaction;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
    _selectedDate = DateTime.now();
    _selectedType = 'Expense';
    if (widget.transactionId != null) {
      Future.microtask(() {
        _loadTransaction();
        setState(() {});
      });
    }
  }

  void _loadTransaction() {
    try {
      final transactionState = ref.read(transactionProvider);
      transactionState.whenData((state) {
        _existingTransaction = state.transactions.firstWhere(
          (t) => t.id == widget.transactionId,
        );
        _amountController.text = _existingTransaction!.amount.toString();
        _selectedType = _existingTransaction!.type;
        _selectedCategory = _existingTransaction!.category;
        _selectedDate = _existingTransaction!.date;
        _notesController.text = _existingTransaction!.notes ?? '';
        if (mounted) setState(() {});
      });
    } catch (e) {
      debugPrint('Transaction not found: $e');
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transactionId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? AppStrings.editTransaction : AppStrings.addTransaction,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Type Selector
                const FormLabel('Type'),
                const Gap(8),
                TransactionTypeSelector(
                  selectedType: _selectedType,
                  onTypeChanged: (type) => setState(() => _selectedType = type),
                ),
                const Gap(24),

                /// Amount Field
                CustomTextFieldWithLabel(
                  label: AppStrings.amount,
                  hintText: 'Enter amount',
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Amount is required';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const Gap(24),

                /// Category Dropdown
                FormLabel(AppStrings.category),
                const Gap(8),
                TransactionCategoryDropdown(
                  selectedCategory: _selectedCategory,
                  onCategoryChanged: (category) =>
                      setState(() => _selectedCategory = category),
                ),
                const Gap(24),

                /// Date Picker
                FormLabel(AppStrings.date),
                const Gap(8),
                TransactionDatePicker(
                  selectedDate: _selectedDate,
                  onDateTap: _selectDate,
                ),
                const Gap(24),

                /// Notes Field
                CustomTextFieldWithLabel(
                  label: AppStrings.notes,
                  hintText: 'Add notes (optional)',
                  controller: _notesController,
                  maxLines: 3,
                  isOptional: true,
                  validator: (value) {
                    // Notes are optional
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                child: Text(AppStrings.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  void _saveTransaction() {
    if (_amountController.text.isEmpty) {
      AppSnackBar.error(context, AppStrings.enterValidAmount);
      return;
    }
    if (_selectedCategory == null) {
      AppSnackBar.error(context, AppStrings.selectCategory);
      return;
    }
    final transaction = Transaction(
      id: widget.transactionId ?? const Uuid().v4(),
      amount: double.parse(_amountController.text),
      type: _selectedType!,
      category: _selectedCategory!,
      date: _selectedDate ?? DateTime.now(),
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      createdAt: _existingTransaction?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    if (widget.transactionId != null) {
      ref.read(transactionProvider.notifier).updateTransaction(transaction);
    } else {
      ref.read(transactionProvider.notifier).addTransaction(transaction);
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    AppSnackBar.success(
      context,
      widget.transactionId != null
          ? 'Transaction updated'
          : 'Transaction added',
    );
    Navigator.pop(context);
  }
}
