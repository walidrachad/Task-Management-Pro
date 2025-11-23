import 'package:sqflite/sqflite.dart';
import 'package:task_management_pro_codex/core/error/failures.dart';
import 'package:task_management_pro_codex/core/constants/database_constants.dart';
import 'package:task_management_pro_codex/core/providers/database/database_helper.dart';
import 'package:task_management_pro_codex/features/task/data/models/task_db_model.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/repositories/task_repository.dart';

class SQLiteTaskRepository implements TaskRepository {
  SQLiteTaskRepository({required this.databaseHelper});

  final DatabaseHelper databaseHelper;

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final db = await _db;
      final rows = await db.query(DatabaseConstants.tasksTable);
      final tasks =
          rows.map((row) => _mapRowToEntity(row)).whereType<TaskEntity>().toList();
      return Either.right(tasks);
    } catch (e) {
      return Either.left(CacheFailure(message: 'Failed to load tasks'));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> getTask(String id) async {
    try {
      final db = await _db;
      final rows = await db.query(
        DatabaseConstants.tasksTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (rows.isEmpty) {
        return const Either.left(ValidationFailure(message: 'Task not found'));
      }

      final entity = _mapRowToEntity(rows.first);
      if (entity == null) {
        return const Either.left(CacheFailure(message: 'Invalid task data'));
      }

      return Either.right(entity);
    } catch (e) {
      return Either.left(CacheFailure(message: 'Failed to load task'));
    }
  }

  @override
  Future<Either<Failure, void>> createTask(TaskEntity task) async {
    try {
      final db = await _db;
      final model = TaskDbModel.fromEntity(task);
      await db.insert(
        DatabaseConstants.tasksTable,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(message: 'Failed to create task'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    try {
      final db = await _db;
      final model = TaskDbModel.fromEntity(task);
      final updated = await db.update(
        DatabaseConstants.tasksTable,
        model.toMap(),
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [task.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (updated == 0) {
        return const Either.left(ValidationFailure(message: 'Task not found'));
      }

      return const Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(message: 'Failed to update task'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      final db = await _db;
      final deleted = await db.delete(
        DatabaseConstants.tasksTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
      );

      if (deleted == 0) {
        return const Either.left(ValidationFailure(message: 'Task not found'));
      }

      return const Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(message: 'Failed to delete task'));
    }
  }

  Future<Database> get _db => databaseHelper.database;

  TaskEntity? _mapRowToEntity(Map<String, Object?> row) {
    try {
      final model = TaskDbModel(
        id: row[DatabaseConstants.columnId] as String,
        title: row[DatabaseConstants.columnTitle] as String,
        description: row[DatabaseConstants.columnDescription] as String?,
        dueDateMillis: row[DatabaseConstants.columnDueDate] as int?,
        status: row[DatabaseConstants.columnStatus] as String,
        priority: row[DatabaseConstants.columnPriority] as String,
        categoryId: row[DatabaseConstants.columnCategoryId] as String?,
        isReminderEnabled:
            (row[DatabaseConstants.columnReminderEnabled] as int? ?? 0) == 1,
      );
      return model.toEntity();
    } catch (_) {
      return null;
    }
  }
}
