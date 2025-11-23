import 'package:flutter/material.dart';
import '../enums/text_field_visual_state.dart';
import '../styles/text_field_visual_style.dart';

class TextFieldStyleMapper {
  static TextFieldVisualStyle map(
      ColorScheme colorScheme,
      TextFieldVisualState state,
      ) {
    switch (state) {
      case TextFieldVisualState.error:
        return TextFieldVisualStyle(
          borderColor: colorScheme.error,
          fillColor: colorScheme.errorContainer.withOpacity(0.08),
        );

      case TextFieldVisualState.focused:
        return TextFieldVisualStyle(
          borderColor: colorScheme.primary,
          fillColor: colorScheme.primaryContainer.withOpacity(0.06),
        );

      case TextFieldVisualState.completed:
        return TextFieldVisualStyle(
          borderColor: colorScheme.secondary,
          fillColor: colorScheme.secondaryContainer.withOpacity(0.10),
        );

      case TextFieldVisualState.normal:
      default:
        return TextFieldVisualStyle(
          borderColor: colorScheme.outlineVariant,
          fillColor: colorScheme.surfaceContainerHighest,
        );
    }
  }
}
