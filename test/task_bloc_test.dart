import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_pro_codex/core/error/failures.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/enums/task_priority.dart';
import 'package:task_management_pro_codex/features/task/domain/repositories/task_repository.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/create_task.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/delete_task.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/get_task.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/get_tasks.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/update_task.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_event.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_state.dart';

class _TestTaskRepository implements TaskRepository {
  _TestTaskRepository({this.failure});

  Failure? failure;
  final List<TaskEntity> _store = [
    const TaskEntity(
      id: '1',
      title: 'Test task',
      status: 'Todo',
      priority: TaskPriority.high,
      isReminderEnabled: false,
    ),
  ];

  @override
  Future<Either<Failure, void>> createTask(TaskEntity task) async {
    if (failure != null) return Either.left(failure!);
    _store.add(task);
    return const Either.right(null);
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    if (failure != null) return Either.left(failure!);
    _store.removeWhere((task) => task.id == id);
    return const Either.right(null);
  }

  @override
  Future<Either<Failure, TaskEntity>> getTask(String id) async {
    if (failure != null) return Either.left(failure!);
    final found = _store.firstWhere((task) => task.id == id);
    return Either.right(found);
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    if (failure != null) return Either.left(failure!);
    return Either.right(List<TaskEntity>.from(_store));
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    if (failure != null) return Either.left(failure!);
    final index = _store.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      _store[index] = task;
    }
    return const Either.right(null);
  }
}

void main() {
  late _TestTaskRepository repository;
  late TaskBloc bloc;

  setUp(() {
    repository = _TestTaskRepository();
    bloc = TaskBloc(
      getTasks: GetTasks(repository),
      getTask: GetTask(repository),
      createTask: CreateTask(repository),
      updateTask: UpdateTask(repository),
      deleteTask: DeleteTask(repository),
    );
  });

  blocTest<TaskBloc, TaskState>(
    'emits loading then loaded on LoadTasks success',
    build: () => bloc,
    act: (bloc) => bloc.add(const LoadTasks()),
    expect: () => [
      const TaskLoading(),
      isA<TaskLoaded>(),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'emits error when repository returns failure',
    build: () {
      repository.failure = const ServerFailure(message: 'boom');
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadTasks()),
    expect: () => [
      const TaskLoading(),
      isA<TaskError>(),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'emits loaded with filtered tasks on SearchTasks',
    build: () => bloc,
    act: (bloc) => bloc
      ..add(const LoadTasks())
      ..add(const SearchTasks('test')),
    expect: () => [
      const TaskLoading(),
      isA<TaskLoaded>(),
      const TaskLoading(),
      isA<TaskLoaded>().having((state) => state.tasks.length, 'filtered length', 1),
    ],
  );
}
