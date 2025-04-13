import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/loan/add_loan.dart';
import '../../../domain/usecases/loan/delete_loan.dart' as delete;
import '../../../domain/usecases/loan/get_all_loans.dart';
import '../../../domain/usecases/loan/get_loans_with_reminders.dart';
import '../../../domain/usecases/loan/update_loan.dart';
import 'loan_event.dart';
import 'loan_state.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final GetAllLoans getAllLoans;
  final GetLoansWithReminders getLoansWithReminders;
  final AddLoan addLoan;
  final UpdateLoan updateLoan;
  final delete.DeleteLoan deleteLoan;

  LoanBloc({
    required this.getAllLoans,
    required this.getLoansWithReminders,
    required this.addLoan,
    required this.updateLoan,
    required this.deleteLoan,
  }) : super(LoanInitial()) {
    on<GetAllLoansEvent>(_onGetAllLoans);
    on<GetLoansWithRemindersEvent>(_onGetLoansWithReminders);
    on<AddLoanEvent>(_onAddLoan);
    on<UpdateLoanEvent>(_onUpdateLoan);
    on<DeleteLoanEvent>(_onDeleteLoan);
  }

  Future<void> _onGetAllLoans(
    GetAllLoansEvent event,
    Emitter<LoanState> emit,
  ) async {
    emit(LoanLoading());
    final result = await getAllLoans(NoParams());

    result.fold(
      (failure) => emit(const LoanOperationFailure('Failed to load loans')),
      (loans) => emit(LoansLoaded(loans)),
    );
  }

  Future<void> _onGetLoansWithReminders(
    GetLoansWithRemindersEvent event,
    Emitter<LoanState> emit,
  ) async {
    emit(LoanLoading());
    final result = await getLoansWithReminders(NoParams());

    result.fold(
      (failure) =>
          emit(const LoanOperationFailure('Failed to load reminder loans')),
      (loans) => emit(ReminderLoansLoaded(loans)),
    );
  }

  Future<void> _onAddLoan(
    AddLoanEvent event,
    Emitter<LoanState> emit,
  ) async {
    emit(LoanLoading());
    final result = await addLoan(event.loan);

    result.fold(
      (failure) => emit(const LoanOperationFailure('Failed to add loan')),
      (_) {
        add(GetAllLoansEvent());
      },
    );
  }

  Future<void> _onUpdateLoan(
    UpdateLoanEvent event,
    Emitter<LoanState> emit,
  ) async {
    emit(LoanLoading());
    final result = await updateLoan(event.loan);

    result.fold(
      (failure) => emit(const LoanOperationFailure('Failed to update loan')),
      (_) {
        add(GetAllLoansEvent());
      },
    );
  }

  Future<void> _onDeleteLoan(
    DeleteLoanEvent event,
    Emitter<LoanState> emit,
  ) async {
    emit(LoanLoading());
    final result = await deleteLoan(delete.Params(id: event.id));

    result.fold(
      (failure) => emit(const LoanOperationFailure('Failed to delete loan')),
      (_) {
        add(GetAllLoansEvent());
      },
    );
  }
}
