import 'package:task_management_pro_codex/core/error/failures.dart';
import 'package:task_management_pro_codex/features/category/domain/entities/category_entity.dart';
import 'package:task_management_pro_codex/features/category/domain/repositories/category_repository.dart';

class InMemoryCategoryRepository implements CategoryRepository {
  InMemoryCategoryRepository();

  final List<CategoryEntity> _categories = const [
    CategoryEntity(id: 'work', name: 'Work', colorValue: 0xFF1565C0),
    CategoryEntity(id: 'personal', name: 'Personal', colorValue: 0xFF6A1B9A),
    CategoryEntity(id: 'shopping', name: 'Shopping', colorValue: 0xFF2E7D32),
    CategoryEntity(id: 'other', name: 'Other', colorValue: 0xFF546E7A),
  ];

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    await Future.delayed(const Duration(seconds: 3));
    return Either.right(_categories);
  }
}
