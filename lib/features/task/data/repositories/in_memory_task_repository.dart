import 'package:task_management_pro_codex/core/error/failures.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/enums/task_priority.dart';
import 'package:task_management_pro_codex/features/task/domain/repositories/task_repository.dart';

/// Simple in-memory repository used to power the demo UI without a backend.
class InMemoryTaskRepository implements TaskRepository {
  InMemoryTaskRepository();

  final List<TaskEntity> _tasks = [
    TaskEntity(
      id: '1',
      title: 'Plan sprint backlog',
      description: 'Review incoming tasks and plan priorities for the week.',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      status: 'In Progress',
      priority: TaskPriority.high,
      categoryId: 'work',
      isReminderEnabled: true,
    ),
    TaskEntity(
      id: '2',
      title: 'Grocery run',
      description: 'Pick up veggies, milk, and bread on the way home.',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      status: 'Pending',
      priority: TaskPriority.medium,
      categoryId: 'personal',
      isReminderEnabled: false,
    ),
  ];

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    return Either.right(List<TaskEntity>.unmodifiable(_tasks));
  }

  @override
  Future<Either<Failure, TaskEntity>> getTask(String id) async {
    TaskEntity? task;
    for (final item in _tasks) {
      if (item.id == id) {
        task = item;
        break;
      }
    }

    if (task == null) {
      return const Either.left(ValidationFailure(message: 'Task not found'));
    }

    return Either.right(task);
  }

  @override
  Future<Either<Failure, void>> createTask(TaskEntity task) async {
    _tasks.add(task);
    return const Either.right(null);
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    final index = _tasks.indexWhere((element) => element.id == task.id);
    if (index == -1) {
      return const Either.left(ValidationFailure(message: 'Task not found'));
    }

    _tasks[index] = task;
    return const Either.right(null);
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == id);

    if (_tasks.length == initialLength) {
      return const Either.left(ValidationFailure(message: 'Task not found'));
    }

    return const Either.right(null);
  }
}
