import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/goal.dart';
import '../../repositories/goal_repository.dart';

class UpdateGoal implements UseCase<void, Goal> {
  final GoalRepository repository;

  UpdateGoal(this.repository);

  @override
  Future<Either<Failure, void>> call(Goal params) async {
    return await repository.updateGoal(params);
  }
}
