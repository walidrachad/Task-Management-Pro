import 'package:task_management_pro_codex/core/constants/database_constants.dart';

class DatabaseSchema {
  static const Map<int, List<String>> migrations = {
    1: [
      DatabaseConstants.taskTableSchema,
    ],
  };
}
