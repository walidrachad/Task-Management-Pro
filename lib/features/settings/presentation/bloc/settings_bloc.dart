import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/features/settings/domain/usecases/get_settings.dart';
import 'package:task_management_pro_codex/features/settings/domain/usecases/update_settings.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required this.getSettings,
    required this.updateSettings,
  }) : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
  }

  final GetSettings getSettings;
  final UpdateSettings updateSettings;

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    try {
      final settings = await getSettings();
      emit(
        SettingsLoaded(
          themeMode: settings.themeMode,
          dailySummaryTime: settings.dailySummaryTime,
        ),
      );
    } catch (e) {
      emit(const SettingsError(message: 'Failed to load settings'));
    }
  }

  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    try {
      await updateSettings(
        themeMode: event.themeMode,
        dailySummaryTime: event.dailySummaryTime,
      );
      add(const LoadSettings());
    } catch (e) {
      emit(const SettingsError(message: 'Failed to update settings'));
    }
  }
}
