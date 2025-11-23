import 'package:flutter_bloc/flutter_bloc.dart';
import 'button_event.dart';
import 'button_state.dart';

class ButtonBloc extends Bloc<ButtonEvent, ButtonState> {
  ButtonBloc({bool initialEnabled = true})
      : super(ButtonState.initial(enabled: initialEnabled)) {
    on<ButtonSetEnabled>(_onSetEnabled);
    on<ButtonSetLoading>(_onSetLoading);
    on<ButtonPressed>(_onPressed);
  }

  void _onSetEnabled(ButtonSetEnabled event, Emitter<ButtonState> emit) {
    emit(state.copyWith(enabled: event.enabled));
  }

  void _onSetLoading(ButtonSetLoading event, Emitter<ButtonState> emit) {
    emit(state.copyWith(loading: event.loading));
  }

  void _onPressed(ButtonPressed event, Emitter<ButtonState> emit) {
    // Optional: you can log analytics here or trigger something simple.
    // Real async work (API, etc.) should be handled in a separate FormBloc.
  }
}
