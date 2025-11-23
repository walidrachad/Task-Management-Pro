import 'package:flutter/material.dart';
import 'package:task_management_pro_codex/features/settings/data/local/settings_local_data_source.dart';

class UpdateSettings {
  const UpdateSettings(this.settingsLocalDataSource);

  final SettingsLocalDataSource settingsLocalDataSource;

  Future<void> call({
    required ThemeMode themeMode,
    TimeOfDay? dailySummaryTime,
  }) async {
    await settingsLocalDataSource
        .setIsDarkModeEnabled(themeMode == ThemeMode.dark);

    if (dailySummaryTime != null) {
      await settingsLocalDataSource.setDailySummaryTime(dailySummaryTime);
    }
  }
}
