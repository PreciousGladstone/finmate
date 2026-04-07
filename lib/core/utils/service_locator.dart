import 'package:get_it/get_it.dart';
import 'package:finmate/core/network/http_client.dart';
import 'package:finmate/data/datasources/database_helper.dart';
import 'package:finmate/data/datasources/goal_local_data_source.dart';
import 'package:finmate/data/datasources/transaction_local_data_source.dart';
import 'package:finmate/data/datasources/goal_remote_data_source.dart';
import 'package:finmate/data/datasources/goal_remote_data_source_impl.dart';
import 'package:finmate/data/datasources/transaction_remote_data_source.dart';
import 'package:finmate/data/datasources/transaction_remote_data_source_impl.dart';
import 'package:finmate/data/repositories/goal_repository_impl.dart';
import 'package:finmate/data/repositories/transaction_repository_impl.dart';
import 'package:finmate/domain/repositories/goal_repository.dart';
import 'package:finmate/domain/repositories/transaction_repository.dart';
import 'package:finmate/domain/usecases/goal_usecases.dart';
import 'package:finmate/domain/usecases/transaction_usecases.dart';

/// Service locator for dependency injection
final getIt = GetIt.instance;

/// Setup dependency injection
void setupServiceLocator() {
  // Network
  getIt.registerSingleton<HttpClient>(HttpClient());

  // Database
  getIt.registerSingleton<DatabaseHelper>(DatabaseHelper());

  // Local Data Sources
  getIt.registerSingleton<TransactionLocalDataSource>(
    TransactionLocalDataSourceImpl(databaseHelper: getIt<DatabaseHelper>()),
  );

  getIt.registerSingleton<GoalLocalDataSource>(
    GoalLocalDataSourceImpl(databaseHelper: getIt<DatabaseHelper>()),
  );

  // Remote Data Sources
  getIt.registerSingleton<TransactionRemoteDataSource>(
    TransactionRemoteDataSourceImpl(getIt<HttpClient>()),
  );

  getIt.registerSingleton<GoalRemoteDataSource>(
    GoalRemoteDataSourceImpl(getIt<HttpClient>()),
  );

  // Repositories
  getIt.registerSingleton<TransactionRepository>(
    TransactionRepositoryImpl(localDataSource: getIt<TransactionLocalDataSource>()),
  );

  getIt.registerSingleton<GoalRepository>(
    GoalRepositoryImpl(localDataSource: getIt<GoalLocalDataSource>()),
  );

  // Use Cases - Transactions
  getIt.registerSingleton<GetAllTransactionsUseCase>(
    GetAllTransactionsUseCase(repository: getIt<TransactionRepository>()),
  );

  getIt.registerSingleton<GetTransactionsByTypeUseCase>(
    GetTransactionsByTypeUseCase(repository: getIt<TransactionRepository>()),
  );

  getIt.registerSingleton<GetTransactionsByDateRangeUseCase>(
    GetTransactionsByDateRangeUseCase(repository: getIt<TransactionRepository>()),
  );

  getIt.registerSingleton<GetTransactionsByCategoryUseCase>(
    GetTransactionsByCategoryUseCase(repository: getIt<TransactionRepository>()),
  );

  getIt.registerSingleton<SearchTransactionsUseCase>(
    SearchTransactionsUseCase(repository: getIt<TransactionRepository>()),
  );

  getIt.registerSingleton<AddTransactionUseCase>(
    AddTransactionUseCase(repository: getIt<TransactionRepository>()),
  );

  getIt.registerSingleton<UpdateTransactionUseCase>(
    UpdateTransactionUseCase(repository: getIt<TransactionRepository>()),
  );

  getIt.registerSingleton<DeleteTransactionUseCase>(
    DeleteTransactionUseCase(repository: getIt<TransactionRepository>()),
  );

  getIt.registerSingleton<GetCurrentBalanceUseCase>(
    GetCurrentBalanceUseCase(repository: getIt<TransactionRepository>()),
  );

  getIt.registerSingleton<GetTotalIncomeUseCase>(
    GetTotalIncomeUseCase(repository: getIt<TransactionRepository>()),
  );

  getIt.registerSingleton<GetTotalExpenseUseCase>(
    GetTotalExpenseUseCase(repository: getIt<TransactionRepository>()),
  );

  // Use Cases - Goals
  getIt.registerSingleton<GetAllGoalsUseCase>(
    GetAllGoalsUseCase(repository: getIt<GoalRepository>()),
  );

  getIt.registerSingleton<GetActiveGoalsUseCase>(
    GetActiveGoalsUseCase(repository: getIt<GoalRepository>()),
  );

  getIt.registerSingleton<GetAchievedGoalsUseCase>(
    GetAchievedGoalsUseCase(repository: getIt<GoalRepository>()),
  );

  getIt.registerSingleton<AddGoalUseCase>(
    AddGoalUseCase(repository: getIt<GoalRepository>()),
  );

  getIt.registerSingleton<UpdateGoalUseCase>(
    UpdateGoalUseCase(repository: getIt<GoalRepository>()),
  );

  getIt.registerSingleton<DeleteGoalUseCase>(
    DeleteGoalUseCase(repository: getIt<GoalRepository>()),
  );

  getIt.registerSingleton<UpdateGoalProgressUseCase>(
    UpdateGoalProgressUseCase(repository: getIt<GoalRepository>()),
  );
}
