import 'package:flutter/material.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';

class TextFieldError extends StatelessWidget {
  final String message;
  final Color color;

  const TextFieldError({
    super.key,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s, left: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 18,
            color: color,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
