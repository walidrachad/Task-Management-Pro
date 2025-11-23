import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_pro_codex/features/settings/domain/usecases/get_settings.dart';
import 'package:task_management_pro_codex/features/settings/domain/usecases/update_settings.dart';
import 'package:task_management_pro_codex/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:task_management_pro_codex/features/settings/presentation/bloc/settings_event.dart';
import 'package:task_management_pro_codex/features/settings/presentation/bloc/settings_state.dart';
import 'package:task_management_pro_codex/features/settings/data/local/settings_local_data_source.dart';

class _FakeSettingsLocalDataSource
    implements SettingsLocalDataSource {
  bool isDark = false;
  TimeOfDay? summaryTime;

  @override
  Future<TimeOfDay?> getDailySummaryTime() async => summaryTime;

  @override
  Future<bool> getIsDarkModeEnabled() async => isDark;

  @override
  Future<void> setDailySummaryTime(TimeOfDay time) async {
    summaryTime = time;
  }

  @override
  Future<void> setIsDarkModeEnabled(bool value) async {
    isDark = value;
  }
}

class _GetSettingsStub extends GetSettings {
  _GetSettingsStub(this.source) : super(source);
  final _FakeSettingsLocalDataSource source;
}

class _UpdateSettingsStub extends UpdateSettings {
  _UpdateSettingsStub(this.source) : super(source);
  final _FakeSettingsLocalDataSource source;
}

void main() {
  late _FakeSettingsLocalDataSource dataSource;
  late SettingsBloc bloc;

  setUp(() {
    dataSource = _FakeSettingsLocalDataSource();
    bloc = SettingsBloc(
      getSettings: _GetSettingsStub(dataSource),
      updateSettings: _UpdateSettingsStub(dataSource),
    );
  });

  blocTest<SettingsBloc, SettingsState>(
    'emits loading then loaded on LoadSettings',
    build: () => bloc,
    act: (bloc) => bloc.add(const LoadSettings()),
    expect: () => [
      const SettingsLoading(),
      isA<SettingsLoaded>(),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'updates settings and reloads',
    build: () => bloc,
    act: (bloc) => bloc.add(
      UpdateSettingsEvent(themeMode: ThemeMode.dark),
    ),
    expect: () => [
      const SettingsLoading(),
      const SettingsLoading(),
      isA<SettingsLoaded>().having(
        (state) => state.themeMode,
        'themeMode',
        ThemeMode.dark,
      ),
    ],
  );
}
