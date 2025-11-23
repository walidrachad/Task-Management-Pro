import 'package:task_management_pro_codex/core/constants/database_constants.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/enums/task_priority.dart';

class TaskDbModel {
  const TaskDbModel({
    required this.id,
    required this.title,
    this.description,
    this.dueDateMillis,
    required this.status,
    required this.priority,
    this.categoryId,
    required this.isReminderEnabled,
  });

  final String id;
  final String title;
  final String? description;
  final int? dueDateMillis;
  final String status;
  final String priority;
  final String? categoryId;
  final bool isReminderEnabled;

  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.columnId: id,
      DatabaseConstants.columnTitle: title,
      DatabaseConstants.columnDescription: description,
      DatabaseConstants.columnDueDate: dueDateMillis,
      DatabaseConstants.columnStatus: status,
      DatabaseConstants.columnPriority: priority,
      DatabaseConstants.columnCategoryId: categoryId,
      DatabaseConstants.columnReminderEnabled: isReminderEnabled ? 1 : 0,
    };
  }

  static TaskDbModel fromEntity(TaskEntity task) {
    return TaskDbModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDateMillis: task.dueDate?.millisecondsSinceEpoch,
      status: task.status,
      priority: task.priority.name,
      categoryId: task.categoryId,
      isReminderEnabled: task.isReminderEnabled,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      dueDate: dueDateMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(dueDateMillis!)
          : null,
      status: status,
      priority: TaskPriority.values
          .firstWhere((p) => p.name == priority, orElse: () => TaskPriority.medium),
      categoryId: categoryId,
      isReminderEnabled: isReminderEnabled,
    );
  }
}
