import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?> onChanged;
  final String? hintText;
  final bool enabled;

  const DatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.hintText,
    this.enabled = true,
  });

  String _formatDate(DateTime date) {
    // You can change the format
    return DateFormat('EEE, d MMM yyyy').format(date);
  }

  Future<void> _pickDate(BuildContext context) async {
    if (!enabled) return;

    final now = DateTime.now();
    final initialDate = value ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(now.year - 5),
      lastDate: lastDate ?? DateTime(now.year + 5),
      // custom theming of the dialog
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              surface: theme.colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: enabled ? () => _pickDate(context) : null,
      borderRadius: BorderRadius.circular(16),
      child: InputDecorator(
        isFocused: false,
        isEmpty: value == null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText ?? 'Select date',
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          enabled: enabled,
          suffixIcon: const Icon(Icons.calendar_today_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: 12),
        ),
        child: Text(
          value != null ? _formatDate(value!) : (hintText ?? 'Select date'),
          style: value != null
              ? theme.textTheme.bodyMedium
              : theme.textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
          ),
        ),
      ),
    );
  }
}
