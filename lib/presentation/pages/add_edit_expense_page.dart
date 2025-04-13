// lib/presentation/pages/add_edit_expense_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/util/date_time_utils.dart';
import '../../core/util/input_validators.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../bloc/expense/expense_bloc.dart';
import '../bloc/expense/expense_event.dart';
import '../bloc/expense/expense_state.dart';

class AddEditExpensePage extends StatefulWidget {
  final Expense? expense;

  const AddEditExpensePage({
    Key? key,
    this.expense,
  }) : super(key: key);

  @override
  State<AddEditExpensePage> createState() => _AddEditExpensePageState();
}

class _AddEditExpensePageState extends State<AddEditExpensePage> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _date;
  late TimeOfDay _time;
  final _amountController = TextEditingController();
  String? _selectedCategoryId;
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedPaymentMode = AppConstants.paymentModes.first;

  bool _isEditing = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.expense != null;

    if (_isEditing) {
      final expense = widget.expense!;
      _date = expense.date;
      _time = TimeOfDay.fromDateTime(expense.date);
      _amountController.text = expense.amount.toString();
      _selectedCategoryId = expense.categoryId;
      _descriptionController.text = expense.description;
      _locationController.text = expense.location;
      _selectedPaymentMode = expense.paymentMode;
    } else {
      _date = DateTime.now();
      _time = TimeOfDay.now();
    }

    // Load categories if not already loaded
    final categoryState = context.read<CategoryBloc>().state;
    if (categoryState is! CategoriesLoaded) {
      context.read<CategoryBloc>().add(GetAllCategoriesEvent());
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editExpense : l10n.addExpense),
      ),
      body: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseOperationSuccess) {
            Navigator.pop(context, true);
          } else if (state is ExpenseOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _isSubmitting = false;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Date Picker
                _buildDatePicker(l10n),
                const SizedBox(height: 16),

                // Time Picker
                _buildTimePicker(l10n),
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
                _buildCategoryDropdown(l10n),
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
                _buildPaymentModeDropdown(l10n),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : Text(_isEditing ? l10n.save : l10n.addExpense),
                ),

                if (_isEditing) ...[
                  const SizedBox(height: 16),
                  // Delete Button
                  OutlinedButton(
                    onPressed: _isSubmitting ? null : _deleteExpense,
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
  }

  Widget _buildDatePicker(AppLocalizations l10n) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.date,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          DateTimeUtils.formatDate(_date),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Widget _buildTimePicker(AppLocalizations l10n) {
    return InkWell(
      onTap: () => _selectTime(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.time,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.access_time),
        ),
        child: Text(
          _time.format(context),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  Widget _buildCategoryDropdown(AppLocalizations l10n) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoriesLoaded) {
          final categories = state.categories;

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
          if (_selectedCategoryId == null &&
              !_isEditing &&
              categories.isNotEmpty) {
            _selectedCategoryId = categories.first.id;
          }

          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: l10n.category,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.category),
            ),
            value: _selectedCategoryId,
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
              setState(() {
                _selectedCategoryId = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.error;
              }
              return null;
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildPaymentModeDropdown(AppLocalizations l10n) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: l10n.paymentMode,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.payment),
      ),
      value: _selectedPaymentMode,
      items: AppConstants.paymentModes.map((String mode) {
        return DropdownMenuItem<String>(
          value: mode,
          child: Text(mode),
        );
      }).toList(),
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            _selectedPaymentMode = value;
          });
        }
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Combine date and time
      final DateTime dateTime = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time.hour,
        _time.minute,
      );

      // Create expense entity
      final expense = Expense(
        id: _isEditing ? widget.expense!.id : const Uuid().v4(),
        amount: double.parse(_amountController.text),
        date: dateTime,
        categoryId: _selectedCategoryId!,
        description: _descriptionController.text,
        location: _locationController.text,
        paymentMode: _selectedPaymentMode,
      );

      // Save or update expense
      if (_isEditing) {
        context.read<ExpenseBloc>().add(UpdateExpenseEvent(expense));
      } else {
        context.read<ExpenseBloc>().add(AddExpenseEvent(expense));
      }
    }
  }

  void _deleteExpense() {
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
                setState(() {
                  _isSubmitting = true;
                });
                context.read<ExpenseBloc>().add(
                      DeleteExpenseEvent(widget.expense!.id),
                    );
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
