import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';
import 'package:task_management_pro_codex/core/ui/bloc/dropdown_field/dropdown_field_bloc.dart';
import 'package:task_management_pro_codex/core/ui/bloc/dropdown_field/dropdown_field_event.dart';
import 'package:task_management_pro_codex/core/ui/bloc/dropdown_field/dropdown_field_state.dart';

class BlocDropdownField<T> extends StatefulWidget {
  final String label;
  final String? hintText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onSubmitted;

  const BlocDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<BlocDropdownField<T>> createState() => _BlocDropdownFieldState<T>();
}

class _BlocDropdownFieldState<T> extends State<BlocDropdownField<T>> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      context
          .read<DropdownFieldBloc<T>>()
          .add(DropdownFocusChanged<T>(_focusNode.hasFocus));
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<DropdownFieldBloc<T>, DropdownFieldState<T>>(
      builder: (context, state) {
        final isError = state.errorMessage != null;
        final isFocused = state.isFocused;

        final Color borderColor = isError
            ? colorScheme.error
            : isFocused
            ? colorScheme.primary
            : colorScheme.outlineVariant;

        final Color? fillColor = isError
            ? colorScheme.errorContainer.withOpacity(0.08)
            : isFocused
            ? colorScheme.primaryContainer.withOpacity(0.06)
            : colorScheme.surfaceContainerHighest;

        return DropdownButtonFormField<T>(
          focusNode: _focusNode,
          value: state.value,
          items: widget.items,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hintText,
            filled: true,
            fillColor: fillColor,
            errorText: state.errorMessage,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: borderColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 2,
              ),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: 12),
          ),
          onChanged: (value) {
            context
                .read<DropdownFieldBloc<T>>()
                .add(DropdownValueChanged<T>(value));

            widget.onChanged?.call(value);
          },
          onSaved: (_) {
            context
                .read<DropdownFieldBloc<T>>()
                .add(const DropdownSubmitted());
            widget.onSubmitted?.call();
          },
        );
      },
    );
  }
}
