import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/app/routes.dart';
import 'package:task_management_pro_codex/core/di/injector.dart';
import 'package:task_management_pro_codex/core/theme/app_theme.dart';
import 'package:task_management_pro_codex/core/theme/dark_theme.dart';
import 'package:task_management_pro_codex/core/utils/app_navigator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_bloc.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_event.dart';
import 'package:task_management_pro_codex/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:task_management_pro_codex/features/settings/presentation/bloc/settings_event.dart';
import 'package:task_management_pro_codex/features/settings/presentation/bloc/settings_state.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_event.dart';

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (_) => sl<TaskBloc>()..add(const LoadTasks()),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) => sl<CategoryBloc>()..add(const LoadCategories()),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => sl<SettingsBloc>()..add(const LoadSettings()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final themeMode =
              state is SettingsLoaded ? state.themeMode : ThemeMode.system;

          return MaterialApp(
            title: AppLocalizations.of(context)?.appTitle ?? 'Task Management Pro',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            initialRoute: Routes.initialRoute,
            routes: Routes.routes,
            onGenerateRoute: Routes.onGenerate,
            debugShowCheckedModeBanner: false,
            navigatorKey: AppNavigator.key,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
