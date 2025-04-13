// lib/presentation/pages/add_edit_goal_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../core/util/date_time_utils.dart';
import '../../core/util/input_validators.dart';
import '../../domain/entities/goal.dart';
import '../bloc/goal/goal_bloc.dart';
import '../bloc/goal/goal_event.dart';
import '../bloc/goal/goal_state.dart';

class AddEditGoalPage extends StatefulWidget {
  final Goal? goal;

  const AddEditGoalPage({
    Key? key,
    this.goal,
  }) : super(key: key);

  @override
  State<AddEditGoalPage> createState() => _AddEditGoalPageState();
}

class _AddEditGoalPageState extends State<AddEditGoalPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _savedAmountController = TextEditingController();
  late DateTime _startDate;
  late DateTime _endDate;
  final _descriptionController = TextEditingController();

  bool _isEditing = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.goal != null;

    if (_isEditing) {
      final goal = widget.goal!;
      _titleController.text = goal.title;
      _targetAmountController.text = goal.targetAmount.toString();
      _savedAmountController.text = goal.savedAmount.toString();
      _startDate = goal.startDate;
      _endDate = goal.endDate;
      _descriptionController.text = goal.description;
    } else {
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(days: 30));
      _savedAmountController.text = '0.0';
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editGoal : l10n.addGoal),
      ),
      body: BlocListener<GoalBloc, GoalState>(
        listener: (context, state) {
          if (state is GoalOperationSuccess) {
            Navigator.pop(context, true);
          } else if (state is GoalOperationFailure) {
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
                    final amountError = InputValidators.validateAmount(value);
                    if (amountError != null) return amountError;

                    final savedAmount = double.parse(value!);
                    final targetAmount =
                        double.tryParse(_targetAmountController.text) ?? 0.0;

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
                  selectedDate: _startDate,
                  onDateSelected: (date) {
                    setState(() {
                      _startDate = date;
                      // If end date is before start date, update it
                      if (_endDate.isBefore(_startDate)) {
                        _endDate = _startDate.add(const Duration(days: 1));
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),

                // End Date
                _buildDatePicker(
                  context,
                  labelText: l10n.endDate,
                  selectedDate: _endDate,
                  onDateSelected: (date) {
                    setState(() {
                      _endDate = date;
                    });
                  },
                  validator: (date) =>
                      InputValidators.validateEndDate(_startDate, date),
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
                if (_isEditing &&
                    double.tryParse(_targetAmountController.text) != null &&
                    double.tryParse(_savedAmountController.text) != null) ...[
                  _buildProgressIndicator(),
                  const SizedBox(height: 24),
                ],

                // Save Button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : Text(_isEditing ? l10n.save : l10n.addGoal),
                ),

                if (_isEditing) ...[
                  const SizedBox(height: 16),
                  // Delete Button
                  OutlinedButton(
                    onPressed: _isSubmitting ? null : _deleteGoal,
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

  Widget _buildProgressIndicator() {
    final targetAmount = double.tryParse(_targetAmountController.text) ?? 0.0;
    final savedAmount = double.tryParse(_savedAmountController.text) ?? 0.0;
    final progress = targetAmount > 0 ? savedAmount / targetAmount : 0.0;

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
      setState(() {
        _isSubmitting = true;
      });

      // Create goal entity
      final goal = Goal(
        id: _isEditing ? widget.goal!.id : const Uuid().v4(),
        title: _titleController.text,
        targetAmount: double.parse(_targetAmountController.text),
        savedAmount: double.parse(_savedAmountController.text),
        startDate: _startDate,
        endDate: _endDate,
        description: _descriptionController.text,
      );

      // Save or update goal
      if (_isEditing) {
        context.read<GoalBloc>().add(UpdateGoalEvent(goal));
      } else {
        context.read<GoalBloc>().add(AddGoalEvent(goal));
      }
    }
  }

  void _deleteGoal() {
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
                context.read<GoalBloc>().add(
                      DeleteGoalEvent(widget.goal!.id),
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
