import 'package:task_management_pro_codex/core/error/failures.dart';
import 'package:task_management_pro_codex/features/category/domain/entities/category_entity.dart';
import 'package:task_management_pro_codex/features/category/domain/repositories/category_repository.dart';

class GetCategories {
  const GetCategories(this.repository);

  final CategoryRepository repository;

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}
