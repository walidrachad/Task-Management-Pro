import 'package:flutter/material.dart';

/// Centralized helpers for Hero animations used across task screens.
///
/// Having a single place for custom transitions keeps the look and feel
/// consistent between list and detail routes and makes it easier to tweak
/// animations later.
class HeroAnimationHelpers {
  const HeroAnimationHelpers._();

  /// Wraps [child] with a [Hero] that includes a soft fade animation during
  /// the flight. The [tag] should be unique per hero pair.
  static Widget taskHero({
    required Object tag,
    required Widget child,
    bool transitionOnUserGestures = true,
    HeroFlightShuttleBuilder? flightShuttleBuilder,
  }) {
    return Hero(
      tag: tag,
      transitionOnUserGestures: transitionOnUserGestures,
      flightShuttleBuilder:
          flightShuttleBuilder ?? _defaultTaskFlightShuttleBuilder,
      child: child,
    );
  }

  /// TODO: Consider exposing duration/curve knobs if we add more complex
  /// animations in the future.
  static Widget _defaultTaskFlightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final heroWidget =
        direction == HeroFlightDirection.push // Use destination on push
            ? toHeroContext.widget
            : fromHeroContext.widget;

    return FadeTransition(
      opacity: animation.drive(
        CurveTween(curve: Curves.easeInOutCubicEmphasized),
      ),
      child: Material(
        color: Colors.transparent,
        child: heroWidget,
      ),
    );
  }
}
