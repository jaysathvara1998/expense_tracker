import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/goal.dart';
import '../../repositories/goal_repository.dart';

class GetAllGoals implements UseCase<List<Goal>, NoParams> {
  final GoalRepository repository;

  GetAllGoals(this.repository);

  @override
  Future<Either<Failure, List<Goal>>> call(NoParams params) async {
    return await repository.getAllGoals();
  }
}
