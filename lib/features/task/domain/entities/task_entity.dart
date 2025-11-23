import 'package:equatable/equatable.dart';
import 'package:task_management_pro_codex/features/task/domain/enums/task_priority.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final String status;
  final TaskPriority priority;
  final String? categoryId;
  final bool isReminderEnabled;

  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.status,
    required this.priority,
    this.categoryId,
    required this.isReminderEnabled,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dueDate,
        status,
        priority,
        categoryId,
        isReminderEnabled,
      ];
  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? status,
    TaskPriority? priority,
    String? categoryId,
    bool? isReminderEnabled,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
    );
  }
}
