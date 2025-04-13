import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource dataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await dataSource.getAllCategories();
        return Right(categories);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final category = await dataSource.getCategoryById(id);
        return Right(category);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addCategory(Category category) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.addCategory(CategoryModel.fromEntity(category));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(Category category) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.updateCategory(CategoryModel.fromEntity(category));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.deleteCategory(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
