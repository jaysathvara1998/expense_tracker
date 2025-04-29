// lib/presentation/bloc/goal_form/goal_form_event.dart
import 'package:equatable/equatable.dart';

import '../../../domain/entities/goal.dart';

abstract class GoalFormEvent extends Equatable {
  const GoalFormEvent();

  @override
  List<Object?> get props => [];
}

class InitializeGoalFormEvent extends GoalFormEvent {
  final Goal? goal;

  const InitializeGoalFormEvent(this.goal);

  @override
  List<Object?> get props => [goal];
}

class ChangeTitleEvent extends GoalFormEvent {
  final String title;

  const ChangeTitleEvent(this.title);

  @override
  List<Object> get props => [title];
}

class ChangeTargetAmountEvent extends GoalFormEvent {
  final String targetAmount;

  const ChangeTargetAmountEvent(this.targetAmount);

  @override
  List<Object> get props => [targetAmount];
}

class ChangeSavedAmountEvent extends GoalFormEvent {
  final String savedAmount;

  const ChangeSavedAmountEvent(this.savedAmount);

  @override
  List<Object> get props => [savedAmount];
}

class ChangeStartDateEvent extends GoalFormEvent {
  final DateTime startDate;

  const ChangeStartDateEvent(this.startDate);

  @override
  List<Object> get props => [startDate];
}

class ChangeEndDateEvent extends GoalFormEvent {
  final DateTime endDate;

  const ChangeEndDateEvent(this.endDate);

  @override
  List<Object> get props => [endDate];
}

class ChangeDescriptionEvent extends GoalFormEvent {
  final String description;

  const ChangeDescriptionEvent(this.description);

  @override
  List<Object> get props => [description];
}

class SubmitGoalFormEvent extends GoalFormEvent {
  const SubmitGoalFormEvent();
}

class SubmittingGoalFormEvent extends GoalFormEvent {
  const SubmittingGoalFormEvent();
}

class DeleteGoalEvent extends GoalFormEvent {
  final String id;

  const DeleteGoalEvent(this.id);

  @override
  List<Object> get props => [id];
}
