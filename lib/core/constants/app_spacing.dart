/// A utility class that centralizes spacing (padding and margin) values
/// used throughout the application.
///
/// This helps maintain consistent spacing and makes it easier to update
/// global layout spacing rules in one place.
///
/// Example:
/// ```dart
/// SizedBox(height: AppSpacing.m);
/// Padding(padding: EdgeInsets.all(AppSpacing.l));
/// ```
class AppSpacing {
  // Private constructor to prevent instantiation.
  AppSpacing._();

  /// Extra small spacing (4px).
  static const double xs = 4;

  /// Small spacing (8px).
  static const double s = 8;

  /// Medium spacing (12px).
  static const double m = 12;

  /// Large spacing (16px).
  static const double l = 16;

  /// Extra large spacing (24px).
  static const double xl = 24;

  /// Extra–small–large spacing (28px).
  /// This is useful when you need something between xl and xxl.
  static const double xsl = 28;

  /// Double extra large spacing (32px).
  static const double xxl = 32;

  /// Triple extra large spacing (64px).
  /// Ideal for big layout gaps or section separators.
  static const double xxxl = 64;
}
