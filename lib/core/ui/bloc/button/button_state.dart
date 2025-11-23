import 'package:equatable/equatable.dart';

class ButtonState extends Equatable {
  final bool enabled;
  final bool loading;

  const ButtonState({
    required this.enabled,
    required this.loading,
  });

  factory ButtonState.initial({bool enabled = true}) =>
      ButtonState(enabled: enabled, loading: false);

  bool get isDisabled => !enabled || loading;

  ButtonState copyWith({
    bool? enabled,
    bool? loading,
  }) {
    return ButtonState(
      enabled: enabled ?? this.enabled,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [enabled, loading];
}
