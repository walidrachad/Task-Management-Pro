import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_pro_codex/features/category/data/repositories/in_memory_category_repository.dart';
import 'package:task_management_pro_codex/features/category/domain/repositories/category_repository.dart';
import 'package:task_management_pro_codex/features/category/domain/usecases/get_categories.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_bloc.dart';
import 'package:task_management_pro_codex/features/settings/data/local/settings_local_data_source.dart';
import 'package:task_management_pro_codex/features/settings/domain/usecases/get_settings.dart';
import 'package:task_management_pro_codex/features/settings/domain/usecases/update_settings.dart';
import 'package:task_management_pro_codex/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:task_management_pro_codex/core/providers/database/database_helper.dart';
import 'package:task_management_pro_codex/features/task/data/repositories/sqlite_task_repository.dart';
import 'package:task_management_pro_codex/features/task/domain/repositories/task_repository.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/create_task.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/delete_task.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/get_task.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/get_tasks.dart';
import 'package:task_management_pro_codex/features/task/domain/usecases/update_task.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_bloc.dart';

/// Service locator used across the app.
final GetIt sl = GetIt.instance;

/// Initializes the service locator with all app dependencies.
Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // Task feature.
  sl.registerLazySingleton<TaskRepository>(
    () => SQLiteTaskRepository(databaseHelper: sl()),
  );
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => GetTask(sl()));
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerFactory(
    () => TaskBloc(
      getTasks: sl(),
      getTask: sl(),
      createTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
    ),
  );

  // Category feature.
  sl.registerLazySingleton<CategoryRepository>(
    () => InMemoryCategoryRepository(),
  );
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerFactory(() => CategoryBloc(getCategories: sl()));

  // Settings feature.
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => UpdateSettings(sl()));
  sl.registerFactory(
    () => SettingsBloc(
      getSettings: sl(),
      updateSettings: sl(),
    ),
  );
}
