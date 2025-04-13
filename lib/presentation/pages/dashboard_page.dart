// lib/presentation/pages/dashboard_page.dart
import 'package:expanse_tracker/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/util/date_time_utils.dart';
import '../../domain/entities/expense.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_event.dart';
import '../bloc/dashboard/dashboard_state.dart';
import '../bloc/expense/expense_bloc.dart';
import '../bloc/expense/expense_event.dart';
import '../bloc/goal/goal_bloc.dart';
import '../bloc/goal/goal_event.dart';
import '../bloc/loan/loan_bloc.dart';
import '../bloc/loan/loan_event.dart';
import '../widgets/chart_widgets.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/goal_list_item.dart';
import '../widgets/loan_list_item.dart';
import '../widgets/summary_card.dart';
import 'add_edit_expense_page.dart';
import 'categories_page.dart';
import 'expenses_page.dart';
import 'goals_page.dart';
import 'loans_page.dart';
import 'settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _loadData();
  }

  void _loadData() {
    // Load categories first
    context.read<CategoryBloc>().add(GetAllCategoriesEvent());

    // Load dashboard data for current month
    context.read<DashboardBloc>().add(
          LoadDashboardDataEvent(month: _selectedMonth),
        );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Widget> pages = [
      _buildDashboardContent(),
      const ExpensesPage(),
      const CategoriesPage(),
      const GoalsPage(),
      const LoansPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(l10n),
        ),
        actions: _buildAppBarActions(l10n),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: l10n.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.money_off),
            label: l10n.expenses,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.category),
            label: l10n.categories,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.flag),
            label: l10n.goals,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance),
            label: l10n.loans,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () => _navigateToAddExpense(context),
              tooltip: l10n.addExpense,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  String _getAppBarTitle(AppLocalizations l10n) {
    switch (_selectedIndex) {
      case 0:
        return l10n.dashboard;
      case 1:
        return l10n.expenses;
      case 2:
        return l10n.categories;
      case 3:
        return l10n.goals;
      case 4:
        return l10n.loans;
      case 5:
        return l10n.settings;
      default:
        return l10n.appTitle;
    }
  }

  List<Widget> _buildAppBarActions(AppLocalizations l10n) {
    if (_selectedIndex == 0) {
      return [
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectMonth(context),
          tooltip: 'Select Month',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadData,
          tooltip: 'Refresh',
        ),
      ];
    }
    return [];
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null && picked != _selectedMonth) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month, 1);
        context.read<DashboardBloc>().add(
              LoadDashboardDataEvent(month: _selectedMonth),
            );
      });
    }
  }

  void _navigateToAddExpense(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditExpensePage(),
      ),
    );

    if (result == true) {
      // Refresh expenses and dashboard when a new expense is added
      context.read<ExpenseBloc>().add(
            GetExpensesByDateRangeEvent(
              start: DateTimeUtils.getStartOfMonth(_selectedMonth),
              end: DateTimeUtils.getEndOfMonth(_selectedMonth),
            ),
          );

      context.read<DashboardBloc>().add(
            LoadDashboardDataEvent(month: _selectedMonth),
          );
    }
  }

  Widget _buildDashboardContent() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return _buildDashboardData(state);
      },
    );
  }

  Widget _buildDashboardData(DashboardState state) {
    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () async {
        _loadData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Summary Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: l10n.thisMonth,
                      amount: state.totalMonthlyExpense,
                      icon: Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SummaryCard(
                      title: l10n.monthlyAverage,
                      amount: state.averageMonthlyExpense,
                      icon: Icons.trending_up,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Monthly Expenses Chart
            if (state.currentMonthExpenses.isNotEmpty)
              MonthlyExpenseBarChart(
                expenses: state.currentMonthExpenses,
                month: _selectedMonth,
              )
            else
              _buildNoDataWidget(l10n.noData),

            const SizedBox(height: 24),

            // Category Pie Chart
            if (state.expensesByCategory.isNotEmpty)
              CategoryPieChart(
                expensesByCategory: state.expensesByCategory,
              )
            else
              _buildNoDataWidget(l10n.noData),

            const SizedBox(height: 24),

            // Recent Expenses
            _buildRecentExpenses(state),

            const SizedBox(height: 24),

            // Active Goals
            _buildActiveGoals(state),

            const SizedBox(height: 24),

            // Pending Loans
            _buildPendingLoans(state),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataWidget(String message) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentExpenses(DashboardState state) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.recentExpenses,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1; // Navigate to Expenses tab
                  });
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, categoryState) {
            if (categoryState is CategoriesLoaded) {
              final expenses = state.currentMonthExpenses;
              if (expenses.isEmpty) {
                return _buildNoDataWidget(l10n.noData);
              }

              // Sort expenses by date (newest first) and limit to 5
              final sortedExpenses = List<Expense>.from(expenses)
                ..sort((a, b) => b.date.compareTo(a.date));
              final recentExpenses = sortedExpenses.take(5).toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentExpenses.length,
                itemBuilder: (context, index) {
                  final expense = recentExpenses[index];
                  final category = categoryState.categories.firstWhere(
                    (cat) => cat.id == expense.categoryId,
                    orElse: () => const Category(
                      id: 'unknown',
                      name: 'Unknown',
                      color: Color(0xFF9E9E9E),
                      icon: Icons.help_outline,
                    ),
                  );

                  return ExpenseListItem(
                    expense: expense,
                    category: category,
                    onTap: () {
                      // Navigate to expense details or edit expense
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditExpensePage(
                            expense: expense,
                          ),
                        ),
                      ).then((result) {
                        if (result == true) {
                          _loadData();
                        }
                      });
                    },
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }

  Widget _buildActiveGoals(DashboardState state) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.activeGoals,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 3; // Navigate to Goals tab
                  });
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (state.activeGoals.isEmpty)
          _buildNoDataWidget(l10n.noData)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                state.activeGoals.length > 3 ? 3 : state.activeGoals.length,
            itemBuilder: (context, index) {
              final goal = state.activeGoals[index];
              return GoalListItem(
                goal: goal,
                onTap: () {
                  // Navigate to goal details or edit goal
                  context.read<GoalBloc>().add(GetAllGoalsEvent());
                  setState(() {
                    _selectedIndex = 3; // Navigate to Goals tab
                  });
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildPendingLoans(DashboardState state) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.pendingLoans,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 4; // Navigate to Loans tab
                  });
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (state.pendingLoans.isEmpty)
          _buildNoDataWidget(l10n.noData)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                state.pendingLoans.length > 3 ? 3 : state.pendingLoans.length,
            itemBuilder: (context, index) {
              final loan = state.pendingLoans[index];
              return LoanListItem(
                loan: loan,
                onTap: () {
                  // Navigate to loan details or edit loan
                  context.read<LoanBloc>().add(GetAllLoansEvent());
                  setState(() {
                    _selectedIndex = 4; // Navigate to Loans tab
                  });
                },
              );
            },
          ),
      ],
    );
  }
}
