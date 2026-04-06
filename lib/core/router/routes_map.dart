import 'package:flutter/material.dart';
import 'package:finmate/core/router/route.dart';
import 'package:finmate/home_layout.dart';
import 'package:finmate/features/transactions/pages/index.dart';
import 'package:finmate/features/goals/pages/index.dart';
import 'package:finmate/features/insights/pages/index.dart';
import 'package:finmate/features/transactions/pages/transaction_detail_screen.dart';
import 'package:finmate/features/goals/pages/goal_detail_screen.dart';

/// Application routes map
final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.home: (context) => const HomeLayout(),
  AppRoutes.transactions: (context) => const TransactionListScreen(),
  AppRoutes.addTransaction: (context) => const TransactionFormScreen(),
  AppRoutes.editTransaction: (context) => const TransactionFormScreen(),
  AppRoutes.insights: (context) => const InsightsScreen(),
  AppRoutes.goals: (context) => const GoalsScreen(),
  AppRoutes.addGoal: (context) => const GoalFormScreen(),
  AppRoutes.editGoal: (context) => const GoalFormScreen(),
};

/// Generate route for parameterized routes (detail screens, edit screens with IDs)
Route<dynamic>? generateRoute(RouteSettings settings) {
  // Handle transaction detail route
  if (settings.name?.startsWith(AppRoutes.transactionDetail) ?? false) {
    final uri = Uri.parse(settings.name ?? '');
    final id = uri.queryParameters['id'];
    if (id != null) {
      return MaterialPageRoute(
        builder: (_) => TransactionDetailScreen(transactionId: id),
        settings: settings,
      );
    }
  }

  // Handle goal detail route
  if (settings.name?.startsWith(AppRoutes.goalDetail) ?? false) {
    final uri = Uri.parse(settings.name ?? '');
    final id = uri.queryParameters['id'];
    if (id != null) {
      return MaterialPageRoute(
        builder: (_) => GoalDetailScreen(goalId: id),
        settings: settings,
      );
    }
  }

  // Handle edit transaction route
  if (settings.name?.startsWith(AppRoutes.editTransaction) ?? false) {
    final uri = Uri.parse(settings.name ?? '');
    final id = uri.queryParameters['id'];
    if (id != null) {
      return MaterialPageRoute(
        builder: (_) => TransactionFormScreen(transactionId: id),
        settings: settings,
      );
    }
  }

  // Handle edit goal route
  if (settings.name?.startsWith(AppRoutes.editGoal) ?? false) {
    final uri = Uri.parse(settings.name ?? '');
    final id = uri.queryParameters['id'];
    if (id != null) {
      return MaterialPageRoute(
        builder: (_) => GoalFormScreen(goalId: id),
        settings: settings,
      );
    }
  }

  return null;
}
