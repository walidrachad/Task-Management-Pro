import 'package:task_management_pro_codex/core/error/failures.dart';
import 'package:task_management_pro_codex/features/task/data/datasources/task_local_data_source.dart';
import 'package:task_management_pro_codex/features/task/data/datasources/task_remote_data_source.dart';
import 'package:task_management_pro_codex/features/task/data/models/task_model.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final List<TaskModel> tasks = await remoteDataSource.fetchTasks();
      await localDataSource.cacheTasks(tasks);
      return Either.right(tasks);
    } catch (error) {
      try {
        final List<TaskModel> cachedTasks = await localDataSource.getCachedTasks();
        return Either.right(cachedTasks);
      } catch (cacheError) {
        return Either.left(CacheFailure(message: cacheError.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> getTask(String id) async {
    try {
      final TaskModel task = await remoteDataSource.fetchTask(id);
      await localDataSource.insertTask(task);
      return Either.right(task);
    } catch (error) {
      try {
        final List<TaskModel> cachedTasks = await localDataSource.getCachedTasks();
        for (final TaskModel task in cachedTasks) {
          if (task.id == id) {
            return Either.right(task);
          }
        }
        return Either.left(ServerFailure(message: 'Task not found'));
      } catch (cacheError) {
        return Either.left(CacheFailure(message: cacheError.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> createTask(TaskEntity task) async {
    final TaskModel model = _toModel(task);
    try {
      await remoteDataSource.createTask(model);
    } catch (error) {
      return Either.left(ServerFailure(message: error.toString()));
    }

    try {
      await localDataSource.insertTask(model);
      return const Either.right(null);
    } catch (cacheError) {
      return Either.left(CacheFailure(message: cacheError.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    final TaskModel model = _toModel(task);
    try {
      await remoteDataSource.updateTask(model);
    } catch (error) {
      return Either.left(ServerFailure(message: error.toString()));
    }

    try {
      await localDataSource.updateTask(model);
      return const Either.right(null);
    } catch (cacheError) {
      return Either.left(CacheFailure(message: cacheError.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await remoteDataSource.deleteTask(id);
    } catch (error) {
      return Either.left(ServerFailure(message: error.toString()));
    }

    try {
      await localDataSource.deleteTask(id);
      return const Either.right(null);
    } catch (cacheError) {
      return Either.left(CacheFailure(message: cacheError.toString()));
    }
  }

  TaskModel _toModel(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate,
      status: entity.status,
      priority: entity.priority,
      categoryId: entity.categoryId,
      isReminderEnabled: entity.isReminderEnabled,
    );
  }
}
