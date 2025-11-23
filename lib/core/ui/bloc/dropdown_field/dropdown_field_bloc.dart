// dropdown_field_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/core/utils/validators/base/field_validator.dart';

import 'dropdown_field_event.dart';
import 'dropdown_field_state.dart';

class DropdownFieldBloc<T>
    extends Bloc<DropdownFieldEvent<T>, DropdownFieldState<T>> {
  final FieldValidator<T>? validator;
  bool _hasInteracted = false;

  DropdownFieldBloc({
    this.validator,
    T? initialValue,
  }) : super(DropdownFieldState<T>.initial(initialValue: initialValue)) {
    on<DropdownValueChanged<T>>(_onValueChanged);
    on<DropdownFocusChanged<T>>(_onFocusChanged);
    on<DropdownSubmitted<T>>(_onSubmitted);
  }

  String? get error => state.errorMessage;

  T? get value => state.value;

  void _onValueChanged(
    DropdownValueChanged<T> event,
    Emitter<DropdownFieldState<T>> emit,
  ) {
    final error = validator?.validate(event.value);
    _hasInteracted = true;
    emit(
      state.copyWith(
        value: event.value,
        errorMessage: error,
      ),
    );
  }

  void _onFocusChanged(
    DropdownFocusChanged<T> event,
    Emitter<DropdownFieldState<T>> emit,
  ) {
    if (event.isFocused) {
      _hasInteracted = true;
      emit(state.copyWith(isFocused: true));
      return;
    }

    if (!_hasInteracted) {
      emit(state.copyWith(isFocused: false, errorMessage: null));
      return;
    }

    final shouldValidate = !event.isFocused;
    final error = (shouldValidate && validator != null)
        ? validator!.validate(state.value)
        : state.errorMessage;

    emit(
      state.copyWith(
        isFocused: event.isFocused,
        errorMessage: error,
      ),
    );
  }

  void _onSubmitted(
    DropdownSubmitted<T> event,
    Emitter<DropdownFieldState<T>> emit,
  ) {
    _hasInteracted = true;
    final error = validator?.validate(state.value);
    emit(state.copyWith(errorMessage: error));
  }
}
