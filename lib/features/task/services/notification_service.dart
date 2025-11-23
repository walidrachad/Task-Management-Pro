import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_management_pro_codex/app/routes.dart';
import 'package:task_management_pro_codex/core/utils/app_navigator.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/entities/task_entity.dart';

/// Singleton notification service that initializes on first use.
class NotificationService {
  NotificationService._internal({FlutterLocalNotificationsPlugin? plugin})
      : _notificationsPlugin = plugin ?? FlutterLocalNotificationsPlugin() {
    _initialize();
  }

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  Future<void> _initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final taskId = response.payload;
        if (taskId != null && taskId.isNotEmpty) {
          AppNavigator.key.currentState?.pushNamed(
            Routes.taskDetail,
            arguments: taskId,
          );
        }
      },
    );

    const androidChannel = AndroidNotificationChannel(
      'task_channel',
      'Task Reminders',
      description: 'Reminders for upcoming tasks',
      importance: Importance.max,
    );

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(androidChannel);
  }

  Future<void> scheduleTaskNotification(TaskEntity task) async {
    if (task.dueDate == null || !task.isReminderEnabled) return;

    final notificationId = _notificationIdForTask(task.id);

    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Reminders',
      channelDescription: 'Reminders for upcoming tasks',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      task.title,
      task.description,
      tz.TZDateTime.from(task.dueDate!, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: task.id,
    );
  }

  Future<void> cancelTaskNotification(TaskEntity task) async {
    final notificationId = _notificationIdForTask(task.id);
    await _notificationsPlugin.cancel(notificationId);
  }

  Future<void> cancelTaskReminder(String taskId) async {
    final notificationId = _notificationIdForTask('${taskId}_reminder');
    await _notificationsPlugin.cancel(notificationId);
  }

  Future<void> scheduleTaskReminder(TaskEntity task) async {
    if (task.dueDate == null || !task.isReminderEnabled) return;

    final reminderTime = task.dueDate!.subtract(const Duration(minutes: 30));
    final scheduledTime = reminderTime.isBefore(DateTime.now())
        ? task.dueDate!
        : reminderTime;

    final notificationId = _notificationIdForTask('${task.id}_reminder');

    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Reminders',
      channelDescription: 'Reminders for upcoming tasks',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      'Upcoming: ${task.title}',
      task.description ?? 'Task is due soon',
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: task.id,
    );
  }

  int _notificationIdForTask(String taskId) => taskId.hashCode;
}
