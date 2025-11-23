class DatabaseConstants {
  static const String dbName = "task_manager";
  static const int dbVersion = 1;
  static const String tasksTable = "tasks";
  static const String columnId = "id";
  static const String columnTitle = "title";
  static const String columnDescription = "description";
  static const String columnDueDate = "due_date";
  static const String columnStatus = "status";
  static const String columnPriority = "priority";
  static const String columnCategoryId = "category_id";
  static const String columnReminderEnabled = "is_reminder_enabled";
  static const String taskTableSchema = """
    CREATE TABLE IF NOT EXISTS $tasksTable (
      $columnId TEXT PRIMARY KEY,
      $columnTitle TEXT NOT NULL,
      $columnDescription TEXT,
      $columnDueDate INTEGER,
      $columnStatus TEXT NOT NULL,
      $columnPriority TEXT NOT NULL,
      $columnCategoryId TEXT,
      $columnReminderEnabled INTEGER NOT NULL
    )
  """;
}
