import 'package:flutter/material.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';

/// A lightweight shimmer effect for list placeholders.
///
/// Wrap any widget with [ShimmerLoading] to apply a sweeping gradient that
/// mimics content loading. The included [ShimmerListPlaceholder] renders a
/// handful of placeholder cards sized similarly to [TaskCard] entries.
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.speed = const Duration(milliseconds: 1200),
  });

  /// Child widget that will receive the shimmer effect.
  final Widget child;

  /// Background color of the shimmer. Defaults to a subtle grey.
  final Color? baseColor;

  /// Highlight color of the shimmer. Defaults to a lighter grey.
  final Color? highlightColor;

  /// Duration of a single shimmer sweep across the [child].
  final Duration speed;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController.unbounded(
      vsync: this,
    )..repeat(
        min: 0,
        max: 1,
        period: widget.speed,
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.baseColor ?? theme.colorScheme.surfaceVariant;
    final highlightColor =
        widget.highlightColor ?? theme.colorScheme.surfaceVariant.withOpacity(0.6);

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final shimmerGradient = LinearGradient(
          colors: [
            baseColor,
            highlightColor,
            baseColor,
          ],
          stops: const [0.1, 0.3, 0.4],
          begin: Alignment(-1 - _offset, -0.3),
          end: Alignment(1 + _offset, 0.3),
        );

        return ShaderMask(
          shaderCallback: shimmerGradient.createShader,
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
    );
  }

  double get _offset => _controller.value * 2;
}

/// Renders a small list of shimmer placeholders resembling the task list.
class ShimmerListPlaceholder extends StatelessWidget {
  const ShimmerListPlaceholder({
    super.key,
    this.itemCount = 5,
    this.padding = const EdgeInsets.all(AppSpacing.l),
    this.spacing = AppSpacing.m,
  });

  /// Number of placeholder items to render.
  final int itemCount;

  /// Outer padding applied to the list.
  final EdgeInsets padding;

  /// Spacing between placeholder items.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.surfaceVariant.withOpacity(0.6);

    return ListView.separated(
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        return ShimmerLoading(
          child: Container(
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildLine(height: AppSpacing.l, widthFactor: 0.6),
                    ),
                    const SizedBox(width: AppSpacing.l),
                    _buildPill(),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),
                _buildLine(height: AppSpacing.m, widthFactor: 0.9),
                const SizedBox(height: 8),
                _buildLine(height: AppSpacing.m, widthFactor: 0.7),
                const SizedBox(height: AppSpacing.m),
                Row(
                  children: [
                    _buildIconCircle(),
                    const SizedBox(width: 8),
                    _buildLine(height: AppSpacing.m, widthFactor: 0.2),
                    const Spacer(),
                    _buildIconCircle(),
                    const SizedBox(width: 8),
                    _buildLine(height: AppSpacing.m, widthFactor: 0.25),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLine({required double height, required double widthFactor}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildPill() {
    return Container(
      height: 24,
      width: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildIconCircle() {
    return Container(
      height: 18,
      width: 18,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
