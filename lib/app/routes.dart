import 'package:flutter/material.dart';
import 'package:task_management_pro_codex/features/category/presentation/pages/category_list_page.dart';
import 'package:task_management_pro_codex/features/settings/presentation/pages/settings_page.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/enums/task_priority.dart';
import 'package:task_management_pro_codex/features/home/presentation/pages/home_page.dart';
import 'package:task_management_pro_codex/features/task/presentation/pages/create_task_page.dart';
import 'package:task_management_pro_codex/features/task/presentation/pages/task_detail_page.dart';
import 'package:task_management_pro_codex/features/task/presentation/pages/task_list_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Centralised definition of all application routes.
class Routes {
  const Routes._();

  /// Default route that the application starts on.
  static const String initialRoute = home;

  /// Route to the home page.
  static const String home = '/';

  /// Route to the task list page.
  static const String tasks = '/tasks';

  /// Route to the task detail page.
  static const String taskDetail = '/taskDetail';

  /// Route to the create task page.
  static const String createTask = '/createTask';

  /// Route to the categories page.
  static const String categories = '/categories';

  /// Route to the settings page.
  static const String settings = '/settings';

  /// Mapping of routes to the widgets they should display.
  static Map<String, WidgetBuilder> get routes => {
        tasks: (context) => const TaskListPage(),
        home: (context) => const HomePage(),
        taskDetail: (context) => TaskDetailPage(
              task: _taskFromSettings(ModalRoute.of(context)?.settings),
            ),
        createTask: (context) => CreateTaskPage(
              task: _taskFromSettingsOrNull(
                ModalRoute.of(context)?.settings,
              ),
            ),
        categories: (context) => const CategoryListPage(),
        settings: (context) => const SettingsPage(),
      };

  /// Custom page transition builder for named routes.
  static Route<dynamic>? onGenerate(RouteSettings settings) {
    WidgetBuilder? builder;
    switch (settings.name) {
      case tasks:
        builder = (context) => const TaskListPage();
        break;
      case home:
        builder = (context) => const HomePage();
        break;
      case taskDetail:
        builder = (context) => TaskDetailPage(
              task: _taskFromSettings(settings),
            );
        break;
      case createTask:
        builder = (context) => CreateTaskPage(
              task: _taskFromSettingsOrNull(settings),
            );
        break;
      case categories:
        builder = (context) => const CategoryListPage();
        break;
      case "/settings":
        builder = (context) => const SettingsPage();
        break;
    }

    if (builder == null) return null;

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => builder!(_),
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(0, 0.04);
        const end = Offset.zero;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    );
  }

  static TaskEntity _taskFromSettings(RouteSettings? settings) {
    final args = settings?.arguments;

    if (args is TaskEntity) return args;
    if (args is String && args.isNotEmpty) {
      return TaskEntity(
        id: args,
        title: '',
        status: '',
        priority: TaskPriority.high,
        isReminderEnabled: false,
      );
    }

    return TaskEntity(
      id: '',
      title: '',
      status: '',
      priority: TaskPriority.high,
      isReminderEnabled: false,
    );
  }

  static TaskEntity? _taskFromSettingsOrNull(RouteSettings? settings) {
    final args = settings?.arguments;
    if (args is TaskEntity) return args;
    return null;
  }
}
