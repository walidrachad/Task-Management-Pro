import 'package:equatable/equatable.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  const TaskLoaded({
    required this.tasks,
    this.statusFilter,
    this.priorityFilter,
    this.categoryFilter,
    this.searchQuery,
  });

  final List<TaskEntity> tasks;
  final String? statusFilter;
  final String? priorityFilter;
  final String? categoryFilter;
  final String? searchQuery;

  @override
  List<Object?> get props => [
        tasks,
        statusFilter,
        priorityFilter,
        categoryFilter,
        searchQuery,
      ];
}

class TaskEmpty extends TaskState {
  const TaskEmpty({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

class TaskError extends TaskState {
  const TaskError({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}
