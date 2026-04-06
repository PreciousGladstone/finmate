import 'package:finmate/features/shared/widgets/empty_state_widget.dart';
import 'package:finmate/features/transactions/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/domain/entities/transaction.dart';

/// Builds the filtered and searchable transaction list
class TransactionListView extends StatelessWidget {
  final List<Transaction> transactions;
  final String? filterType;
  final String? searchQuery;
  final VoidCallback onAddTransaction;
  final Function(String) onEditTransaction;
  final Function(String) onDeleteTransaction;

  const TransactionListView({
    super.key,
    required this.transactions,
    this.filterType,
    this.searchQuery,
    required this.onAddTransaction,
    required this.onEditTransaction,
    required this.onDeleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredTransactions();

    if (filtered.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.receipt,
        message: 'No transactions found',
        actionLabel: 'Add Transaction',
        onAction: onAddTransaction,
      );
    }

    final dateFormat = DateFormat(AppConstants.dateFormat);
    final currencyFormat = NumberFormat.currency(symbol: '₹');

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final tx = filtered[index];
        return TransactionItem(
          category: tx.category,
          amount: currencyFormat.format(tx.amount),
          date: dateFormat.format(tx.date),
          type: tx.type,
          isExpense: tx.type == TransactionType.expense,
          onTap: () => onEditTransaction(tx.id),
          onDelete: () => onDeleteTransaction(tx.id),
        );
      },
    );
  }

  List<Transaction> _getFilteredTransactions() {
    var result = transactions;
    if (filterType != null) {
      result = result.where((t) => t.type == filterType).toList();
    }
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      result = result
          .where((t) =>
              t.notes?.toLowerCase().contains(searchQuery!.toLowerCase()) ??
              false)
          .toList();
    }
    return result;
  }
}
