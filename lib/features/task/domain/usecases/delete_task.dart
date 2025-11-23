import 'package:task_management_pro_codex/core/error/failures.dart';
import 'package:task_management_pro_codex/features/task/domain/repositories/task_repository.dart';

class DeleteTask {
  const DeleteTask(this.repository);

  final TaskRepository repository;

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteTask(id);
  }
}
