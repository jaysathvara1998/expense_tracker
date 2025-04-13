import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/goal.dart';
import '../../repositories/goal_repository.dart';

class AddGoal implements UseCase<void, Goal> {
  final GoalRepository repository;

  AddGoal(this.repository);

  @override
  Future<Either<Failure, void>> call(Goal params) async {
    return await repository.addGoal(params);
  }
}
