// lib/presentation/pages/expenses_page.dart
import 'package:collection/collection.dart';
import 'package:expanse_tracker/presentation/bloc/expense/filter_bloc.dart';
import 'package:expanse_tracker/presentation/bloc/expense/filter_event.dart';
import 'package:expanse_tracker/presentation/bloc/expense/filter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/util/date_time_utils.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../bloc/expense/expense_bloc.dart';
import '../bloc/expense/expense_event.dart';
import '../bloc/expense/expense_state.dart';
import '../widgets/expense_list_item.dart';
import 'add_edit_expense_page.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterBloc(),
      child: const _ExpensesView(),
    );
  }
}

class _ExpensesView extends StatefulWidget {
  const _ExpensesView();

  @override
  State<_ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<_ExpensesView> {
  @override
  void initState() {
    super.initState();

    // Load categories if not already loaded
    final categoryState = context.read<CategoryBloc>().state;
    if (categoryState is! CategoriesLoaded) {
      context.read<CategoryBloc>().add(GetAllCategoriesEvent());
    }

    // Load expenses for the current month
    _loadExpenses();
  }

  void _loadExpenses() {
    final filterState = context.read<FilterBloc>().state;

    if (filterState.selectedCategoryId != null) {
      context.read<ExpenseBloc>().add(
            GetExpensesByCategoryEvent(filterState.selectedCategoryId!),
          );
    } else {
      context.read<ExpenseBloc>().add(
            GetExpensesByDateRangeEvent(
              start: filterState.startDate,
              end: filterState.endDate,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FilterBloc, FilterState>(
      listener: (context, state) {
        _loadExpenses();
      },
      child: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ExpensesLoaded) {
                  return _buildExpenseList(state.expenses);
                } else if (state is ExpenseOperationFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadExpenses,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: ElevatedButton(
                      onPressed: _loadExpenses,
                      child: const Text('Load Expenses'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, filterState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDateRangeSelector(l10n, filterState),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      _showFilterBottomSheet(context);
                    },
                    tooltip: 'Filter',
                  ),
                  IconButton(
                    icon: Icon(filterState.sortAscending
                        ? Icons.arrow_upward
                        : Icons.arrow_downward),
                    onPressed: () {
                      context
                          .read<FilterBloc>()
                          .add(ToggleSortDirectionEvent());
                    },
                    tooltip:
                        filterState.sortAscending ? 'Ascending' : 'Descending',
                  ),
                ],
              ),
              if (filterState.selectedCategoryId != null)
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, categoryState) {
                    if (categoryState is CategoriesLoaded) {
                      final category = categoryState.categories.firstWhere(
                        (cat) => cat.id == filterState.selectedCategoryId,
                        orElse: () => const Category(
                          id: 'unknown',
                          name: 'Unknown',
                          color: Color(0xFF9E9E9E),
                          icon: Icons.help_outline,
                        ),
                      );

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Chip(
                          label: Text(
                            '${l10n.category}: ${category.name}',
                          ),
                          avatar: Icon(
                            category.icon,
                            color: category.color,
                            size: 16,
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            context.read<FilterBloc>().add(
                                  const SetCategoryFilterEvent(null),
                                );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateRangeSelector(
      AppLocalizations l10n, FilterState filterState) {
    return InkWell(
      onTap: () => _selectDateRange(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${DateTimeUtils.formatDate(filterState.startDate)} - ${DateTimeUtils.formatDate(filterState.endDate)}',
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final filterState = context.read<FilterBloc>().state;
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: DateTimeRange(
        start: filterState.startDate,
        end: filterState.endDate,
      ),
    );

    if (picked != null) {
      context.read<FilterBloc>().add(
            SetDateRangeEvent(
              startDate: picked.start,
              endDate: picked.end,
            ),
          );
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filterBloc = context.read<FilterBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: filterBloc,
          child: BlocBuilder<FilterBloc, FilterState>(
            builder: (context, filterState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Expenses',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Category Filter
                    Text(
                      l10n.category,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, categoryState) {
                        if (categoryState is CategoriesLoaded) {
                          return SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categoryState.categories.length,
                              itemBuilder: (context, index) {
                                final category =
                                    categoryState.categories[index];
                                final isSelected =
                                    filterState.selectedCategoryId ==
                                        category.id;

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(category.name),
                                    selected: isSelected,
                                    avatar: Icon(
                                      category.icon,
                                      color: isSelected
                                          ? Colors.white
                                          : category.color,
                                      size: 20,
                                    ),
                                    selectedColor: category.color,
                                    onSelected: (selected) {
                                      context.read<FilterBloc>().add(
                                            SetCategoryFilterEvent(
                                              selected ? category.id : null,
                                            ),
                                          );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Sort By
                    Text(
                      'Sort By',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Date'),
                          selected: filterState.sortBy == 'date',
                          onSelected: (selected) {
                            if (selected) {
                              context.read<FilterBloc>().add(
                                    const SetSortByEvent('date'),
                                  );
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Amount'),
                          selected: filterState.sortBy == 'amount',
                          onSelected: (selected) {
                            if (selected) {
                              context.read<FilterBloc>().add(
                                    const SetSortByEvent('amount'),
                                  );
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Category'),
                          selected: filterState.sortBy == 'category',
                          onSelected: (selected) {
                            if (selected) {
                              context.read<FilterBloc>().add(
                                    const SetSortByEvent('category'),
                                  );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildExpenseList(List<Expense> expenses) {
    final l10n = AppLocalizations.of(context)!;
    final filterState = context.watch<FilterBloc>().state;

    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.noData),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEditExpensePage(),
                  ),
                ).then((value) {
                  if (value == true) {
                    _loadExpenses();
                  }
                });
              },
              child: Text(l10n.addExpense),
            ),
          ],
        ),
      );
    }

    // Sort expenses based on selected criteria
    final sortedExpenses = List<Expense>.from(expenses);

    switch (filterState.sortBy) {
      case 'date':
        sortedExpenses.sort((a, b) => filterState.sortAscending
            ? a.date.compareTo(b.date)
            : b.date.compareTo(a.date));
        break;
      case 'amount':
        sortedExpenses.sort((a, b) => filterState.sortAscending
            ? a.amount.compareTo(b.amount)
            : b.amount.compareTo(a.amount));
        break;
      case 'category':
        sortedExpenses.sort((a, b) => filterState.sortAscending
            ? a.categoryId.compareTo(b.categoryId)
            : b.categoryId.compareTo(a.categoryId));
        break;
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadExpenses();
      },
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, categoryState) {
          if (categoryState is CategoriesLoaded) {
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              itemCount: sortedExpenses.length,
              itemBuilder: (context, index) {
                final expense = sortedExpenses[index];
                Category category = categoryState.categories.firstWhereOrNull(
                      (cat) => cat.id == expense.categoryId,
                    ) ??
                    Category(
                      id: 'unknown',
                      name: 'Unknown',
                      color: Color(0xFF9E9E9E),
                      icon: Icons.help_outline,
                    );

                return ExpenseListItem(
                  expense: expense,
                  category: category,
                  onTap: () => _navigateToEditExpense(context, expense),
                  onEdit: () => _navigateToEditExpense(context, expense),
                  onDelete: () => _showDeleteConfirmation(context, expense),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<void> _navigateToEditExpense(
      BuildContext context, Expense expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditExpensePage(expense: expense),
      ),
    );

    if (result == true) {
      _loadExpenses();
    }
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, Expense expense) async {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteConfirmation),
          content: Text(l10n.deleteDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<ExpenseBloc>().add(
                      DeleteExpenseEvent(expense.id),
                    );
                _loadExpenses();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
}
