// Application-wide constants

class AppStrings {
  // Navigation
  static const String home = 'Home';
  static const String transactions = 'Transactions';
  static const String insights = 'Insights';
  static const String goals = 'Goals';

  // Common
  static const String appName = 'FinMate';
  static const String add = 'Add';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String close = 'Close';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String loading = 'Loading...';
  static const String noData = 'No data available';

  // Home Screen
  static const String balance = 'Balance';
  static const String income = 'Income';
  static const String noTransactionsYet = 'No transactions yet';
  static const String expense = 'Expense';
  static const String savingsGoal = 'Savings Goal';
  static const String recentTransactions = 'Recent Transactions';
  static const String spendingByCategory = 'Spending by Category';

  // Transaction Screen
  static const String addTransaction = 'Add Transaction';
  static const String editTransaction = 'Edit Transaction';
  static const String amount = 'Amount';
  static const String category = 'Category';
  static const String date = 'Date';
  static const String notes = 'Notes';
  static const String transactionHistory = 'Transaction History';
  static const String allTransactions = 'All Transactions';
  static const String filter = 'Filter';
  static const String search = 'Search';

  // Goals Screen
  static const String monthlyGoal = 'Monthly Savings Goal';
  static const String goalAmount = 'Goal Amount';
  static const String currentSavings = 'Current Savings';
  static const String targetAmount = 'Target Amount';
  static const String progress = 'Progress';
  static const String daysRemaining = 'Days Remaining';
  static const String congratulations = 'Congratulations!';
  static const String goalAchieved = 'You\'ve reached your savings goal!';

  // Insights Screen
  static const String topCategory = 'Top Spending Category';
  static const String thisWeek = 'This Week';
  static const String lastWeek = 'Last Week';
  static const String monthlyTrend = 'Monthly Trend';
  static const String categoryBreakdown = 'Category Breakdown';
  static const String averageSpending = 'Average Spending';

  // Validation
  static const String enterAmount = 'Please enter an amount';
  static const String enterValidAmount = 'Please enter a valid amount';
  static const String selectCategory = 'Please select a category';
  static const String selectDate = 'Please select a date';
  static const String invalidInput = 'Invalid input';
}

class AppConstants {
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const int dbVersion = 1;
  static const String dbName = 'finmate.db';
  static const String transactionsTable = 'transactions';
  static const String goalsTable = 'goals';

  // Date format
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
}

class TransactionCategory {
  static const String food = 'Food';
  static const String transport = 'Transport';
  static const String entertainment = 'Entertainment';
  static const String utilities = 'Utilities';
  static const String shopping = 'Shopping';
  static const String healthcare = 'Healthcare';
  static const String salary = 'Salary';
  static const String investment = 'Investment';
  static const String other = 'Other';

  static const List<String> all = [
    food,
    transport,
    entertainment,
    utilities,
    shopping,
    healthcare,
    salary,
    investment,
    other,
  ];

  static const Map<String, String> icons = {
    food: '🍔',
    transport: '🚗',
    entertainment: '🎬',
    utilities: '💡',
    shopping: '🛍️',
    healthcare: '🏥',
    salary: '💼',
    investment: '📈',
    other: '📌',
  };
}

class TransactionType {
  static const String income = 'Income';
  static const String expense = 'Expense';

  static const List<String> all = [income, expense];
}
