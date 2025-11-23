import 'package:flutter/material.dart';
import 'package:task_management_pro_codex/core/constants/app_radius_circular.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';
import 'package:task_management_pro_codex/features/task/domain/enums/task_priority.dart';

/// Badge-like chip for task priority.
class PriorityChip extends StatelessWidget {
  const PriorityChip({
    super.key,
    required this.priority,
  });

  final TaskPriority priority;

  Color _backgroundColor(ThemeData theme) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green.shade100;
      case TaskPriority.medium:
        return Colors.orange.shade100;
      case TaskPriority.high:
        return Colors.red.shade100;
      case TaskPriority.urgent:
        return Colors.purple.shade100;
      default:
        return theme.colorScheme.surfaceVariant;
    }
  }

  Color _textColor(ThemeData theme) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green.shade800;
      case TaskPriority.medium:
        return Colors.orange.shade800;
      case TaskPriority.high:
        return Colors.red.shade800;
      case TaskPriority.urgent:
        return Colors.purple.shade800;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
      decoration: BoxDecoration(
        color: _backgroundColor(theme),
        borderRadius: BorderRadius.circular(AppRadiusCircular.m),
      ),
      child: Text(
        priority.name,
        style: theme.textTheme.labelMedium?.copyWith(
          color: _textColor(theme),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
