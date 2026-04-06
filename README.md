# FinMate - Personal Finance Companion

A mobile app for tracking daily financial habits, monitoring spending patterns, managing goals, and gaining insights into personal money management. Built with **Flutter**, **Riverpod** state management, and **Clean Architecture** principles.

## 🎯 Features

### 1. **Home Dashboard**
- **Financial Summary Cards**: Current balance, total income, and total expenses at a glance
- **Active Monthly Goal**: Visual progress tracking for current month's savings goal
- **Spending by Category**: Pie chart showing expense breakdown across all categories
- **Recent Transactions**: Quick view of latest transactions sorted by date (newest first)
- **Pull-to-Refresh**: Refresh all data with a pull-to-refresh gesture

### 2. **Transaction Management**
- **Add Transaction**: Create income or expense entries with:
  - Amount
  - Type (Income/Expense) 
  - Category (9 predefined categories with emoji indicators)
  - Date picker for flexible date selection
  - Optional notes and descriptions
- **View All Transactions**: Complete sortable transaction history
- **Edit Transaction**: Modify existing transactions easily
- **Delete Transaction**: Remove transactions with confirmation dialog
- **Smart Sorting**: Transactions sorted by date (newest first) at provider level
- **Transaction Types**: Income and Expense with distinct categorization

### 3. **Insights & Analytics**
Comprehensive financial analysis dashboard:
- **Top Spending Category**: Visual highlight of highest spending category
- **Weekly Spending Comparison**: This week vs. last week with percentage change indicator
- **Category Breakdown**: Detailed analysis of all spending by category with:
  - Amount spent per category
  - Percentage of total spending
  - Sorted by amount (highest first)
- **Monthly Trend Chart**: Smooth line chart showing spending pattern over last 6 months with:
  - Dynamic y-axis scaling (min to max actual spending)
  - Interactive tooltips showing exact spending amounts
  - Gradient fill and smooth curves for modern appearance
- **Empty State Handling**: Graceful messages when no transaction data exists

### 4. **Goals & Savings Tracking**
A comprehensive goal management system:
- **Create Goals**: Set flexible savings goals with:
  - Custom goal title and description
  - Target amount to save
  - Target completion date
- **Track Progress**: Visual progress indicators showing:
  - Current savings vs. target amount
  - Progress percentage (0-100%)
  - Days remaining until deadline
- **Goal Status Organization**:
  - **Active Tab**: In-progress savings goals with progress tracking
  - **Completed Tab**: Achieved goals with achievement date
- **Update Goal Progress**: Increment current amount toward goal
- **Goal Management**: Edit goal details or delete goals entirely

### 5. **User Experience**
- **Navigation**: Bottom tab navigation with 4 main sections (Home, Transactions, Insights, Goals)
- **Responsive Design**: Seamless adaptation to different screen sizes
- **Loading States**: Smooth async loading indicators during data operations
- **Error Handling**: User-friendly error messages with recovery options
- **Empty States**: Helpful empty state screens with clear messaging
- **Visual Feedback**: Snackbar notifications for confirmations and user actions

## 🏗️ Architecture

### Clean Architecture Implementation

The app follows Clean Architecture principles with clear separation of concerns across three layers:

