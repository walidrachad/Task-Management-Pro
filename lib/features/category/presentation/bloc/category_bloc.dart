import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/features/category/domain/entities/category_entity.dart';
import 'package:task_management_pro_codex/features/category/domain/usecases/get_categories.dart';

import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({required this.getCategories}) : super(const CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  final GetCategories getCategories;

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());

    final result = await getCategories();

    if (result.isRight) {
      emit(CategoryLoaded(categories: result.right ?? <CategoryEntity>[]));
    } else {
      emit(
        CategoryError(
          message: result.left?.message ?? 'Failed to load categories',
        ),
      );
    }
  }
}
