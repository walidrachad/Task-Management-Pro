import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_pro_codex/core/error/failures.dart';
import 'package:task_management_pro_codex/features/category/domain/entities/category_entity.dart';
import 'package:task_management_pro_codex/features/category/domain/repositories/category_repository.dart';
import 'package:task_management_pro_codex/features/category/domain/usecases/get_categories.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_bloc.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_event.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_state.dart';

class _TestCategoryRepository implements CategoryRepository {
  _TestCategoryRepository({this.failure});

  Failure? failure;
  final List<CategoryEntity> categories = const [
    CategoryEntity(id: 'c1', name: 'Work', colorValue: 0xFF000000),
  ];

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (failure != null) return Either.left(failure!);
    return Either.right(categories);
  }
}

void main() {
  late _TestCategoryRepository repository;

  setUp(() {
    repository = _TestCategoryRepository();
  });

  blocTest<CategoryBloc, CategoryState>(
    'emits loading then loaded on success',
    build: () => CategoryBloc(getCategories: GetCategories(repository)),
    act: (bloc) => bloc.add(const LoadCategories()),
    expect: () => [
      const CategoryLoading(),
      isA<CategoryLoaded>()
          .having((state) => state.categories.length, 'count', 1),
    ],
  );

  blocTest<CategoryBloc, CategoryState>(
    'emits error on failure',
    build: () {
      repository.failure = const ServerFailure(message: 'fail');
      return CategoryBloc(getCategories: GetCategories(repository));
    },
    act: (bloc) => bloc.add(const LoadCategories()),
    expect: () => [
      const CategoryLoading(),
      isA<CategoryError>(),
    ],
  );
}
