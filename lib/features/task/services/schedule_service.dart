import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class ScheduleService {
  ScheduleService({FlutterLocalNotificationsPlugin? plugin})
      : _notificationsPlugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  static const _dailySummaryNotificationId = 0;

  Future<void> scheduleDailySummary(TimeOfDay timeOfDay) async {
    await cancelDailySummary();

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'daily_summary_channel',
      'Daily Summary',
      channelDescription: 'Daily summary of your tasks',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      _dailySummaryNotificationId,
      'Daily Summary',
      'Here is your task summary for today',
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> updateDailySummarySchedule(TimeOfDay? timeOfDay) async {
    if (timeOfDay == null) {
      await cancelDailySummary();
      return;
    }

    await scheduleDailySummary(timeOfDay);
  }

  Future<void> cancelDailySummary() async {
    await _notificationsPlugin.cancel(_dailySummaryNotificationId);
  }
}
