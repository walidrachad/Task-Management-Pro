import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/core/ui/bloc/dropdown_field/dropdown_field_bloc.dart';
import 'package:task_management_pro_codex/core/ui/bloc/dropdown_field/dropdown_field_event.dart';
import 'package:task_management_pro_codex/core/ui/widgets/bloc_dropdown_field.dart';
import 'package:task_management_pro_codex/features/category/domain/entities/category_entity.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_bloc.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_event.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_state.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({super.key, required this.categoryBloc});

  final DropdownFieldBloc categoryBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final isLoading = state is CategoryLoading || state is CategoryInitial;
        final hasError = state is CategoryError;
        final List<CategoryEntity> categories =
            state is CategoryLoaded ? state.categories : const [];

        if (state is CategoryLoaded &&
            categoryBloc.state.value != null &&
            !categories.any((c) => c.id == categoryBloc.state.value)) {
          categoryBloc.add(const DropdownValueChanged<String>(null));
        }

        final items = categories
            .map(
              (category) => DropdownMenuItem<String>(
                value: category.id,
                child: Text(category.name),
              ),
            )
            .toList();

        return Stack(
          alignment: Alignment.centerRight,
          children: [
            IgnorePointer(
              ignoring: isLoading,
              child: BlocDropdownField<String>(
                label: 'Category',
                hintText: isLoading
                    ? 'Loading categories...'
                    : hasError
                        ? 'Failed to load categories'
                        : 'Choose Category',
                items: items,
              ),
            ),
            if (isLoading)
              const Positioned(
                right: 12,
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            if (hasError)
              IconButton(
                tooltip: 'Retry',
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    context.read<CategoryBloc>().add(const LoadCategories()),
              ),
          ],
        );
      },
    );
  }
}
