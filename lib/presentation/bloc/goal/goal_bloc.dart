import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/goal/add_goal.dart';
import '../../../domain/usecases/goal/delete_goal.dart' as delete;
import '../../../domain/usecases/goal/get_all_goals.dart';
import '../../../domain/usecases/goal/update_goal.dart';
import 'goal_event.dart';
import 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final GetAllGoals getAllGoals;
  final AddGoal addGoal;
  final UpdateGoal updateGoal;
  final delete.DeleteGoal deleteGoal;

  GoalBloc({
    required this.getAllGoals,
    required this.addGoal,
    required this.updateGoal,
    required this.deleteGoal,
  }) : super(GoalInitial()) {
    on<GetAllGoalsEvent>(_onGetAllGoals);
    on<AddGoalEvent>(_onAddGoal);
    on<UpdateGoalEvent>(_onUpdateGoal);
    on<DeleteGoalEvent>(_onDeleteGoal);
  }

  Future<void> _onGetAllGoals(
    GetAllGoalsEvent event,
    Emitter<GoalState> emit,
  ) async {
    emit(GoalLoading());
    final result = await getAllGoals(NoParams());

    result.fold(
      (failure) => emit(const GoalOperationFailure('Failed to load goals')),
      (goals) => emit(GoalsLoaded(goals)),
    );
  }

  Future<void> _onAddGoal(
    AddGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    emit(GoalLoading());
    final result = await addGoal(event.goal);

    result.fold(
      (failure) => emit(const GoalOperationFailure('Failed to add goal')),
      (_) {
        add(GetAllGoalsEvent());
      },
    );
  }

  Future<void> _onUpdateGoal(
    UpdateGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    emit(GoalLoading());
    final result = await updateGoal(event.goal);

    result.fold(
      (failure) => emit(const GoalOperationFailure('Failed to update goal')),
      (_) {
        add(GetAllGoalsEvent());
      },
    );
  }

  Future<void> _onDeleteGoal(
    DeleteGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    emit(GoalLoading());
    final result = await deleteGoal(delete.Params(id: event.id));

    result.fold(
      (failure) => emit(const GoalOperationFailure('Failed to delete goal')),
      (_) {
        add(GetAllGoalsEvent());
      },
    );
  }
}
