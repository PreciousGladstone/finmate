# FinMate - Personal Finance Companion

A mobile app for tracking daily financial habits, monitoring spending patterns, managing goals, and gaining insights into personal money management. Built with Flutter and Clean Architecture principles.

## 🎯 Features

### 1. **Home Dashboard**
- **Quick Summary**: Display current balance, total income, and total expenses at a glance
- **Monthly Savings Goal**: Visual progress tracking for active savings goal
- **Spending by Category**: Pie chart showing expense breakdown by category
- **Recent Transactions**: Quick view of latest 5 transactions
- **Pull-to-Refresh**: Refresh all data with a pull-to-refresh gesture

### 2. **Transaction Management**
- **Add Transaction**: Create income or expense entries with:
  - Amount
  - Type (Income/Expense)
  - Category (9 predefined categories with emoji indicators)
  - Date (with date picker)
  - Optional notes
- **View Transactions**: Filterable transaction history
- **Edit Transaction**: Modify existing transactions
- **Delete Transaction**: Remove transactions with confirmation
- **Search & Filter**: 
  - Filter by type (Income/Expense/All)
  - Search by notes/description
- **Transaction Details**: Full transaction information display

### 3. **Insights Screen**
Comprehensive financial analysis featuring:
- **Top Spending Category**: Highlights the category with highest expenses
- **Weekly Comparison**: Compare this week's spending vs. last week with percentage change
- **Category Breakdown**: Detailed breakdown of all spending by category with:
  - Amount spent per category
  - Percentage of total spending
  - Visual progress bars
  - Sorted by amount (highest first)
- **Monthly Trend**: Bar chart showing spending pattern over last 6 months
- **Empty States**: Graceful handling when no transaction data exists

### 4. **Goals/Savings Challenge**
A flexible goal management system:
- **Create Goals**: Set savings goals with:
  - Custom title and description
  - Target amount
  - Target date
- **Track Progress**: Visual progress bars showing:
  - Current vs. target amount
  - Progress percentage
  - Days remaining
- **Multiple Goal States**:
  - **Active Goals**: In-progress savings goals
  - **Achieved Goals**: Completed goals with achievement badge
- **Update Progress**: Quick add-progress feature to update goal completion
- **Goal Management**: Edit or delete goals
- **Monthly Goal**: Specially highlighted current month's goal on home screen

### 5. **User Experience**
- **Smooth Navigation**: Bottom navigation with 4 main sections (Home, Transactions, Insights, Goals)
- **Responsive Design**: Adapts to different screen sizes
- **Loading States**: Smooth loading indicators during data operations
- **Error Handling**: User-friendly error messages with retry options
- **Empty States**: Helpful empty state screens with action buttons
- **Visual Feedback**: Snackbars for confirmations and feedback

## 🏗️ Architecture

### Clean Architecture Implementation

The app follows Clean Architecture principles with clear separation of concerns:

```
lib/
├── core/                          # Core layer - reusable utilities and constants
│   ├── constants/
│   │   └── app_constants.dart    # App-wide constants, strings, categories
│   ├── errors/
│   │   ├── exceptions.dart       # Custom exceptions
│   │   └── failure.dart          # Failure classes for error handling
│   └── utils/
│       ├── app_logger.dart       # Logging utility
│       ├── result.dart           # Result type for success/failure handling
│       └── service_locator.dart  # Dependency injection setup (GetIt)
│
├── data/                          # Data layer - implementation of repositories
│   ├── datasources/
│   │   ├── database_helper.dart           # SQLite database initialization
│   │   ├── transaction_local_data_source.dart  # Transaction database operations
│   │   └── goal_local_data_source.dart        # Goal database operations
│   ├── models/
│   │   ├── transaction_model.dart   # Transaction model with JSON serialization
│   │   └── goal_model.dart          # Goal model with JSON serialization
│   └── repositories/
│       ├── transaction_repository_impl.dart  # Transaction repository implementation
│       └── goal_repository_impl.dart         # Goal repository implementation
│
├── domain/                        # Domain layer - business logic
│   ├── entities/
│   │   ├── transaction.dart      # Transaction entity
│   │   └── goal.dart             # Goal entity
│   ├── repositories/
│   │   ├── transaction_repository.dart  # Transaction repository interface
│   │   └── goal_repository.dart         # Goal repository interface
│   └── usecases/
│       ├── transaction_usecases.dart   # Transaction use cases (GetAllTransactions, AddTransaction, etc.)
│       └── goal_usecases.dart          # Goal use cases (GetAllGoals, AddGoal, etc.)
│
└── presentation/                  # Presentation layer - UI and state management
    ├── pages/
    │   ├── home_screen.dart              # Home dashboard
    │   ├── transaction_screen.dart       # Transaction list and form
    │   ├── insights_screen.dart          # Insights and analytics
    │   └── goals_screen.dart             # Goals management
    ├── providers/
    │   ├── transaction_provider.dart     # Transaction state management (Provider pattern)
    │   └── goal_provider.dart            # Goal state management (Provider pattern)
    └── widgets/
        └── common_widgets.dart           # Reusable UI widgets

main.dart                          # App entry point with routing
```

