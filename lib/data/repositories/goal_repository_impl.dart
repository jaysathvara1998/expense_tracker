import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goal_repository.dart';
import '../datasources/goal_datasource.dart';
import '../models/goal_model.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalDataSource dataSource;
  final NetworkInfo networkInfo;

  GoalRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Goal>>> getAllGoals() async {
    if (await networkInfo.isConnected) {
      try {
        final goals = await dataSource.getAllGoals();
        return Right(goals);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Goal>> getGoalById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final goal = await dataSource.getGoalById(id);
        return Right(goal);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addGoal(Goal goal) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.addGoal(GoalModel.fromEntity(goal));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateGoal(Goal goal) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.updateGoal(GoalModel.fromEntity(goal));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoal(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.deleteGoal(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
