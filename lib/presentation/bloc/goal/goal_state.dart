import 'package:equatable/equatable.dart';

import '../../../domain/entities/goal.dart';

abstract class GoalState extends Equatable {
  const GoalState();

  @override
  List<Object> get props => [];
}

class GoalInitial extends GoalState {}

class GoalLoading extends GoalState {}

class GoalsLoaded extends GoalState {
  final List<Goal> goals;

  const GoalsLoaded(this.goals);

  @override
  List<Object> get props => [goals];
}

class GoalOperationSuccess extends GoalState {}

class GoalOperationFailure extends GoalState {
  final String message;

  const GoalOperationFailure(this.message);

  @override
  List<Object> get props => [message];
}
