import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'data/datasources/category_datasource.dart';
import 'data/datasources/expense_datasource.dart';
import 'data/datasources/goal_datasource.dart';
import 'data/datasources/loan_datasource.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'data/repositories/goal_repository_impl.dart';
import 'data/repositories/loan_repository_impl.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/repositories/expense_repository.dart';
import 'domain/repositories/goal_repository.dart';
import 'domain/repositories/loan_repository.dart';
import 'domain/usecases/category/add_category.dart';
import 'domain/usecases/category/delete_category.dart';
import 'domain/usecases/category/get_all_categories.dart';
import 'domain/usecases/category/update_category.dart';
import 'domain/usecases/expense/add_expense.dart';
import 'domain/usecases/expense/delete_expense.dart';
import 'domain/usecases/expense/get_expenses_by_category.dart';
import 'domain/usecases/expense/get_expenses_by_date_range.dart';
import 'domain/usecases/expense/update_expense.dart';
import 'domain/usecases/goal/add_goal.dart';
import 'domain/usecases/goal/delete_goal.dart';
import 'domain/usecases/goal/get_all_goals.dart';
import 'domain/usecases/goal/update_goal.dart';
import 'domain/usecases/loan/add_loan.dart';
import 'domain/usecases/loan/delete_loan.dart';
import 'domain/usecases/loan/get_all_loans.dart';
import 'domain/usecases/loan/get_loans_with_reminders.dart';
import 'domain/usecases/loan/update_loan.dart';
import 'presentation/bloc/app_settings/app_settings_bloc.dart';
import 'presentation/bloc/category/category_bloc.dart';
import 'presentation/bloc/dashboard/dashboard_bloc.dart';
import 'presentation/bloc/expense/expense_bloc.dart';
import 'presentation/bloc/goal/goal_bloc.dart';
import 'presentation/bloc/loan/loan_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! Data sources
  sl.registerLazySingleton<CategoryDataSource>(
      () => CategoryDataSourceImpl(firestore: sl()));
  sl.registerLazySingleton<ExpenseDataSource>(
      () => ExpenseDataSourceImpl(firestore: sl()));
  sl.registerLazySingleton<GoalDataSource>(
      () => GoalDataSourceImpl(firestore: sl()));
  sl.registerLazySingleton<LoanDataSource>(
      () => LoanDataSourceImpl(firestore: sl()));

  //! Repositories
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(
        dataSource: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl(
        dataSource: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<GoalRepository>(() => GoalRepositoryImpl(
        dataSource: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<LoanRepository>(() => LoanRepositoryImpl(
        dataSource: sl(),
        networkInfo: sl(),
      ));

  //! Use cases
  // Category
  sl.registerLazySingleton(() => GetAllCategories(sl()));
  sl.registerLazySingleton(() => AddCategory(sl()));
  sl.registerLazySingleton(() => UpdateCategory(sl()));
  sl.registerLazySingleton(() => DeleteCategory(sl()));

  // Expense
  sl.registerLazySingleton(() => GetExpensesByDateRange(sl()));
  sl.registerLazySingleton(() => GetExpensesByCategory(sl()));
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => UpdateExpense(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));

  // Goal
  sl.registerLazySingleton(() => GetAllGoals(sl()));
  sl.registerLazySingleton(() => AddGoal(sl()));
  sl.registerLazySingleton(() => UpdateGoal(sl()));
  sl.registerLazySingleton(() => DeleteGoal(sl()));

  // Loan
  sl.registerLazySingleton(() => GetAllLoans(sl()));
  sl.registerLazySingleton(() => GetLoansWithReminders(sl()));
  sl.registerLazySingleton(() => AddLoan(sl()));
  sl.registerLazySingleton(() => UpdateLoan(sl()));
  sl.registerLazySingleton(() => DeleteLoan(sl()));

  //! BLoCs
  sl.registerFactory(() => AppSettingsBloc(sharedPreferences: sl()));
  sl.registerFactory(() => CategoryBloc(
        getAllCategories: sl(),
        addCategory: sl(),
        updateCategory: sl(),
        deleteCategory: sl(),
      ));
  sl.registerFactory(() => ExpenseBloc(
        addExpense: sl(),
        updateExpense: sl(),
        deleteExpense: sl(),
        getExpensesByCategory: sl(),
        getExpensesByDateRange: sl(),
      ));
  sl.registerFactory(() => GoalBloc(
        getAllGoals: sl(),
        addGoal: sl(),
        updateGoal: sl(),
        deleteGoal: sl(),
      ));
  sl.registerFactory(() => LoanBloc(
        getAllLoans: sl(),
        getLoansWithReminders: sl(),
        addLoan: sl(),
        updateLoan: sl(),
        deleteLoan: sl(),
      ));
  sl.registerFactory(() => DashboardBloc(
        getExpensesByDateRange: sl(),
        getAllCategories: sl(),
        getAllGoals: sl(),
        getAllLoans: sl(),
      ));
}
