import 'package:equatable/equatable.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}

class RefreshTasks extends TaskEvent {
  const RefreshTasks();
}

class CreateTaskEvent extends TaskEvent {
  const CreateTaskEvent(this.task);

  final TaskEntity task;

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  const UpdateTaskEvent(this.task);

  final TaskEntity task;

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  const DeleteTaskEvent(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class SearchTasks extends TaskEvent {
  const SearchTasks(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class FilterTasks extends TaskEvent {
  const FilterTasks({
    this.status,
    this.priority,
    this.categoryId,
  });

  final String? status;
  final String? priority;
  final String? categoryId;

  @override
  List<Object?> get props => [status, priority, categoryId];
}

enum SortField { date, priority, status }

class SortTasks extends TaskEvent {
  const SortTasks(this.sortBy);

  final SortField sortBy;

  @override
  List<Object?> get props => [sortBy];
}
