import 'package:sqflite/sqflite.dart';

import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getCachedTasks();

  Future<void> cacheTasks(List<TaskModel> tasks);

  Future<void> insertTask(TaskModel task);

  Future<void> updateTask(TaskModel task);

  Future<void> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  TaskLocalDataSourceImpl(this.database);

  final Database database;

  @override
  Future<List<TaskModel>> getCachedTasks() {
    // TODO: implement getCachedTasks
    throw UnimplementedError();
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) {
    // TODO: implement cacheTasks
    throw UnimplementedError();
  }

  @override
  Future<void> insertTask(TaskModel task) {
    // TODO: implement insertTask
    throw UnimplementedError();
  }

  @override
  Future<void> updateTask(TaskModel task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTask(String id) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }
}
