import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/goal.dart';

abstract class GoalRepository {
  Future<Either<Failure, List<Goal>>> getAllGoals();
  Future<Either<Failure, Goal>> getGoalById(String id);
  Future<Either<Failure, void>> addGoal(Goal goal);
  Future<Either<Failure, void>> updateGoal(Goal goal);
  Future<Either<Failure, void>> deleteGoal(String id);
}
