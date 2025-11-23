import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/core/ui/bloc/text_field/text_field_event.dart';
import 'package:task_management_pro_codex/core/utils/validators/base/text_validator.dart';
import 'text_field_state.dart';

class TextFieldBloc extends Bloc<TextFieldEvent, TextFieldState> {
  final TextValidator? validator;

  TextFieldBloc({this.validator}) : super(TextFieldState.initial()) {
    on<TextFieldTextChanged>(_onTextChanged);
    on<TextFieldFocusChanged>(_onFocusChanged);
    on<TextFieldSubmitted>(_onSubmitted);
  }

  void _onTextChanged(
    TextFieldTextChanged event,
    Emitter<TextFieldState> emit,
  ) {
    final error = validator?.validate(event.value);
    emit(
      state.copyWith(
        value: event.value,
        errorMessage: error,
        isCompleted: false, // user is editing again → no longer completed
      ),
    );
  }

  void _onFocusChanged(
    TextFieldFocusChanged event,
    Emitter<TextFieldState> emit,
  ) {
    final isFocused = event.isFocused;
    final shouldValidate = !isFocused;

    final error = shouldValidate && validator != null
        ? validator!.validate(state.value)
        : state.errorMessage;

    final isCompleted = !isFocused && (error == null) && state.value.isNotEmpty;

    emit(
      state.copyWith(
        isFocused: isFocused,
        errorMessage: error,
        isCompleted: isCompleted,
      ),
    );
  }

  void _onSubmitted(
    TextFieldSubmitted event,
    Emitter<TextFieldState> emit,
  ) {
    final error = validator?.validate(state.value);
    final isCompleted = error == null && state.value.isNotEmpty;

    emit(
      state.copyWith(
        errorMessage: error,
        isCompleted: isCompleted,
      ),
    );
  }
}
