import 'package:equatable/equatable.dart';

abstract class DropdownFieldEvent<T> extends Equatable {
  const DropdownFieldEvent();

  @override
  List<Object?> get props => [];
}

class DropdownValueChanged<T> extends DropdownFieldEvent<T> {
  final T? value;
  const DropdownValueChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class DropdownFocusChanged<T> extends DropdownFieldEvent<T> {
  final bool isFocused;
  const DropdownFocusChanged(this.isFocused);

  @override
  List<Object?> get props => [isFocused];
}

class DropdownSubmitted<T> extends DropdownFieldEvent<T> {
  const DropdownSubmitted();
}
