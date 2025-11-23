import 'package:task_management_pro_codex/core/error/failures.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/repositories/task_repository.dart';

class GetTask {
  const GetTask(this.repository);

  final TaskRepository repository;

  Future<Either<Failure, TaskEntity>> call(String id) {
    return repository.getTask(id);
  }
}
