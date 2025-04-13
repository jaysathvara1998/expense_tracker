// lib/presentation/pages/add_edit_loan_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../core/util/date_time_utils.dart';
import '../../core/util/input_validators.dart';
import '../../domain/entities/loan.dart';
import '../bloc/loan/loan_bloc.dart';
import '../bloc/loan/loan_event.dart';
import '../bloc/loan/loan_state.dart';

class AddEditLoanPage extends StatefulWidget {
  final Loan? loan;

  const AddEditLoanPage({
    Key? key,
    this.loan,
  }) : super(key: key);

  @override
  State<AddEditLoanPage> createState() => _AddEditLoanPageState();
}

class _AddEditLoanPageState extends State<AddEditLoanPage> {
  final _formKey = GlobalKey<FormState>();

  final _personNameController = TextEditingController();
  final _amountController = TextEditingController();
  late DateTime _date;
  DateTime? _dueDate;
  final _descriptionController = TextEditingController();
  bool _hasReminder = false;
  late LoanType _type;
  bool _isSettled = false;

  bool _isEditing = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.loan != null;

    if (_isEditing) {
      final loan = widget.loan!;
      _personNameController.text = loan.personName;
      _amountController.text = loan.amount.toString();
      _date = loan.date;
      _dueDate = loan.dueDate;
      _descriptionController.text = loan.description;
      _hasReminder = loan.hasReminder;
      _type = loan.type;
      _isSettled = loan.isSettled;
    } else {
      _date = DateTime.now();
      _type = LoanType.borrowed;
    }
  }

  @override
  void dispose() {
    _personNameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editLoan : l10n.addLoan),
      ),
      body: BlocListener<LoanBloc, LoanState>(
        listener: (context, state) {
          if (state is LoanOperationSuccess) {
            Navigator.pop(context, true);
          } else if (state is LoanOperationFailure) {
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
                // Loan Type
                _buildLoanTypeSelector(l10n),
                const SizedBox(height: 16),

                // Person Name
                TextFormField(
                  controller: _personNameController,
                  decoration: InputDecoration(
                    labelText: l10n.personName,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: InputValidators.validateName,
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: l10n.amount,
                    prefixText: l10n.currency,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: InputValidators.validateAmount,
                ),
                const SizedBox(height: 16),

                // Date
                _buildDatePicker(
                  context,
                  labelText: l10n.date,
                  selectedDate: _date,
                  onDateSelected: (date) {
                    setState(() {
                      _date = date;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Due Date (Optional)
                Row(
                  children: [
                    Expanded(
                      child: _dueDate == null
                          ? OutlinedButton.icon(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now()
                                      .add(const Duration(days: 7)),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030),
                                );
                                if (picked != null) {
                                  setState(() {
                                    _dueDate = picked;
                                  });
                                }
                              },
                              icon: const Icon(Icons.calendar_today),
                              label: Text(l10n.dueDate),
                            )
                          : _buildDatePicker(
                              context,
                              labelText: l10n.dueDate,
                              selectedDate: _dueDate!,
                              onDateSelected: (date) {
                                setState(() {
                                  _dueDate = date;
                                });
                              },
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _dueDate = null;
                                  });
                                },
                              ),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.description,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: InputValidators.validateNotEmpty,
                ),
                const SizedBox(height: 16),

                // Set Reminder
                SwitchListTile(
                  title: Text(l10n.setReminder),
                  subtitle: Text('Reminds you about this loan'),
                  value: _hasReminder,
                  onChanged: (value) {
                    setState(() {
                      _hasReminder = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Settled Status (Edit only)
                if (_isEditing)
                  SwitchListTile(
                    title: Text(l10n.settle),
                    subtitle: Text('Mark as settled'),
                    value: _isSettled,
                    onChanged: (value) {
                      setState(() {
                        _isSettled = value;
                      });
                    },
                  ),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : Text(_isEditing ? l10n.save : l10n.addLoan),
                ),

                if (_isEditing) ...[
                  const SizedBox(height: 16),
                  // Delete Button
                  OutlinedButton(
                    onPressed: _isSubmitting ? null : _deleteLoan,
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

  Widget _buildLoanTypeSelector(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _type = LoanType.borrowed;
              });
            },
            child: Card(
              color: _type == LoanType.borrowed
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: _type == LoanType.borrowed
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.borrowed,
                      style: TextStyle(
                        fontWeight:
                            _type == LoanType.borrowed ? FontWeight.bold : null,
                        color: _type == LoanType.borrowed
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Money I owe',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _type = LoanType.lent;
              });
            },
            child: Card(
              color: _type == LoanType.lent
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: _type == LoanType.lent
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.lent,
                      style: TextStyle(
                        fontWeight:
                            _type == LoanType.lent ? FontWeight.bold : null,
                        color: _type == LoanType.lent
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Money owed to me',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    BuildContext context, {
    required String labelText,
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
    Widget? suffixIcon,
  }) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null && picked != selectedDate) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon ?? const Icon(Icons.calendar_today),
        ),
        child: Text(DateTimeUtils.formatDate(selectedDate)),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Create loan entity
      final loan = Loan(
        id: _isEditing ? widget.loan!.id : const Uuid().v4(),
        personName: _personNameController.text,
        amount: double.parse(_amountController.text),
        date: _date,
        dueDate: _dueDate,
        description: _descriptionController.text,
        hasReminder: _hasReminder,
        type: _type,
        isSettled: _isSettled,
      );

      // Save or update loan
      if (_isEditing) {
        context.read<LoanBloc>().add(UpdateLoanEvent(loan));
      } else {
        context.read<LoanBloc>().add(AddLoanEvent(loan));
      }
    }
  }

  void _deleteLoan() {
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
                context.read<LoanBloc>().add(
                      DeleteLoanEvent(widget.loan!.id),
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
