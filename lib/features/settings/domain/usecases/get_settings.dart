import 'package:flutter/material.dart';
import 'package:task_management_pro_codex/features/settings/data/local/settings_local_data_source.dart';

class GetSettings {
  const GetSettings(this.settingsLocalDataSource);

  final SettingsLocalDataSource settingsLocalDataSource;

  Future<({ThemeMode themeMode, TimeOfDay? dailySummaryTime})> call() async {
    final isDarkModeEnabled =
        await settingsLocalDataSource.getIsDarkModeEnabled();
    final dailySummaryTime = await settingsLocalDataSource.getDailySummaryTime();

    return (
      themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      dailySummaryTime: dailySummaryTime,
    );
  }
}
