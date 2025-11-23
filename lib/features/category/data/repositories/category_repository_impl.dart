import 'package:task_management_pro_codex/core/error/failures.dart';
import 'package:task_management_pro_codex/features/category/data/datasources/category_remote_data_source.dart';
import 'package:task_management_pro_codex/features/category/data/models/category_model.dart';
import 'package:task_management_pro_codex/features/category/domain/entities/category_entity.dart';
import 'package:task_management_pro_codex/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({
    required this.remoteDataSource,
  });

  final CategoryRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final List<CategoryModel> categories = await remoteDataSource.fetchCategories();
      final List<CategoryEntity> entities = categories
          .map(
            (CategoryModel model) => CategoryEntity(
              id: model.id,
              name: model.name,
              colorValue: model.colorValue,
            ),
          )
          .toList();
      return Either.right(entities);
    } catch (error) {
      return Either.left(ServerFailure(message: error.toString()));
    }
  }
}
