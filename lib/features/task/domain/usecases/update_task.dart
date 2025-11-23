import 'package:task_management_pro_codex/core/error/failures.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/repositories/task_repository.dart';

class UpdateTask {
  const UpdateTask(this.repository);

  final TaskRepository repository;

  Future<Either<Failure, void>> call(TaskEntity task) {
    return repository.updateTask(task);
  }
}
