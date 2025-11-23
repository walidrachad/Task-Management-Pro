import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/app/routes.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/presentation/animations/hero_animation.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_event.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dueDateText = widget.task.dueDate != null
        ? _formatDate(widget.task.dueDate!)
        : 'No due date';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _onEdit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroAnimationHelpers.taskHero(
                  tag: widget.task.id,
                  child: Material(
                    color: Colors.transparent,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                                    widget.task.title,
                                    style:
                                        theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.task.status,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.task.description != null &&
                                widget.task.description!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                widget.task.description!,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                            const SizedBox(height: AppSpacing.l),
                            _DetailRow(
                              icon: Icons.calendar_today,
                              label: 'Due date',
                              value: dueDateText,
                            ),
                            const SizedBox(height: 12),
                            _DetailRow(
                              icon: Icons.flag,
                              label: 'Priority',
                              value: widget.task.priority.name,
                            ),
                            const SizedBox(height: 12),
                            _DetailRow(
                              icon: Icons.notifications_active,
                              label: 'Reminder',
                              value: widget.task.isReminderEnabled
                                  ? 'Enabled'
                                  : 'Disabled',
                            ),
                            if (widget.task.categoryId != null) ...[
                              const SizedBox(height: 12),
                              _DetailRow(
                                icon: Icons.category,
                                label: 'Category',
                                value: widget.task.categoryId!,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Actions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: widget.task.status.toLowerCase() == 'completed'
                          ? null
                          : () => _markComplete(context),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Mark complete'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _onEdit(context),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit task'),
                    ),
                    TextButton.icon(
                      onPressed: () => _confirmDelete(context),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete task'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 20,
              maxBlastForce: 14,
              minBlastForce: 6,
              emissionFrequency: 0.02,
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }

  void _markComplete(BuildContext context) {
    final bloc = context.read<TaskBloc>();
    final updatedTask = widget.task.copyWith(
      status: 'Completed',
    );

    bloc.add(UpdateTaskEvent(updatedTask));
    _confettiController.play();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task marked as completed')),
    );
  }

  void _onEdit(BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.createTask,
      arguments: widget.task,
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && context.mounted) {
      context.read<TaskBloc>().add(DeleteTaskEvent(widget.task.id));
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted')),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.secondary),
        const SizedBox(width: 10),
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
