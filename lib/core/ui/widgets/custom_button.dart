import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/core/constants/app_radius_circular.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';
import 'package:task_management_pro_codex/core/ui/bloc/button/button_bloc.dart';
import 'package:task_management_pro_codex/core/ui/bloc/button/button_event.dart';
import 'package:task_management_pro_codex/core/ui/bloc/button/button_state.dart';


class CustomBlocButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  const CustomBlocButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ButtonBloc, ButtonState>(
      builder: (context, state) {
        final isDisabled = state.isDisabled;

        Widget child;
        if (state.loading) {
          child = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: [
              SizedBox(
                width: AppSpacing.l,
                height: AppSpacing.l,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Text(
                'Loading...',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          );
        } else {
          child = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.s),
              ],
              Text(label),
            ],
          );
        }

        final button = FilledButton(
          onPressed: isDisabled
              ? null
              : () {
            // notify the button bloc
            context.read<ButtonBloc>().add(const ButtonPressed());
            // delegate actual action to the external callback
            onPressed?.call();
          },
          style: FilledButton.styleFrom(
            padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.m),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadiusCircular.l),
            ),
          ),
          child: child,
        );

        if (fullWidth) {
          return SizedBox(width: double.infinity, child: button);
        }
        return button;
      },
    );
  }
}
