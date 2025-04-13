import 'package:equatable/equatable.dart';

import '../../../domain/entities/goal.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object> get props => [];
}

class GetAllGoalsEvent extends GoalEvent {}

class AddGoalEvent extends GoalEvent {
  final Goal goal;

  const AddGoalEvent(this.goal);

  @override
  List<Object> get props => [goal];
}

class UpdateGoalEvent extends GoalEvent {
  final Goal goal;

  const UpdateGoalEvent(this.goal);

  @override
  List<Object> get props => [goal];
}

class DeleteGoalEvent extends GoalEvent {
  final String id;

  const DeleteGoalEvent(this.id);

  @override
  List<Object> get props => [id];
}
