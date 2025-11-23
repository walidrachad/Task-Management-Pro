import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/enums/task_priority.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    super.dueDate,
    required super.status,
    required super.priority,
    super.categoryId,
    required super.isReminderEnabled,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      status: json['status'] as String,
      priority:
          TaskPriority.values.firstWhere((test) => test = json['priority']),
      categoryId: json['categoryId'] as String?,
      isReminderEnabled: json['isReminderEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'status': status,
      'priority': priority.name,
      'categoryId': categoryId,
      'isReminderEnabled': isReminderEnabled,
    };
  }

  factory TaskModel.fromDb(Map<String, dynamic> map) {
    final dynamic dueValue = map['due_date'];
    DateTime? parsedDueDate;
    if (dueValue is String && dueValue.isNotEmpty) {
      parsedDueDate = DateTime.tryParse(dueValue);
    } else if (dueValue is int) {
      parsedDueDate = DateTime.fromMillisecondsSinceEpoch(dueValue);
    }

    final dynamic reminderValue = map['is_reminder_enabled'];
    final bool parsedReminder = reminderValue is int
        ? reminderValue == 1
        : (reminderValue as bool? ?? false);

    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      dueDate: parsedDueDate,
      status: map['status'] as String,
      priority:
          TaskPriority.values.firstWhere((test) => test = map['priority']),
      categoryId: map['category_id'] as String?,
      isReminderEnabled: parsedReminder,
    );
  }

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate?.millisecondsSinceEpoch,
      'status': status,
      'priority': priority,
      'category_id': categoryId,
      'is_reminder_enabled': isReminderEnabled ? 1 : 0,
    };
  }
}