### Data Flow Architecture

```
Presentation Layer (UI)
        ↓
     Provider (State Management)
        ↓
    Use Cases (Business Logic)
        ↓
   Repositories (Interface)
        ↓
   Repository Implementation
        ↓
   Data Sources (Database)
        ↓
    SQLite Database
```

### Key Architecture Principles

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Dependency Inversion**: High-level modules depend on abstractions
3. **Testability**: Business logic is decoupled from UI and framework
4. **Reusability**: Common components and utilities are centralized
5. **Scalability**: Easy to add new features or modify existing ones

## 🛠️ State Management

### Provider Pattern
- Uses `provider` package for reactive state management
- Two main notifiers:
  - `TransactionNotifier`: Manages transaction state and operations
  - `GoalNotifier`: Manages goal state and operations
- Proper separation of concerns with ChangeNotifier

## 💾 Data Persistence

### SQLite Database
- Local-first approach for offline functionality
- Two main tables:
  1. **transactions**: Stores all transaction records
  2. **goals**: Stores all savings goals
- Indexed columns for better query performance
- Migration support for future schema updates

### Database Features
- CRUD operations for both transactions and goals
- Complex queries for filtering and analytics
- Aggregate functions for calculating totals and summaries

## 📦 Dependencies

### Core Dependencies
- `flutter`: UI framework
- `provider`: ^6.4.0 - State management
- `get_it`: ^7.6.0 - Service locator for dependency injection
- `sqflite`: ^2.3.0 - SQLite database
- `path`: ^1.8.3 - File path manipulation
- `intl`: ^0.19.0 - Internationalization and date formatting
- `uuid`: ^4.0.0 - UUID generation
- `fl_chart`: ^0.68.0 - Charts and visualization
- `equatable`: ^2.0.5 - Equality comparisons
- `json_annotation`: ^4.8.1 - JSON serialization metadata
- `gap`: ^3.0.1 - Consistent spacing widget

### Dev Dependencies
- `build_runner`: ^2.4.8 - Code generation
- `json_serializable`: ^6.8.0 - JSON serialization code generation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- iOS or Android development environment

### Installation

