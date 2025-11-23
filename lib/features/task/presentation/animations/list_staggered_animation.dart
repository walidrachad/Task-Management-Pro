import 'package:flutter/material.dart';

/// A convenience widget for animating list items with a gentle fade + slide.
///
/// Provide the item's [index] to stagger each child's start time. The animation
/// plays once when the widget first builds, making it suitable for list/grid
/// appearances without requiring external controllers.
class ListStaggeredAnimation extends StatefulWidget {
  const ListStaggeredAnimation({
    super.key,
    required this.child,
    required this.index,
    this.duration = const Duration(milliseconds: 350),
    this.initialDelay = Duration.zero,
    this.delayBetweenItems = const Duration(milliseconds: 70),
    this.offset = const Offset(0, 0.08),
    this.curve = Curves.easeOutCubic,
  });

  /// Zero-based index used to determine the stagger offset.
  final int index;

  /// Child widget to be animated.
  final Widget child;

  /// Duration of the individual item animation.
  final Duration duration;

  /// Base delay applied before the first item begins animating.
  final Duration initialDelay;

  /// Additional delay added per index to create the stagger.
  final Duration delayBetweenItems;

  /// Starting offset for the slide transition. Values are fractional, relative
  /// to the size of the animated child (as used by [SlideTransition]).
  final Offset offset;

  /// Curve applied to both the fade and slide animations.
  final Curve curve;

  @override
  State<ListStaggeredAnimation> createState() => _ListStaggeredAnimationState();
}

class _ListStaggeredAnimationState extends State<ListStaggeredAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _configureAnimations();
    _scheduleStart();
  }

  @override
  void didUpdateWidget(covariant ListStaggeredAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    if (oldWidget.curve != widget.curve || oldWidget.offset != widget.offset) {
      _configureAnimations();
    }
  }

  void _configureAnimations() {
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _fadeAnimation = curvedAnimation;
    _slideAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(curvedAnimation);
  }

  void _scheduleStart() {
    final totalDelay = widget.initialDelay +
        Duration(milliseconds: widget.delayBetweenItems.inMilliseconds * widget.index);

    if (totalDelay == Duration.zero) {
      _controller.forward();
      return;
    }

    Future.delayed(totalDelay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
