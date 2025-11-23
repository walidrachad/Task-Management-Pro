import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/enums/task_priority.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/create_task.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/delete_task.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/get_task.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/get_tasks.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/update_task.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_event.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required this.getTasks,
    required this.getTask,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(const TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<RefreshTasks>(_onLoadTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<SearchTasks>(_onSearchTasks);
    on<FilterTasks>(_onFilterTasks);
    on<SortTasks>(_onSortTasks);
  }

  final GetTasks getTasks;
  final GetTask getTask;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  Future<void> _onLoadTasks(TaskEvent event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());

    final result = await getTasks();
    if (result.isRight) {
      final tasks = result.right ?? <TaskEntity>[];
      if (tasks.isEmpty) {
        emit(const TaskEmpty(message: 'No tasks found'));
      } else {
        emit(TaskLoaded(tasks: tasks));
      }
    } else {
      emit(TaskError(message: result.left?.message ?? 'Failed to load tasks'));
    }
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await createTask(event.task);
    if (result.isRight) {
      add(const LoadTasks());
    } else {
      emit(
        TaskError(message: result.left?.message ?? 'Failed to create task'),
      );
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await updateTask(event.task);
    if (result.isRight) {
      add(const LoadTasks());
    } else {
      emit(
        TaskError(message: result.left?.message ?? 'Failed to update task'),
      );
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await deleteTask(event.id);
    if (result.isRight) {
      add(const LoadTasks());
    } else {
      emit(
        TaskError(message: result.left?.message ?? 'Failed to delete task'),
      );
    }
  }

  Future<void> _onSearchTasks(
    SearchTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await getTasks();
    if (result.isRight) {
      final tasks = result.right ?? <TaskEntity>[];
      final query = event.query.toLowerCase();
      final filtered = tasks
          .where(
            (task) =>
                task.title.toLowerCase().contains(query) ||
                (task.description?.toLowerCase().contains(query) ?? false),
          )
          .toList();

      if (filtered.isEmpty) {
        emit(const TaskEmpty(message: 'No tasks match the search query'));
      } else {
        emit(TaskLoaded(tasks: filtered, searchQuery: event.query));
      }
    } else {
      emit(TaskError(message: result.left?.message ?? 'Failed to search tasks'));
    }
  }

  Future<void> _onFilterTasks(
    FilterTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await getTasks();
    if (result.isRight) {
      final tasks = result.right ?? <TaskEntity>[];
      final filtered = tasks.where((task) {
        final matchesStatus =
            event.status == null || task.status == event.status;
        final matchesPriority =
            event.priority == null || task.priority == event.priority;
        final matchesCategory =
            event.categoryId == null || task.categoryId == event.categoryId;

        return matchesStatus && matchesPriority && matchesCategory;
      }).toList();

      if (filtered.isEmpty) {
        emit(const TaskEmpty(message: 'No tasks match the filter criteria'));
      } else {
        emit(
          TaskLoaded(
            tasks: filtered,
            statusFilter: event.status,
            priorityFilter: event.priority,
            categoryFilter: event.categoryId,
          ),
        );
      }
    } else {
      emit(TaskError(message: result.left?.message ?? 'Failed to filter tasks'));
    }
  }

  Future<void> _onSortTasks(
    SortTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await getTasks();
    if (result.isRight) {
      final tasks = List<TaskEntity>.from(result.right ?? <TaskEntity>[]);
      tasks.sort((a, b) {
        switch (event.sortBy) {
          case SortField.date:
            final aDate = a.dueDate;
            final bDate = b.dueDate;
            if (aDate == null && bDate == null) return 0;
            if (aDate == null) return 1;
            if (bDate == null) return -1;
            return aDate.compareTo(bDate);
          case SortField.priority:
            return _priorityOrder(a.priority).compareTo(_priorityOrder(b.priority));
          case SortField.status:
            return _statusOrder(a.status).compareTo(_statusOrder(b.status));
        }
      });
      emit(TaskLoaded(tasks: tasks));
    } else {
      emit(TaskError(message: result.left?.message ?? 'Failed to sort tasks'));
    }
  }

  int _priorityOrder(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 0;
      case TaskPriority.medium:
        return 1;
      case TaskPriority.high:
        return 2;
      case TaskPriority.urgent:
        return 3;
      default:
        return 4;
    }
  }

  int _statusOrder(String status) {
    switch (status.toLowerCase()) {
      case 'todo':
        return 0;
      case 'in progress':
        return 1;
      case 'completed':
        return 2;
      default:
        return 3;
    }
  }
}