1. **Clone the repository**
   ```bash
   cd finmate
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Code generation** (for JSON serialization if needed)
   ```bash
   flutter pub run build_runner build
   ```

2. **Format code**
   ```bash
   flutter format lib/
   ```

3. **Run analysis**
   ```bash
   flutter analyze
   ```

## 📱 Screen Navigation

### Bottom Navigation Bar
1. **Home** - Dashboard with summary and recent activity
2. **Transactions** - Full transaction management
3. **Insights** - Analytics and spending patterns
4. **Goals** - Savings goals tracking

### Key Routes
- `/transactions` - Transaction list view
- `/add-transaction` - Add new transaction
- `/edit-transaction` - Edit existing transaction
- `/insights` - Insights screen
- `/goals` - Goals overview
- `/add-goal` - Create new goal
- `/edit-goal` - Edit existing goal

## 🎨 Design Philosophy

### User Experience
- **Intuitive**: Natural and familiar interactions
- **Responsive**: Works smoothly on all device sizes
- **Accessible**: Clear labels, good contrast, readable fonts
- **Fast**: Quick loading and operations
- **Forgiving**: Clear confirmations for destructive actions

### Visual Design
- **Material Design 3**: Modern Flutter components
- **Color Scheme**: Blue primary color with complementary accents
- **Typography**: Clear hierarchy with proper font weights
- **Spacing**: Consistent gaps and padding throughout
- **Icons**: Material icons for clear visual indicators

## 📊 Data Models

### Transaction Entity
```dart
class Transaction {
  final String id;
  final double amount;
  final String type;           // 'Income' or 'Expense'
  final String category;       // One of 9 predefined categories
  final DateTime date;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
```

### Goal Entity
```dart
class Goal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final bool achieved;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Computed properties
  double get progressPercentage;        // 0-100
  double get remainingAmount;
  int get daysRemaining;
}
```

## 🔒 Error Handling

### Exception Hierarchy
- `AppException` (base class)
  - `DatabaseException` - Database operation failures
  - `CacheException` - Cache operation failures
  - `ValidationException` - Input validation failures

### Failure Handling
- `Failure` (base class for all failures)
  - `DatabaseFailure`
  - `CacheFailure`
  - `ValidationFailure`
  - `UnknownFailure`

### Result Type
- `Success<T>` - Operation succeeded with data
- `Failure<T>` - Operation failed with failure reason

## 🔄 Transaction Categories

1. 🍔 **Food** - Dining, groceries
2. 🚗 **Transport** - Gas, parking, transit
3. 🎬 **Entertainment** - Movies, games, subscriptions
4. 💡 **Utilities** - Electricity, water, internet
5. 🛍️ **Shopping** - Clothes, general purchases
6. 🏥 **Healthcare** - Medical expenses
7. 💼 **Salary** - Income from employment
8. 📈 **Investment** - Stock, mutual funds, savings
9. 📌 **Other** - Miscellaneous expenses

## 📈 Analytics Features

1. **Top Category Analysis** - Identifies highest spending category
2. **Weekly Trends** - Compares spending week-over-week with changes
3. **Category Breakdown** - Detailed percentage breakdown of all expenses
4. **Monthly Trends** - 6-month spending pattern visualization
5. **Balance Calculations** - Real-time balance = Income - Expenses

## 🚦 App Lifecycle

1. **Initialization**: Service locator setup, dependency injection
2. **Home Loading**: Load all transactions and goals on app start
3. **State Management**: Providers manage and cache state
4. **Database Operations**: SQLite handles persistence
5. **UI Update**: Provider notifies widgets of state changes

## 💡 Assumptions and Decisions

1. **Single User**: App assumes single user (no user accounts/authentication)
2. **Local-First**: All data stored locally on device (no cloud sync)
3. **INR Currency**: Default currency format set to Indian Rupee (can be extended)
4. **Monthly Cycles**: Goals default to 30-day targets
5. **SQLite**: Chosen for simplicity and no dependency on external services
6. **Provider Package**: Chosen for simplicity and ease of learning

## 🔮 Future Enhancements

1. **Dark Mode** - Theme switching support
2. **Budget Limits** - Set monthly budgets by category
3. **Recurring Transactions** - Auto-create regular expenses
4. **Notifications** - Alerts for spending milestones
5. **Data Export** - CSV/PDF export of transactions
6. **Multi-Currency** - Support for different currencies
7. **Cloud Sync** - Firebase integration for data sync
8. **Advanced Filters** - More sophisticated transaction filtering
9. **Custom Categories** - User-defined expense categories
10. **Biometric Lock** - Fingerprint/Face ID security

## 📝 Code Quality

- **Linting**: Follows Flutter lint rules
- **Formatting**: Consistent code formatting with `flutter format`
- **Type Safety**: Strong typing throughout
- **Documentation**: Well-commented code with docstrings
- **Error Handling**: Comprehensive error management
- **Testing**: Foundation for unit and widget testing

## 🐛 Troubleshooting

### Database Issues
- Clear app cache: `flutter clean`
- Delete database manually from device storage
- Rebuild and run: `flutter run`

### State Management Issues
- Ensure providers are properly wrapped in `MultiProvider`
- Check that notifiers are initialized in `setupServiceLocator()`

### UI Issues
- Hot reload may not reflect state changes, use hot restart
- Ensure all assets and dependencies are properly imported

## 📄 License

This project is created for educational and assignment purposes.

## 👤 Author

Built as a personal finance companion assignment demonstrating:
- Clean Architecture principles
- Professional mobile app development practices
- Thoughtful UX/UI design
- Proper code organization and state management
- SQLite database integration
- Error handling and validation

---

**Last Updated**: April 2026
**Version**: 1.0.0
**Status**: Complete and Ready for Evaluation
