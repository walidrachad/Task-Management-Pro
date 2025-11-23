import 'package:flutter/material.dart';
import 'package:task_management_pro_codex/core/constants/app_radius_circular.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';
import 'package:task_management_pro_codex/features/category/domain/entities/category_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_event.dart';

/// Compact visual representation of a category.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
  });

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadiusCircular.m),
      onTap: () {
        context
            .read<TaskBloc>()
            .add(FilterTasks(categoryId: category.id, status: null, priority: null));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 8,
              backgroundColor: color,
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
