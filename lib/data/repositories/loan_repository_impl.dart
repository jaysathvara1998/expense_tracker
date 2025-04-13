import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/loan.dart';
import '../../domain/repositories/loan_repository.dart';
import '../datasources/loan_datasource.dart';
import '../models/loan_model.dart';

class LoanRepositoryImpl implements LoanRepository {
  final LoanDataSource dataSource;
  final NetworkInfo networkInfo;

  LoanRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Loan>>> getAllLoans() async {
    if (await networkInfo.isConnected) {
      try {
        final loans = await dataSource.getAllLoans();
        return Right(loans);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Loan>> getLoanById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final loan = await dataSource.getLoanById(id);
        return Right(loan);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addLoan(Loan loan) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.addLoan(LoanModel.fromEntity(loan));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateLoan(Loan loan) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.updateLoan(LoanModel.fromEntity(loan));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteLoan(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.deleteLoan(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Loan>>> getLoansWithReminders() async {
    if (await networkInfo.isConnected) {
      try {
        final loans = await dataSource.getLoansWithReminders();
        return Right(loans);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
