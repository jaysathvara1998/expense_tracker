import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/goal_repository.dart';

class DeleteGoal implements UseCase<void, Params> {
  final GoalRepository repository;

  DeleteGoal(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.deleteGoal(params.id);
  }
}

class Params extends Equatable {
  final String id;

  const Params({required this.id});

  @override
  List<Object> get props => [id];
}
