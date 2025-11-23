import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded({
    required this.themeMode,
    this.dailySummaryTime,
  });

  final ThemeMode themeMode;
  final TimeOfDay? dailySummaryTime;

  @override
  List<Object?> get props => [themeMode, dailySummaryTime];
}

class SettingsError extends SettingsState {
  const SettingsError({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}
