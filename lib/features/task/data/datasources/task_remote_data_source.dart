import 'package:dio/dio.dart';

import '../models/task_model.dart';

const String kTaskApiBaseUrl = 'https://mockapi.example.com';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> fetchTasks();

  Future<TaskModel> fetchTask(String id);

  Future<void> createTask(TaskModel task);

  Future<void> updateTask(TaskModel task);

  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  TaskRemoteDataSourceImpl(this.client);

  final Dio client;

  @override
  Future<List<TaskModel>> fetchTasks() {
    // TODO: implement fetchTasks
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> fetchTask(String id) {
    // TODO: implement fetchTask
    throw UnimplementedError();
  }

  @override
  Future<void> createTask(TaskModel task) {
    // TODO: implement createTask
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

