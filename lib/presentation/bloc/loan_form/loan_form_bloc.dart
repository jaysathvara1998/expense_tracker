// lib/presentation/bloc/loan_form/loan_form_bloc.dart
import 'package:expanse_tracker/presentation/bloc/loan_form/loan_form_event.dart';
import 'package:expanse_tracker/presentation/bloc/loan_form/loan_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/loan.dart';
import '../loan/loan_bloc.dart';
import '../loan/loan_event.dart' as loan_event;

class LoanFormBloc extends Bloc<LoanFormEvent, LoanFormState> {
  final LoanBloc loanBloc;

  LoanFormBloc({required this.loanBloc}) : super(LoanFormState.initial()) {
    on<InitializeLoanFormEvent>(_onInitializeForm);
    on<ChangeLoanTypeEvent>(_onChangeLoanType);
    on<ChangePersonNameEvent>(_onChangePersonName);
    on<ChangeAmountEvent>(_onChangeAmount);
    on<ChangeDateEvent>(_onChangeDate);
    on<ChangeDueDateEvent>(_onChangeDueDate);
    on<ChangeDescriptionEvent>(_onChangeDescription);
    on<ChangeReminderStatusEvent>(_onChangeReminderStatus);
    on<ChangeSettledStatusEvent>(_onChangeSettledStatus);
    on<SubmitLoanFormEvent>(_onSubmitForm);
    on<SubmittingLoanFormEvent>(_onSubmittingForm);
    on<DeleteLoanEvent>(_onDeleteLoan);
  }

  void _onInitializeForm(
    InitializeLoanFormEvent event,
    Emitter<LoanFormState> emit,
  ) {
    if (event.loan != null) {
      emit(LoanFormState.fromLoan(event.loan!));
    } else {
      emit(LoanFormState.initial());
    }
  }

  void _onChangeLoanType(
    ChangeLoanTypeEvent event,
    Emitter<LoanFormState> emit,
  ) {
    final isFormValid = state.copyWith(type: event.type).validateForm();
    emit(state.copyWith(
      type: event.type,
      isFormValid: isFormValid,
    ));
  }

  void _onChangePersonName(
    ChangePersonNameEvent event,
    Emitter<LoanFormState> emit,
  ) {
    final isFormValid =
        state.copyWith(personName: event.personName).validateForm();
    emit(state.copyWith(
      personName: event.personName,
      isFormValid: isFormValid,
    ));
  }

  void _onChangeAmount(
    ChangeAmountEvent event,
    Emitter<LoanFormState> emit,
  ) {
    final isFormValid = state.copyWith(amount: event.amount).validateForm();
    emit(state.copyWith(
      amount: event.amount,
      isFormValid: isFormValid,
    ));
  }

  void _onChangeDate(
    ChangeDateEvent event,
    Emitter<LoanFormState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }

  void _onChangeDueDate(
    ChangeDueDateEvent event,
    Emitter<LoanFormState> emit,
  ) {
    emit(state.copyWith(dueDate: event.dueDate ?? LoanFormState));
  }

  void _onChangeDescription(
    ChangeDescriptionEvent event,
    Emitter<LoanFormState> emit,
  ) {
    final isFormValid =
        state.copyWith(description: event.description).validateForm();
    emit(state.copyWith(
      description: event.description,
      isFormValid: isFormValid,
    ));
  }

  void _onChangeReminderStatus(
    ChangeReminderStatusEvent event,
    Emitter<LoanFormState> emit,
  ) {
    emit(state.copyWith(hasReminder: event.hasReminder));
  }

  void _onChangeSettledStatus(
    ChangeSettledStatusEvent event,
    Emitter<LoanFormState> emit,
  ) {
    emit(state.copyWith(isSettled: event.isSettled));
  }

  void _onSubmittingForm(
    SubmittingLoanFormEvent event,
    Emitter<LoanFormState> emit,
  ) {
    emit(state.copyWith(isSubmitting: true));
  }

  void _onSubmitForm(
    SubmitLoanFormEvent event,
    Emitter<LoanFormState> emit,
  ) {
    if (!state.isFormValid) return;

    emit(state.copyWith(isSubmitting: true));

    final loan = Loan(
      id: state.id ?? const Uuid().v4(),
      personName: state.personName,
      amount: double.parse(state.amount),
      date: state.date,
      dueDate: state.dueDate,
      description: state.description,
      hasReminder: state.hasReminder,
      type: state.type,
      isSettled: state.isSettled,
    );

    if (state.isEditing) {
      loanBloc.add(loan_event.UpdateLoanEvent(loan));
    } else {
      loanBloc.add(loan_event.AddLoanEvent(loan));
    }
  }

  void _onDeleteLoan(
    DeleteLoanEvent event,
    Emitter<LoanFormState> emit,
  ) {
    emit(state.copyWith(isSubmitting: true));
    loanBloc.add(loan_event.DeleteLoanEvent(event.id));
  }
}
