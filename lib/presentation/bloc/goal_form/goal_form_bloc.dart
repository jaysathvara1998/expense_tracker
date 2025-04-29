// lib/presentation/bloc/goal_form/goal_form_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/goal.dart';
import '../goal/goal_bloc.dart';
import '../goal/goal_event.dart' as goal_event;
import 'goal_form_event.dart';
import 'goal_form_state.dart';

class GoalFormBloc extends Bloc<GoalFormEvent, GoalFormState> {
  final GoalBloc goalBloc;

  GoalFormBloc({required this.goalBloc}) : super(GoalFormState.initial()) {
    on<InitializeGoalFormEvent>(_onInitializeForm);
    on<ChangeTitleEvent>(_onChangeTitle);
    on<ChangeTargetAmountEvent>(_onChangeTargetAmount);
    on<ChangeSavedAmountEvent>(_onChangeSavedAmount);
    on<ChangeStartDateEvent>(_onChangeStartDate);
    on<ChangeEndDateEvent>(_onChangeEndDate);
    on<ChangeDescriptionEvent>(_onChangeDescription);
    on<SubmitGoalFormEvent>(_onSubmitForm);
    on<SubmittingGoalFormEvent>(_onSubmittingForm);
    on<DeleteGoalEvent>(_onDeleteGoal);
  }

  void _onInitializeForm(
    InitializeGoalFormEvent event,
    Emitter<GoalFormState> emit,
  ) {
    if (event.goal != null) {
      emit(GoalFormState.fromGoal(event.goal!));
    } else {
      emit(GoalFormState.initial());
    }
  }

  void _onChangeTitle(
    ChangeTitleEvent event,
    Emitter<GoalFormState> emit,
  ) {
    final updatedState = state.copyWith(title: event.title);
    emit(updatedState.copyWith(
      isFormValid: updatedState.validateForm(),
    ));
  }

  void _onChangeTargetAmount(
    ChangeTargetAmountEvent event,
    Emitter<GoalFormState> emit,
  ) {
    final updatedState = state.copyWith(targetAmount: event.targetAmount);
    emit(updatedState.copyWith(
      isFormValid: updatedState.validateForm(),
    ));
  }

  void _onChangeSavedAmount(
    ChangeSavedAmountEvent event,
    Emitter<GoalFormState> emit,
  ) {
    final updatedState = state.copyWith(savedAmount: event.savedAmount);
    emit(updatedState.copyWith(
      isFormValid: updatedState.validateForm(),
    ));
  }

  void _onChangeStartDate(
    ChangeStartDateEvent event,
    Emitter<GoalFormState> emit,
  ) {
    // If end date is before new start date, update end date as well
    DateTime endDate = state.endDate;
    if (state.endDate.isBefore(event.startDate)) {
      endDate = event.startDate.add(const Duration(days: 1));
    }

    final updatedState = state.copyWith(
      startDate: event.startDate,
      endDate: endDate,
    );

    emit(updatedState.copyWith(
      isFormValid: updatedState.validateForm(),
    ));
  }

  void _onChangeEndDate(
    ChangeEndDateEvent event,
    Emitter<GoalFormState> emit,
  ) {
    final updatedState = state.copyWith(endDate: event.endDate);
    emit(updatedState.copyWith(
      isFormValid: updatedState.validateForm(),
    ));
  }

  void _onChangeDescription(
    ChangeDescriptionEvent event,
    Emitter<GoalFormState> emit,
  ) {
    final updatedState = state.copyWith(description: event.description);
    emit(updatedState.copyWith(
      isFormValid: updatedState.validateForm(),
    ));
  }

  void _onSubmittingForm(
    SubmittingGoalFormEvent event,
    Emitter<GoalFormState> emit,
  ) {
    emit(state.copyWith(isSubmitting: false));
  }

  void _onSubmitForm(
    SubmitGoalFormEvent event,
    Emitter<GoalFormState> emit,
  ) {
    if (!state.validateForm()) return;

    emit(state.copyWith(isSubmitting: true));

    final goal = Goal(
      id: state.id ?? const Uuid().v4(),
      title: state.title,
      targetAmount: double.parse(state.targetAmount),
      savedAmount: double.parse(state.savedAmount),
      startDate: state.startDate,
      endDate: state.endDate,
      description: state.description,
    );

    if (state.isEditing) {
      goalBloc.add(goal_event.UpdateGoalEvent(goal));
    } else {
      goalBloc.add(goal_event.AddGoalEvent(goal));
    }
  }

  void _onDeleteGoal(
    DeleteGoalEvent event,
    Emitter<GoalFormState> emit,
  ) {
    emit(state.copyWith(isSubmitting: true));
    goalBloc.add(goal_event.DeleteGoalEvent(event.id));
  }
}
