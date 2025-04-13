import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/category.dart';
import '../../repositories/category_repository.dart';

class UpdateCategory implements UseCase<void, Category> {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  @override
  Future<Either<Failure, void>> call(Category params) async {
    return await repository.updateCategory(params);
  }
}
