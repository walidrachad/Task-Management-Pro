import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'core/di/injector.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Casablanca'));
  runApp(const TaskManagementApp());
}
