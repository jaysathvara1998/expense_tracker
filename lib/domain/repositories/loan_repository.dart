import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/loan.dart';

abstract class LoanRepository {
  Future<Either<Failure, List<Loan>>> getAllLoans();
  Future<Either<Failure, Loan>> getLoanById(String id);
  Future<Either<Failure, void>> addLoan(Loan loan);
  Future<Either<Failure, void>> updateLoan(Loan loan);
  Future<Either<Failure, void>> deleteLoan(String id);
  Future<Either<Failure, List<Loan>>> getLoansWithReminders();
}