```
lib/
├── core/                              # Core layer - reusable utilities and constants
│   ├── constants/
│   │   └── app_constants.dart        # App-wide constants, transaction categories, strings
│   ├── themes/
│   │   └── app_theme.dart            # Color schemes, text styles, Material 3 theme
│   ├── router/
│   │   └── app_router.dart           # Navigation routes 
│   └── utils/
│       ├── app_logger.dart           # debugPrint-based logging utility
│       ├── service_locator.dart      # GetIt dependency injection setup
│       └── helpers.dart              # Utility helper functions
│
├── domain/                             # Domain layer - business logic (framework-independent)
│   ├── entities/
│   │   ├── transaction.dart          # Transaction entity (business model)
│   │   └── goal.dart                 # Goal entity (business model)
│   ├── repositories/
│   │   ├── transaction_repository.dart     # Transaction repository interface
│   │   └── goal_repository.dart            # Goal repository interface
│   └── usecases/
│       ├── transaction_usecases.dart      # Transaction use cases (Get, Add, Update, Delete)
│       └── goal_usecases.dart             # Goal use cases (Get, Add, Update, Delete)
│
├── data/                               # Data layer - implementation of repositories
│   ├── datasources/
│   │   ├── database_helper.dart           # SQLite database initialization & schema
│   │   ├── transaction_local_data_source.dart  # Transaction database operations
│   │   └── goal_local_data_source.dart        # Goal database operations
│   ├── models/
│   │   ├── transaction_model.dart      # Transaction with JSON serialization
│   │   └── goal_model.dart             # Goal with JSON serialization
│   └── repositories/
│       ├── transaction_repository_impl.dart  # Implements TransactionRepository
│       └── goal_repository_impl.dart         # Implements GoalRepository
│
└── presentation/                       # Presentation layer - UI and state management
    ├── features/
    │   ├── home/
    │   │   ├── pages/
    │   │   │   └── home_screen.dart          # Dashboard with summary & recent transactions
    │   │   └── widgets/
    │   │       ├── summary_card.dart         # Balance/Income/Expense cards
    │   │       ├── category_chart.dart       # Pie chart for spending by category
    │   │       └── recent_transactions_widget.dart  # Recent transactions list
    │   │
    │   ├── transactions/
    │   │   ├── pages/
    │   │   │   ├── transaction_list_screen.dart    # All transactions
    │   │   │   ├── add_transaction_screen.dart     # Add new transaction
    │   │   │   └── edit_transaction_screen.dart    # Edit existing transaction
    │   │   └── widgets/
    │   │       ├── transaction_list_view.dart      # Reusable transaction list
    │   │       ├── transaction_form.dart           # Shared form widget
    │   │       └── category_selector.dart          # Category selection widget
    │   │
    │   ├── insights/
    │   │   ├── pages/
    │   │   │   └── insights_screen.dart            # Analytics dashboard
    │   │   └── widgets/
    │   │       ├── monthly_trend_widget.dart       # Main chart orchestrator
    │   │       ├── chart_header.dart               # Chart title and info
    │   │       ├── chart_subtitle.dart             # Chart description
    │   │       ├── spending_line_chart.dart        # Line chart implementation
    │   │       ├── top_category_card.dart          # Highest spending display
    │   │       ├── weekly_comparison_card.dart     # Week-over-week comparison
    │   │       └── category_breakdown_widget.dart  # Category breakdown table
    │   │
    │   ├── goals/
    │   │   ├── pages/
    │   │   │   ├── goals_screen.dart               # Goals overview with tabs
    │   │   │   ├── add_goal_screen.dart            # Create new goal
    │   │   │   └── edit_goal_screen.dart           # Edit existing goal
    │   │   └── widgets/
    │   │       ├── goal_card.dart                  # Goal progress display
    │   │       ├── goal_form.dart                  # Shared goal form
    │   │       └── active_completed_tabs.dart      # Tab switcher
    │   │
    │   └── shared/
    │       ├── providers/
    │       │   ├── transaction_provider.dart       # Transaction state (AsyncNotifier)
    │       │   └── goal_provider.dart              # Goal state (AsyncNotifier)
    │       └── widgets/
    │           └── common_widgets.dart             # Reusable UI components
    │
    └── main.dart                       # App entry point with Riverpod setup

```

### Data Flow Architecture

```
UI Widget (Pages/Screens)
          ↓
   Riverpod Provider (State Management)
          ↓
    Use Case (Business Logic)
          ↓
Repository Interface (Abstraction)
          ↓
Repository Implementation
          ↓
Local Data Source (SQLite)
          ↓
   SQLite Database (finmate.db)
```

### Key Architecture Principles

1. **Separation of Concerns**: Each layer has a single, well-defined responsibility
2. **Dependency Inversion**: High-level modules depend on abstractions (interfaces), not concrete implementations
3. **Testability**: Business logic is completely decoupled from UI and framework specifics
4. **Reusability**: Common components, utilities, and providers are centralized
5. **Scalability**: Easy to add new features or modify existing ones without affecting other layers
6. **Single Source of Truth**: Data sorted at provider level, not repeated in widgets

