import 'package:flutter/material.dart';

/// Small badge to represent a task status with color.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
  });

  final String status;

  Color _backgroundColor(ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'todo':
        return Colors.grey.shade200;
      case 'in progress':
        return Colors.blue.shade100;
      case 'completed':
        return Colors.green.shade100;
      default:
        return theme.colorScheme.surfaceVariant;
    }
  }

  Color _textColor(ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'todo':
        return Colors.grey.shade800;
      case 'in progress':
        return Colors.blue.shade800;
      case 'completed':
        return Colors.green.shade800;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor(theme),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelMedium?.copyWith(
          color: _textColor(theme),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
