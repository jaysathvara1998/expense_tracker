// lib/presentation/bloc/goal_form/goal_form_state.dart
import 'package:equatable/equatable.dart';

import '../../../domain/entities/goal.dart';

class GoalFormState extends Equatable {
  final String? id;
  final String title;
  final String targetAmount;
  final String savedAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final bool isEditing;
  final bool isSubmitting;
  final bool isFormValid;
  final String? error;

  const GoalFormState({
    this.id,
    this.title = '',
    this.targetAmount = '',
    this.savedAmount = '0.0',
    required this.startDate,
    required this.endDate,
    this.description = '',
    this.isEditing = false,
    this.isSubmitting = false,
    this.isFormValid = false,
    this.error,
  });

  // Factory method for initial state
  factory GoalFormState.initial() {
    final now = DateTime.now();
    return GoalFormState(
      startDate: now,
      endDate: now.add(const Duration(days: 30)),
    );
  }

  // Initialize from an existing goal
  factory GoalFormState.fromGoal(Goal goal) {
    return GoalFormState(
      id: goal.id,
      title: goal.title,
      targetAmount: goal.targetAmount.toString(),
      savedAmount: goal.savedAmount.toString(),
      startDate: goal.startDate,
      endDate: goal.endDate,
      description: goal.description,
      isEditing: true,
      isFormValid: true,
    );
  }

  // Helper method to convert form state to Goal entity
  Goal toGoal() {
    return Goal(
      id: id ?? '', // ID will be generated if not editing
      title: title,
      targetAmount: double.tryParse(targetAmount) ?? 0.0,
      savedAmount: double.tryParse(savedAmount) ?? 0.0,
      startDate: startDate,
      endDate: endDate,
      description: description,
    );
  }

  // Get progress percentage for the goal
  double getProgress() {
    final target = double.tryParse(targetAmount) ?? 0.0;
    final saved = double.tryParse(savedAmount) ?? 0.0;

    if (target <= 0) return 0.0;
    return saved / target;
  }

  // Validate form fields
  bool validateForm() {
    // Basic field validation
    if (title.isEmpty || targetAmount.isEmpty || description.isEmpty) {
      return false;
    }

    // Parse values
    final target = double.tryParse(targetAmount);
    final saved = double.tryParse(savedAmount);

    // Validate parsed values
    if (target == null || target <= 0 || saved == null || saved < 0) {
      return false;
    }

    // Validate saved amount doesn't exceed target
    if (saved > target) {
      return false;
    }

    // Validate end date is after start date
    if (!endDate.isAfter(startDate)) {
      return false;
    }

    return true;
  }

  // Create a copy with some changes
  GoalFormState copyWith({
    String? id,
    String? title,
    String? targetAmount,
    String? savedAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isEditing,
    bool? isSubmitting,
    bool? isFormValid,
    String? error,
  }) {
    return GoalFormState(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      isEditing: isEditing ?? this.isEditing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFormValid: isFormValid ?? this.isFormValid,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        targetAmount,
        savedAmount,
        startDate,
        endDate,
        description,
        isEditing,
        isSubmitting,
        isFormValid,
        error,
      ];
}
