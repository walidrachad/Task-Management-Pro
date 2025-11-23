import 'package:flutter/material.dart';

/// Global navigator key to enable navigation outside widget context (e.g., notifications).
class AppNavigator {
  const AppNavigator._();

  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
}
