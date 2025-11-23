import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_bloc.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_event.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_state.dart';
import 'package:task_management_pro_codex/features/category/domain/entities/category_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/enums/task_priority.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_event.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_state.dart';
import 'package:task_management_pro_codex/features/task/presentation/pages/create_task_page.dart';
import 'package:task_management_pro_codex/features/task/presentation/pages/task_list_page.dart';

class _MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

class _MockCategoryBloc extends MockBloc<CategoryEvent, CategoryState>
    implements CategoryBloc {}

class _FakeTaskEvent extends Fake implements TaskEvent {}

class _FakeTaskState extends Fake implements TaskState {}

class _FakeCategoryEvent extends Fake implements CategoryEvent {}

class _FakeCategoryState extends Fake implements CategoryState {}

void main() {
  late _MockTaskBloc taskBloc;
  late _MockCategoryBloc categoryBloc;
  const task = TaskEntity(
    id: '1',
    title: 'Sample Task',
    status: 'Todo',
    priority: TaskPriority.high,
    isReminderEnabled: false,
  );

  setUpAll(() {
    registerFallbackValue(_FakeTaskEvent());
    registerFallbackValue(_FakeTaskState());
    registerFallbackValue(_FakeCategoryEvent());
    registerFallbackValue(_FakeCategoryState());
  });

  setUp(() {
    taskBloc = _MockTaskBloc();
    categoryBloc = _MockCategoryBloc();

    when(() => categoryBloc.state)
        .thenReturn(const CategoryLoaded(categories: <CategoryEntity>[]));
    when(() => categoryBloc.stream)
        .thenAnswer((_) => const Stream.empty());
  });

  Widget _wrapWithProviders(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>.value(value: taskBloc),
        BlocProvider<CategoryBloc>.value(value: categoryBloc),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('TaskListPage shows tasks when loaded', (tester) async {
    when(() => taskBloc.state).thenReturn(TaskLoaded(tasks: const [task]));
    when(() => taskBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_wrapWithProviders(const TaskListPage()));
    await tester.pumpAndSettle();

    expect(find.text('Sample Task'), findsOneWidget);
  });

  testWidgets('Search dispatches SearchTasks event', (tester) async {
    when(() => taskBloc.state).thenReturn(TaskLoaded(tasks: const [task]));
    when(() => taskBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => taskBloc.add(any())).thenAnswer((_) {});

    await tester.pumpWidget(_wrapWithProviders(const TaskListPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'demo');
    await tester.pump();

    verify(() => taskBloc.add(const SearchTasks('demo'))).called(1);
  });

  testWidgets('Filter drawer applies FilterTasks', (tester) async {
    when(() => taskBloc.state).thenReturn(TaskLoaded(tasks: const [task]));
    when(() => taskBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => taskBloc.add(any())).thenAnswer((_) {});

    when(() => categoryBloc.state).thenReturn(
      const CategoryLoaded(
        categories: [
          CategoryEntity(id: 'work', name: 'Work', colorValue: 0xFF000000),
        ],
      ),
    );
    when(() => categoryBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_wrapWithProviders(const TaskListPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Priority'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('High').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Apply'));
    await tester.pump();

    verify(
      () => taskBloc.add(
        const FilterTasks(status: null, priority: 'High', categoryId: null),
      ),
    ).called(1);
  });

  testWidgets('CreateTaskPage validates empty title', (tester) async {
    when(() => taskBloc.state).thenReturn(const TaskInitial());
    when(() => taskBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => taskBloc.add(any())).thenAnswer((_) {});

    await tester.pumpWidget(
      BlocProvider<TaskBloc>.value(
        value: taskBloc,
        child: const MaterialApp(home: CreateTaskPage()),
      ),
    );

    await tester.tap(find.text('Create Task'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a title'), findsOneWidget);
  });
}
