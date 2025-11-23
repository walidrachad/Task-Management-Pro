import 'package:flutter/material.dart';
import 'package:task_management_pro_codex/app/routes.dart';
import 'package:task_management_pro_codex/core/constants/app_radius_circular.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/presentation/animations/hero_animation.dart';
import 'package:task_management_pro_codex/features/task/presentation/widgets/priority_chip.dart';
import 'package:task_management_pro_codex/features/task/presentation/widgets/status_badge.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dueDateText =
        task.dueDate != null ? _formatDate(task.dueDate!) : 'No due date';

    return HeroAnimationHelpers.taskHero(
      tag: task.id,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.taskDetail,
            arguments: task,
          );
        },
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadiusCircular.m)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    StatusBadge(status: task.status),
                  ],
                ),
                if (task.description != null &&
                    task.description!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    task.description!,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.m),
                Row(
                  children: [
                    PriorityChip(priority: task.priority),
                    const Spacer(),
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Text(
                      dueDateText,
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
