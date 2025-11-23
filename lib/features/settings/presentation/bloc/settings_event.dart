import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class UpdateSettingsEvent extends SettingsEvent {
  const UpdateSettingsEvent({
    required this.themeMode,
    this.dailySummaryTime,
  });

  final ThemeMode themeMode;
  final TimeOfDay? dailySummaryTime;

  @override
  List<Object?> get props => [themeMode, dailySummaryTime];
}