## 🛠️ State Management

### Riverpod Pattern
- Uses `flutter_riverpod` (2.4.0) for reactive, type-safe state management
- **AsyncNotifier** for handling async operations (loading, error, data states)
- Two main state providers:
  - `TransactionProvider`: Manages all transaction state and operations
    - Async fetching from repository
    - Real-time transaction list updates
    - Transactions sorted by date (newest first) at provider level
  - `GoalProvider`: Manages all goal state and operations
    - Async goal fetching and updates
    - Real-time goal progress tracking
- **Separation Principle**: Sort/filter logic handled at provider level, not in widgets
- **Type Safety**: Full type safety with Riverpod's compile-time checking
- **Auto-caching**: Providers cache data and only refresh when dependencies change

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

### Core State Management & Dependency Injection
- `flutter_riverpod`: ^2.4.0 - Type-safe, reactive state management with AsyncNotifier
- `get_it`: ^7.6.0 - Service locator for dependency injection

### Database & Persistence
- `sqflite`: ^2.3.0 - SQLite database with async operations
- `path`: ^1.8.3 - File path manipulation for database location


### UI & Visualization
- `fl_chart`: ^0.68.0 - Beautiful charts and graphs (pie charts, line charts)
- `flutter_svg`: ^2.2.3 - SVG asset rendering
- `google_fonts`: ^8.0.2 - Custom Google Fonts typography

### Data & Utilities
- `uuid`: ^4.0.0 - UUID generation for unique IDs
- `intl`: ^0.19.0 - Internationalization and date/currency formatting
- `equatable`: ^2.0.5 - Simplify equality comparisons for entities

### Development Dependencies
- `build_runner`: ^2.4.8 - Code generation and building
- `json_serializable`: ^6.8.0 - JSON serialization code generation
- `flutter_lints`: ^3.0.0 - Dart linting rules

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- iOS or Android development environment configured

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/PreciousGladstone/finmate.git
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

1. **Check for lint issues**
   ```bash
   flutter analyze
   ```

2. **Format code**
   ```bash
   dart format lib/
   ```

3. **Generate code (if needed)**
   ```bash
   flutter pub run build_runner build
   ```

## 📱 Navigation & Screens

### Bottom Navigation Tabs
1. **Home** - Dashboard with balance, income, expenses, savings goal, category chart, and recent transactions
2. **Transactions** - Full transaction management with list, add, edit, and delete functionality
3. **Insights** - Analytics dashboard with spending trends, category breakdown, and monthly chart
4. **Goals** - Savings goal management with active/completed tabs and progress tracking

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

The app supports 9 transaction categories with emoji icons:

1. 🍔 **Food** - Dining, groceries, restaurants
2. 🚗 **Transport** - Gas, fuel, parking, public transit, car maintenance
3. 🎬 **Entertainment** - Movies, games, music, subscriptions, hobbies
4. 💡 **Utilities** - Electricity, water, internet, phone bills
5. 🛍️ **Shopping** - Clothes, accessories, general shopping
6. 🏥 **Healthcare** - Medical expenses, doctor visits, medicines
7. 💼 **Salary** - Income from employment or main income source
8. 📈 **Investment** - Stock purchases, mutual funds, savings
9. 📌 **Other** - Miscellaneous expenses that don't fit other categories

## 📈 Analytics Features

1. **Top Category Analysis** - Identifies and displays the highest spending category
2. **Weekly Trends** - Week-over-week spending comparison with percentage change
3. **Category Breakdown** - Detailed table showing percentage and amount per category (sorted by highest first)
4. **Monthly Trends** - Modern smooth line chart visualization of 6-month spending pattern with:
   - Dynamic y-axis scaling (min actual value → max actual value, not fixed 0-X)
   - Interactive tooltips showing exact spending amounts
   - Smooth splined curves (curveSmoothness: 0.4) for modern appearance
   - Gradient fill from primary color to transparent
   - Dashed gridlines for easier reading
