import 'package:expanse_tracker/presentation/bloc/loan_form/loan_form_bloc.dart';
import 'package:expanse_tracker/presentation/bloc/loan_form/loan_form_event.dart';
import 'package:expanse_tracker/presentation/bloc/loan_form/loan_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/util/date_time_utils.dart';
import '../../core/util/input_validators.dart';
import '../../domain/entities/loan.dart';
import '../bloc/loan/loan_bloc.dart';
import '../bloc/loan/loan_state.dart';

class AddEditLoanPage extends StatelessWidget {
  final Loan? loan;

  const AddEditLoanPage({
    super.key,
    this.loan,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoanFormBloc(
        loanBloc: context.read<LoanBloc>(),
      )..add(InitializeLoanFormEvent(loan)),
      child: const _AddEditLoanFormView(),
    );
  }
}

class _AddEditLoanFormView extends StatefulWidget {
  const _AddEditLoanFormView();

  @override
  State<_AddEditLoanFormView> createState() => _AddEditLoanFormViewState();
}

class _AddEditLoanFormViewState extends State<_AddEditLoanFormView> {
  final _formKey = GlobalKey<FormState>();

  final _personNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Add listeners to update bloc on text changes
    _personNameController.addListener(_onPersonNameChanged);
    _amountController.addListener(_onAmountChanged);
    _descriptionController.addListener(_onDescriptionChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize text controllers from bloc state
    final state = context.read<LoanFormBloc>().state;
    if (_personNameController.text != state.personName) {
      _personNameController.text = state.personName;
    }
    if (_amountController.text != state.amount) {
      _amountController.text = state.amount;
    }
    if (_descriptionController.text != state.description) {
      _descriptionController.text = state.description;
    }
  }

  void _onPersonNameChanged() {
    context.read<LoanFormBloc>().add(
          ChangePersonNameEvent(_personNameController.text),
        );
  }

  void _onAmountChanged() {
    context.read<LoanFormBloc>().add(
          ChangeAmountEvent(_amountController.text),
        );
  }

  void _onDescriptionChanged() {
    context.read<LoanFormBloc>().add(
          ChangeDescriptionEvent(_descriptionController.text),
        );
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

    return BlocConsumer<LoanFormBloc, LoanFormState>(
      listenWhen: (previous, current) =>
          previous.isSubmitting && !current.isSubmitting,
      listener: (context, state) {
        // Nothing to do here - we'll handle success/failure via the LoanBloc listener
      },
      builder: (context, formState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(formState.isEditing ? l10n.editLoan : l10n.addLoan),
          ),
          body: BlocListener<LoanBloc, LoanState>(
            listener: (context, loanState) {
              if (loanState is LoanOperationSuccess) {
                Navigator.pop(context, true);
              } else if (loanState is LoanOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loanState.message),
                    backgroundColor: Colors.red,
                  ),
                );
                context.read<LoanFormBloc>().add(
                      const SubmittingLoanFormEvent(),
                    );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Loan Type
                    _buildLoanTypeSelector(l10n, formState),
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
                      selectedDate: formState.date,
                      onDateSelected: (date) {
                        context.read<LoanFormBloc>().add(ChangeDateEvent(date));
                      },
                    ),
                    const SizedBox(height: 16),

                    // Due Date (Optional)
                    Row(
                      children: [
                        Expanded(
                          child: formState.dueDate == null
                              ? OutlinedButton.icon(
                                  onPressed: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now()
                                          .add(const Duration(days: 7)),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2030),
                                    );
                                    if (picked != null) {
                                      context.read<LoanFormBloc>().add(
                                            ChangeDueDateEvent(picked),
                                          );
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today),
                                  label: Text(l10n.dueDate),
                                )
                              : _buildDatePicker(
                                  context,
                                  labelText: l10n.dueDate,
                                  selectedDate: formState.dueDate!,
                                  onDateSelected: (date) {
                                    context.read<LoanFormBloc>().add(
                                          ChangeDueDateEvent(date),
                                        );
                                  },
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      context.read<LoanFormBloc>().add(
                                            const ChangeDueDateEvent(null),
                                          );
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
                      subtitle: const Text('Reminds you about this loan'),
                      value: formState.hasReminder,
                      onChanged: (value) {
                        context.read<LoanFormBloc>().add(
                              ChangeReminderStatusEvent(value),
                            );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Settled Status (Edit only)
                    if (formState.isEditing)
                      SwitchListTile(
                        title: Text(l10n.settle),
                        subtitle: const Text('Mark as settled'),
                        value: formState.isSettled,
                        onChanged: (value) {
                          context.read<LoanFormBloc>().add(
                                ChangeSettledStatusEvent(value),
                              );
                        },
                      ),
                    const SizedBox(height: 24),

                    // Save Button
                    ElevatedButton(
                      onPressed:
                          formState.isSubmitting || !formState.isFormValid
                              ? null
                              : _submitForm,
                      child: formState.isSubmitting
                          ? const CircularProgressIndicator()
                          : Text(
                              formState.isEditing ? l10n.save : l10n.addLoan),
                    ),

                    if (formState.isEditing) ...[
                      const SizedBox(height: 16),
                      // Delete Button
                      OutlinedButton(
                        onPressed: formState.isSubmitting ? null : _deleteLoan,
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

  Widget _buildLoanTypeSelector(
      AppLocalizations l10n, LoanFormState formState) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              context.read<LoanFormBloc>().add(
                    const ChangeLoanTypeEvent(LoanType.borrowed),
                  );
            },
            child: Card(
              color: formState.type == LoanType.borrowed
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: formState.type == LoanType.borrowed
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.borrowed,
                      style: TextStyle(
                        fontWeight: formState.type == LoanType.borrowed
                            ? FontWeight.bold
                            : null,
                        color: formState.type == LoanType.borrowed
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
              context.read<LoanFormBloc>().add(
                    const ChangeLoanTypeEvent(LoanType.lent),
                  );
            },
            child: Card(
              color: formState.type == LoanType.lent
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: formState.type == LoanType.lent
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.lent,
                      style: TextStyle(
                        fontWeight: formState.type == LoanType.lent
                            ? FontWeight.bold
                            : null,
                        color: formState.type == LoanType.lent
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
      context.read<LoanFormBloc>().add(const SubmitLoanFormEvent());
    }
  }

  void _deleteLoan() {
    final loanId = context.read<LoanFormBloc>().state.id;
    if (loanId == null) return;

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
                context.read<LoanFormBloc>().add(DeleteLoanEvent(loanId));
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
