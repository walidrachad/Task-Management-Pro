// dropdown_field_state.dart
import 'package:equatable/equatable.dart';

class DropdownFieldState<T> extends Equatable {
  final T? value;
  final bool isFocused;
  final String? errorMessage;

  const DropdownFieldState({
    required this.value,
    required this.isFocused,
    required this.errorMessage,
  });

  factory DropdownFieldState.initial({T? initialValue}) =>
      DropdownFieldState<T>(
        value: initialValue,
        isFocused: false,
        errorMessage: null,
      );

  bool get isValid => errorMessage == null;

  DropdownFieldState<T> copyWith({
    T? value,
    bool? isFocused,
    String? errorMessage,
  }) {
    return DropdownFieldState<T>(
      value: value ?? this.value,
      isFocused: isFocused ?? this.isFocused,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [value, isFocused, errorMessage];
}
