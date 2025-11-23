import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<bool> getIsDarkModeEnabled();

  Future<void> setIsDarkModeEnabled(bool value);

  Future<TimeOfDay?> getDailySummaryTime();

  Future<void> setDailySummaryTime(TimeOfDay time);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl(this.sharedPreferences);

  final SharedPreferences sharedPreferences;
  static const _darkModeKey = 'settings_dark_mode_enabled';
  static const _dailySummaryHourKey = 'settings_daily_summary_hour';
  static const _dailySummaryMinuteKey = 'settings_daily_summary_minute';

  @override
  Future<bool> getIsDarkModeEnabled() {
    final storedValue = sharedPreferences.getBool(_darkModeKey);
    return Future<bool>.value(storedValue ?? false);
  }

  @override
  Future<void> setIsDarkModeEnabled(bool value) {
    return sharedPreferences.setBool(_darkModeKey, value).then((_) {});
  }

  @override
  Future<TimeOfDay?> getDailySummaryTime() {
    final hour = sharedPreferences.getInt(_dailySummaryHourKey);
    final minute = sharedPreferences.getInt(_dailySummaryMinuteKey);

    if (hour == null || minute == null) return Future<TimeOfDay?>.value(null);

    return Future<TimeOfDay?>.value(TimeOfDay(hour: hour, minute: minute));
  }

  @override
  Future<void> setDailySummaryTime(TimeOfDay time) {
    return Future.wait([
      sharedPreferences.setInt(_dailySummaryHourKey, time.hour),
      sharedPreferences.setInt(_dailySummaryMinuteKey, time.minute),
    ]).then((_) {});
  }
}
