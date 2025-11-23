import 'package:flutter/material.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';

/// Simple fade/slide-in animation for chart sections.
class ChartFadeIn extends StatefulWidget {
  const ChartFadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 450),
    this.delay = Duration.zero,
    this.offset = const Offset(0, 12),
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset offset;

  @override
  State<ChartFadeIn> createState() => _ChartFadeInState();
}

class _ChartFadeInState extends State<ChartFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _opacity = Tween<double>(begin: 0, end: 1).animate(curved);
    _slide = Tween<Offset>(
      begin: Offset(widget.offset.dx / 50, widget.offset.dy / 50),
      end: Offset.zero,
    ).animate(curved);

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
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
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

/// Animated bar row used for simple chart placeholders.
class AnimatedBarRow extends StatelessWidget {
  const AnimatedBarRow({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
  });

  final String label;
  final int value;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final target = maxValue == 0 ? 0.0 : value / maxValue;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: target.clamp(0, 1)),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, progress, child) {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Text(value.toString(), style: theme.textTheme.bodyMedium),
          ],
        );
      },
    );
  }
}
