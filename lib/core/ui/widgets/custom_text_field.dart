import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';
import 'package:task_management_pro_codex/core/ui/bloc/text_field/text_field_bloc.dart';
import 'package:task_management_pro_codex/core/ui/bloc/text_field/text_field_event.dart';
import 'package:task_management_pro_codex/core/ui/bloc/text_field/text_field_state.dart';
import 'package:task_management_pro_codex/core/ui/mappers/text_field_style_mapper.dart';
import 'package:task_management_pro_codex/core/ui/widgets/input_error_indicator.dart';

class BlocTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final int maxLine;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;

  const BlocTextField({
    super.key,
    required this.label,
    this.hintText,
    this.maxLine = 1,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<BlocTextField> createState() => _BlocTextFieldState();
}

class _BlocTextFieldState extends State<BlocTextField> {
  static const double _borderRadiusValue = AppSpacing.m;

  late final FocusNode _focusNode;
  late final TextFieldBloc _bloc;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<TextFieldBloc>();

    _controller = TextEditingController(text: _bloc.state.value);

    _focusNode = FocusNode()
      ..addListener(() {
        _bloc.add(TextFieldFocusChanged(_focusNode.hasFocus));
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<TextFieldBloc, TextFieldState>(
      builder: (context, state) {
        final visualStyle = TextFieldStyleMapper.map(
          colorScheme,
          state.visualState,
        );;

        if (_controller.text != state.value) {
          _controller.value = TextEditingValue(
            text: state.value,
            selection: TextSelection.collapsed(offset: state.value.length),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              maxLines: widget.maxLine,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              obscureText: widget.obscureText,
              onChanged: (value) {
                _bloc.add(TextFieldTextChanged(value));
                widget.onChanged?.call(value);
              },
              onSubmitted: (_) {
                _bloc.add(const TextFieldSubmitted());
                widget.onSubmitted?.call();
              },
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hintText,
                filled: true,
                fillColor: visualStyle.fillColor,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                enabledBorder: _buildBorder(visualStyle.borderColor),
                focusedBorder:
                    _buildBorder(visualStyle.borderColor, isFocused: true),
                errorBorder: _buildBorder(colorScheme.error),
                focusedErrorBorder:
                    _buildBorder(colorScheme.error, isFocused: true),
                contentPadding: const EdgeInsets.all(AppSpacing.l),
                alignLabelWithHint: true,
              ),
            ),
            if (state.errorMessage != null)
              TextFieldError(
                message: state.errorMessage!,
                color: colorScheme.error,
              ),
          ],
        );
      },
    );
  }

  OutlineInputBorder _buildBorder(
    Color color, {
    bool isFocused = false,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadiusValue),
      borderSide: BorderSide(
        color: color,
        width: isFocused ? 2 : 1,
      ),
    );
  }
}
