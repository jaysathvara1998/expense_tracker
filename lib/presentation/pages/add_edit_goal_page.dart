// lib/presentation/pages/add_edit_goal_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/util/date_time_utils.dart';
import '../../core/util/input_validators.dart';
import '../../domain/entities/goal.dart';
import '../bloc/goal/goal_bloc.dart';
import '../bloc/goal/goal_state.dart';
import '../bloc/goal_form/goal_form_bloc.dart';
import '../bloc/goal_form/goal_form_event.dart';
import '../bloc/goal_form/goal_form_state.dart';

class AddEditGoalPage extends StatelessWidget {
  final Goal? goal;

  const AddEditGoalPage({
    Key? key,
    this.goal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoalFormBloc(
        goalBloc: context.read<GoalBloc>(),
      )..add(InitializeGoalFormEvent(goal)),
      child: const _AddEditGoalFormView(),
    );
  }
}

class _AddEditGoalFormView extends StatefulWidget {
  const _AddEditGoalFormView();

  @override
  State<_AddEditGoalFormView> createState() => _AddEditGoalFormViewState();
}

class _AddEditGoalFormViewState extends State<_AddEditGoalFormView> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _savedAmountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Add listeners to update bloc on text changes
    _titleController.addListener(_onTitleChanged);
    _targetAmountController.addListener(_onTargetAmountChanged);
    _savedAmountController.addListener(_onSavedAmountChanged);
    _descriptionController.addListener(_onDescriptionChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize text controllers from bloc state
    final state = context.read<GoalFormBloc>().state;
    if (_titleController.text != state.title) {
      _titleController.text = state.title;
    }
    if (_targetAmountController.text != state.targetAmount) {
      _targetAmountController.text = state.targetAmount;
    }
    if (_savedAmountController.text != state.savedAmount) {
      _savedAmountController.text = state.savedAmount;
    }
    if (_descriptionController.text != state.description) {
      _descriptionController.text = state.description;
    }
  }

  void _onTitleChanged() {
    context.read<GoalFormBloc>().add(
          ChangeTitleEvent(_titleController.text),
        );
  }

  void _onTargetAmountChanged() {
    context.read<GoalFormBloc>().add(
          ChangeTargetAmountEvent(_targetAmountController.text),
        );
  }

  void _onSavedAmountChanged() {
    context.read<GoalFormBloc>().add(
          ChangeSavedAmountEvent(_savedAmountController.text),
        );
  }

  void _onDescriptionChanged() {
    context.read<GoalFormBloc>().add(
          ChangeDescriptionEvent(_descriptionController.text),
        );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    _savedAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<GoalFormBloc, GoalFormState>(
      listenWhen: (previous, current) =>
          previous.isSubmitting && !current.isSubmitting,
      listener: (context, state) {
        // Nothing to do here - we'll handle success/failure via the GoalBloc listener
      },
      builder: (context, formState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(formState.isEditing ? l10n.editGoal : l10n.addGoal),
          ),
          body: BlocListener<GoalBloc, GoalState>(
            listener: (context, goalState) {
              if (goalState is GoalOperationSuccess) {
                Navigator.pop(context, true);
              } else if (goalState is GoalOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(goalState.message),
                    backgroundColor: Colors.red,
                  ),
                );
                context.read<GoalFormBloc>().add(
                      const SubmittingGoalFormEvent(),
                    );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Goal Title
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: l10n.goalTitle,
                        border: const OutlineInputBorder(),
                      ),
                      validator: InputValidators.validateName,
                    ),
                    const SizedBox(height: 16),

                    // Target Amount
                    TextFormField(
                      controller: _targetAmountController,
                      decoration: InputDecoration(
                        labelText: l10n.targetAmount,
                        prefixText: l10n.currency,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: InputValidators.validateAmount,
                    ),
                    const SizedBox(height: 16),

                    // Saved Amount
                    TextFormField(
                      controller: _savedAmountController,
                      decoration: InputDecoration(
                        labelText: l10n.savedAmount,
                        prefixText: l10n.currency,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        final amountError =
                            InputValidators.validateAmount(value);
                        if (amountError != null) return amountError;

                        final savedAmount = double.parse(value!);
                        final targetAmount =
                            double.tryParse(_targetAmountController.text) ??
                                0.0;

                        if (savedAmount > targetAmount) {
                          return 'Saved amount cannot exceed target amount';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Start Date
                    _buildDatePicker(
                      context,
                      labelText: l10n.startDate,
                      selectedDate: formState.startDate,
                      onDateSelected: (date) {
                        context
                            .read<GoalFormBloc>()
                            .add(ChangeStartDateEvent(date));
                      },
                    ),
                    const SizedBox(height: 16),

                    // End Date
                    _buildDatePicker(
                      context,
                      labelText: l10n.endDate,
                      selectedDate: formState.endDate,
                      onDateSelected: (date) {
                        context
                            .read<GoalFormBloc>()
                            .add(ChangeEndDateEvent(date));
                      },
                      validator: (date) => InputValidators.validateEndDate(
                          formState.startDate, date),
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
                    const SizedBox(height: 24),

                    // Progress Indicator (for existing goals)
                    if (formState.isEditing && formState.getProgress() > 0) ...[
                      _buildProgressIndicator(formState),
                      const SizedBox(height: 24),
                    ],

                    // Save Button
                    ElevatedButton(
                      onPressed:
                          formState.isSubmitting || !formState.isFormValid
                              ? null
                              : _submitForm,
                      child: formState.isSubmitting
                          ? const CircularProgressIndicator()
                          : Text(
                              formState.isEditing ? l10n.save : l10n.addGoal),
                    ),

                    if (formState.isEditing) ...[
                      const SizedBox(height: 16),
                      // Delete Button
                      OutlinedButton(
                        onPressed: formState.isSubmitting ? null : _deleteGoal,
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

  Widget _buildDatePicker(
    BuildContext context, {
    required String labelText,
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
    String? Function(DateTime?)? validator,
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
          errorText: validator != null ? validator(selectedDate) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateTimeUtils.formatDate(selectedDate)),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(GoalFormState formState) {
    final progress = formState.getProgress();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress: ${(progress * 100).toStringAsFixed(1)}%',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          valueColor:
              AlwaysStoppedAnimation<Color>(_getProgressColor(progress)),
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) {
      return Colors.red;
    } else if (progress < 0.7) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<GoalFormBloc>().add(const SubmitGoalFormEvent());
    }
  }

  void _deleteGoal() {
    final goalId = context.read<GoalFormBloc>().state.id;
    if (goalId == null) return;

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
                context.read<GoalFormBloc>().add(DeleteGoalEvent(goalId));
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
