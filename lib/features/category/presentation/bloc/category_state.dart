import 'package:equatable/equatable.dart';
import 'package:task_management_pro_codex/features/category/domain/entities/category_entity.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoryState {
  const CategoryLoaded({required this.categories});

  final List<CategoryEntity> categories;

  @override
  List<Object?> get props => [categories];
}

class CategoryError extends CategoryState {
  const CategoryError({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}
