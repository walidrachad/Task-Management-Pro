// text_field_visual_state.dart
import 'package:equatable/equatable.dart';
import 'package:task_management_pro_codex/core/ui/enums/text_field_visual_state.dart';

class TextFieldState extends Equatable {
  final String value;
  final bool isFocused;
  final String? errorMessage;
  final bool isCompleted;

  const TextFieldState({
    required this.value,
    required this.isFocused,
    required this.errorMessage,
    required this.isCompleted,
  });

  factory TextFieldState.initial() => const TextFieldState(
    value: '',
    isFocused: false,
    errorMessage: null,
    isCompleted: false,
  );

  bool get isValid => errorMessage == null;

  TextFieldVisualState get visualState {
    if (!isValid && !isFocused) return TextFieldVisualState.error;
    if (isCompleted && isValid) return TextFieldVisualState.completed;
    if (isFocused) return TextFieldVisualState.focused;
    return TextFieldVisualState.normal;
  }

  TextFieldState copyWith({
    String? value,
    bool? isFocused,
    String? errorMessage,
    bool? isCompleted,
  }) {
    return TextFieldState(
      value: value ?? this.value,
      isFocused: isFocused ?? this.isFocused,
      errorMessage: errorMessage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [value, isFocused, errorMessage, isCompleted];
}