5. **Balance Calculations** - Real-time balance = Total Income - Total Expenses
6. **Smart Sorting** - All lists sorted by date (newest first) at provider level for consistency

## 🚦 App Lifecycle

1. **Initialization**: Service locator setup, dependency injection
2. **Home Loading**: Load all transactions and goals on app start
3. **State Management**: Providers manage and cache state
4. **Database Operations**: SQLite handles persistence
5. **UI Update**: Provider notifies widgets of state changes

## 💡 Key Architecture Decisions

1. **Riverpod for State Management**: Chosen for type safety, excellent async handling, and modern reactive patterns
2. **Local-First Architecture**: All data stored locally on device (no cloud backend) for simplicity and offline functionality
3. **SQLite Database**: Lightweight, zero-dependency persistence perfect for local data
4. **Clean Architecture**: Three-layer separation ensures testability, maintainability, and scalability
5. **Use Cases**: Business logic encapsulated in dedicated classes for reusability and single responsibility
6. **Provider-Level Sorting**: All list sorting happens at provider level (not widgets) to maintain single source of truth
7. **Single User**: App assumes one user per device (no multi-user or authentication system)
8. **Defensive Null Handling**: Optional fields properly handled (e.g., transaction notes, goal descriptions)
9. **Dynamic Chart Scaling**: Chart y-axis scales to actual data range (min→max) rather than fixed values

## 🔮 Potential Future Enhancements

1. **Dark Mode** - System-wide theme switching support
2. **Budget Limits** - Set and track category-wise monthly budgets
3. **Recurring Transactions** - Auto-create regular income/expense entries
4. **Push Notifications** - Alerts for spending milestones and goal reminders
5. **Data Export** - CSV or PDF export of transaction history
6. **Multi-Currency Support** - Handle different currencies beyond INR
7. **Cloud Sync** - Firebase Firestore integration for backup and sync
8. **Advanced Filtering** - More sophisticated date range and category filtering
9. **Custom Categories** - User-defined expense and income categories
10. **Biometric Lock** - Fingerprint or Face ID security layer

## 📝 Code Quality & Production Readiness

### Logging Best Practices
- **debugPrint Instead of print()**: All logging uses `debugPrint()` which is tree-shaken in release builds (zero overhead)
- **Structured Logging**: AppLogger utility provides consistent logging format
- **Files Updated**: database_helper, goal_local_data_source, transaction_local_data_source, transaction_provider, goal_provider (28+ logging statements)

### Code Organization
- **Linting**: Follows Flutter lint rules via `flutter analyze`
- **Formatting**: Consistent code formatting with `dart format`
- **Type Safety**: Strong typing throughout codebase
- **Documentation**: Well-commented code with clear intent
- **Error Handling**: Comprehensive error management and user feedback
- **Single Responsibility**: Each widget, provider, and class has one clear purpose

### Active Maintenance
- ✅ Zero compilation errors
- ✅ Clean architecture adherence
- ✅ Production-safe logging
- ✅ Proper widget extraction and composition
- ✅ Smart caching at provider level

## 🐛 Troubleshooting

### Database Issues
- Clear app cache: `flutter clean`
- Delete database manually from device storage
- Rebuild and run: `flutter run`

### State Management Issues
- Check that notifiers are initialized in `setupServiceLocator()`

### UI Issues
- Hot reload may not reflect state changes, use hot restart
- Ensure all assets and dependencies are properly imported

## 📄 License

This project is created for educational and practical purposes.

---

## 👤 Author

**FinMate** is a comprehensive personal finance management application demonstrating:
-  Professional Clean Architecture implementation
-  Modern Riverpod state management patterns
-  SQLite database integration with proper CRUD operations
-  Beautiful, responsive UI with Material Design 3
-  Production-ready code with proper error handling and logging
-  Real-world financial analytics and insights
-  Scalable, maintainable codebase structure

**Repository**: [github.com/PreciousGladstone/finmate](https://github.com/PreciousGladstone/finmate)

---

**Last Updated**: April 2026  
**Version**: 1.0.0  
