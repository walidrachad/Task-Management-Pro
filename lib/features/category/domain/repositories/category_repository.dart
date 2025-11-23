import 'package:task_management_pro_codex/core/error/failures.dart';
import 'package:task_management_pro_codex/features/category/domain/entities/category_entity.dart';

/// Minimal Either implementation used to wrap success and failure results.
class Either<L, R> {
  const Either._({this.left, this.right});

  final L? left;
  final R? right;

  bool get isLeft => left != null;

  bool get isRight => left == null;

  const factory Either.left(L value) = _Left<L, R>;

  const factory Either.right(R value) = _Right<L, R>;
}

class _Left<L, R> extends Either<L, R> {
  const _Left(L value) : super._(left: value);
}

class _Right<L, R> extends Either<L, R> {
  const _Right(R value) : super._(right: value);
}

/// Contract for category repository implementations.
abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
