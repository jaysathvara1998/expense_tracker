import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/loan_repository.dart';

class DeleteLoan implements UseCase<void, Params> {
  final LoanRepository repository;

  DeleteLoan(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.deleteLoan(params.id);
  }
}

class Params extends Equatable {
  final String id;

  const Params({required this.id});

  @override
  List<Object> get props => [id];
}
