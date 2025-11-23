import 'package:equatable/equatable.dart';

abstract class ButtonEvent extends Equatable {
  const ButtonEvent();

  @override
  List<Object?> get props => [];
}

/// Enable / disable the button (external logic: form valid, etc.)
class ButtonSetEnabled extends ButtonEvent {
  final bool enabled;
  const ButtonSetEnabled(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Turn loading on/off (external: API call, etc.)
class ButtonSetLoading extends ButtonEvent {
  final bool loading;
  const ButtonSetLoading(this.loading);

  @override
  List<Object?> get props => [loading];
}

/// Optional: fire when user taps the button
class ButtonPressed extends ButtonEvent {
  const ButtonPressed();
}
