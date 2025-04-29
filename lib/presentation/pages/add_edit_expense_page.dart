// lib/presentation/pages/add_edit_expense_page.dart
import 'package:expanse_tracker/presentation/bloc/expense_form/expense_form_bloc.dart';
import 'package:expanse_tracker/presentation/bloc/expense_form/expense_form_event.dart';
import 'package:expanse_tracker/presentation/bloc/expense_form/expense_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/constants/app_constants.dart';
import '../../core/util/date_time_utils.dart';
import '../../core/util/input_validators.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../bloc/expense/expense_bloc.dart';
import '../bloc/expense/expense_state.dart';

class AddEditExpensePage extends StatelessWidget {
  final Expense? expense;

  const AddEditExpensePage({
    super.key,
    this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseFormBloc(
        expenseBloc: context.read<ExpenseBloc>(),
      )..add(InitializeExpenseFormEvent(expense)),
      child: const _AddEditExpenseFormView(),
    );
  }
}

class _AddEditExpenseFormView extends StatefulWidget {
  const _AddEditExpenseFormView();

  @override
  State<_AddEditExpenseFormView> createState() =>
      _AddEditExpenseFormViewState();
}

class _AddEditExpenseFormViewState extends State<_AddEditExpenseFormView> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Add listeners to update bloc on text changes
    _amountController.addListener(_onAmountChanged);
    _descriptionController.addListener(_onDescriptionChanged);
    _locationController.addListener(_onLocationChanged);

    // Load categories if not already loaded
    final categoryState = context.read<CategoryBloc>().state;
    if (categoryState is! CategoriesLoaded) {
      context.read<CategoryBloc>().add(GetAllCategoriesEvent());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize text controllers from bloc state
    final state = context.read<ExpenseFormBloc>().state;
    if (_amountController.text != state.amount) {
      _amountController.text = state.amount;
    }
    if (_descriptionController.text != state.description) {
      _descriptionController.text = state.description;
    }
    if (_locationController.text != state.location) {
      _locationController.text = state.location;
    }
  }

  void _onAmountChanged() {
    context.read<ExpenseFormBloc>().add(
          ChangeAmountEvent(_amountController.text),
        );
  }

  void _onDescriptionChanged() {
    context.read<ExpenseFormBloc>().add(
          ChangeDescriptionEvent(_descriptionController.text),
        );
  }

  void _onLocationChanged() {
    context.read<ExpenseFormBloc>().add(
          ChangeLocationEvent(_locationController.text),
        );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ExpenseFormBloc, ExpenseFormState>(
      listenWhen: (previous, current) =>
          previous.isSubmitting && !current.isSubmitting,
      listener: (context, state) {
        // Nothing to do here - we'll handle success/failure via the ExpenseBloc listener
      },
      builder: (context, formState) {
        return Scaffold(
          appBar: AppBar(
            title:
                Text(formState.isEditing ? l10n.editExpense : l10n.addExpense),
          ),
          body: BlocListener<ExpenseBloc, ExpenseState>(
            listener: (context, expenseState) {
              if (expenseState is ExpenseOperationSuccess) {
                Navigator.pop(context, true);
              } else if (expenseState is ExpenseOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(expenseState.message),
                    backgroundColor: Colors.red,
                  ),
                );
                context.read<ExpenseFormBloc>().add(
                      const SubmittingExpenseFormEvent(),
                    );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Date Picker
                    _buildDatePicker(l10n, formState),
                    const SizedBox(height: 16),

                    // Time Picker
                    _buildTimePicker(l10n, formState),
                    const SizedBox(height: 16),

                    // Amount
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: l10n.amount,
                        prefixText: l10n.currency,
                        border: const OutlineInputBorder(),
                        hintText: '0.00',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: InputValidators.validateAmount,
                    ),
                    const SizedBox(height: 16),

                    // Category
                    _buildCategoryDropdown(l10n, formState),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: InputValidators.validateNotEmpty,
                    ),
                    const SizedBox(height: 16),

                    // Location
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: l10n.location,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.location_on),
                      ),
                      validator: InputValidators.validateNotEmpty,
                    ),
                    const SizedBox(height: 16),

                    // Payment Mode
                    _buildPaymentModeDropdown(l10n, formState),
                    const SizedBox(height: 24),

                    // Save Button
                    ElevatedButton(
                      onPressed:
                          formState.isSubmitting || !formState.isFormValid
                              ? null
                              : _submitForm,
                      child: formState.isSubmitting
                          ? const CircularProgressIndicator()
                          : Text(formState.isEditing
                              ? l10n.save
                              : l10n.addExpense),
                    ),

                    if (formState.isEditing) ...[
                      const SizedBox(height: 16),
                      // Delete Button
                      OutlinedButton(
                        onPressed:
                            formState.isSubmitting ? null : _deleteExpense,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: Text(l10n.delete),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDatePicker(AppLocalizations l10n, ExpenseFormState formState) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.date,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          DateTimeUtils.formatDate(formState.date),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final currentDate = context.read<ExpenseFormBloc>().state.date;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != currentDate) {
      context.read<ExpenseFormBloc>().add(ChangeDateEvent(picked));
    }
  }

  Widget _buildTimePicker(AppLocalizations l10n, ExpenseFormState formState) {
    return InkWell(
      onTap: () => _selectTime(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.time,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.access_time),
        ),
        child: Text(
          formState.time.format(context),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final currentTime = context.read<ExpenseFormBloc>().state.time;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (picked != null && picked != currentTime) {
      context.read<ExpenseFormBloc>().add(ChangeTimeEvent(picked));
    }
  }

  Widget _buildCategoryDropdown(
      AppLocalizations l10n, ExpenseFormState formState) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        if (categoryState is CategoriesLoaded) {
          final categories = categoryState.categories;

          if (categories.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Text(l10n.noData),
                  TextButton(
                    onPressed: () {
                      // Navigate to add category page
                    },
                    child: Text(l10n.addCategory),
                  ),
                ],
              ),
            );
          }

          // Set default category if none selected and adding new expense
          if (formState.categoryId == null &&
              !formState.isEditing &&
              categories.isNotEmpty) {
            // Update the form bloc with the first category
            Future.microtask(() {
              context.read<ExpenseFormBloc>().add(
                    ChangeCategoryEvent(categories.first.id),
                  );
            });
          }

          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: l10n.category,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.category),
            ),
            value: formState.categoryId,
            items: categories.map((Category category) {
              return DropdownMenuItem<String>(
                value: category.id,
                child: Row(
                  children: [
                    Icon(
                      category.icon,
                      color: category.color,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(category.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                context.read<ExpenseFormBloc>().add(
                      ChangeCategoryEvent(value),
                    );
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.error;
              }
              return null;
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildPaymentModeDropdown(
      AppLocalizations l10n, ExpenseFormState formState) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: l10n.paymentMode,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.payment),
      ),
      value: formState.paymentMode,
      items: AppConstants.paymentModes.map((String mode) {
        return DropdownMenuItem<String>(
          value: mode,
          child: Text(mode),
        );
      }).toList(),
      onChanged: (String? value) {
        if (value != null) {
          context.read<ExpenseFormBloc>().add(
                ChangePaymentModeEvent(value),
              );
        }
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ExpenseFormBloc>().add(const SubmitExpenseFormEvent());
    }
  }

  void _deleteExpense() {
    final expenseId = context.read<ExpenseFormBloc>().state.id;
    if (expenseId == null) return;

    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
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
                context
                    .read<ExpenseFormBloc>()
                    .add(DeleteExpenseEvent(expenseId));
              },
              child: Text(
                l10n.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
