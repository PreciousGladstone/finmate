import 'package:finmate/core/router/route.dart';
import 'package:finmate/core/themes/app_color.dart';
import 'package:finmate/core/utils/helpers/snackbar_helper.dart';
import 'package:finmate/features/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/features/shared/providers/index.dart';
import 'package:finmate/features/transactions/widgets/transaction_filter_bar.dart';
import 'package:finmate/features/transactions/widgets/transaction_list_view.dart';

/// Transaction list screen - displays all transactions with filtering
class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});



  @override
  ConsumerState<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  String? _selectedFilter;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      ref.read(transactionProvider.notifier).loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionAsync = ref.watch(transactionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.transactionHistory),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: transactionAsync.when(
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(transactionProvider),
        ),
        data: (state) {
          return Column(
            children: [
              TransactionFilterBar(
                selectedFilter: _selectedFilter,
                searchQuery: _searchQuery,
                onFilterChanged: (f) => setState(() => _selectedFilter = f),
                onSearchChanged: (q) => setState(() => _searchQuery = q),
              ),
              Expanded(
                child: TransactionListView(
                  transactions: state.transactions,
                  filterType: _selectedFilter,
                  searchQuery: _searchQuery,
                  onAddTransaction: () =>
                      Navigator.pushNamed(context, AppRoutes.addTransaction),
                  onDeleteTransaction: (id) =>
                      _showDeleteDialog(context, id),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addTransaction),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content:
            const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(transactionProvider.notifier).deleteTransaction(id);
              Navigator.pop(context);
              AppSnackBar.success(context, 'Transaction deleted');
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.errorDark)),
          ),
        ],
      ),
    );
  }
}
