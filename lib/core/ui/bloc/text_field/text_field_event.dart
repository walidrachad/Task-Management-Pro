import 'package:equatable/equatable.dart';

abstract class TextFieldEvent extends Equatable {
  const TextFieldEvent();
  @override
  List<Object?> get props => [];
}

class TextFieldTextChanged extends TextFieldEvent {
  final String value;
  const TextFieldTextChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class TextFieldFocusChanged extends TextFieldEvent {
  final bool isFocused;
  const TextFieldFocusChanged(this.isFocused);

  @override
  List<Object?> get props => [isFocused];
}

class TextFieldSubmitted extends TextFieldEvent {
  const TextFieldSubmitted();
}
