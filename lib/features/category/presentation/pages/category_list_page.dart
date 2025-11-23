import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_bloc.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_event.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_state.dart';
import 'package:task_management_pro_codex/features/category/presentation/widgets/category_chip.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading || state is CategoryInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message ?? 'Failed to load categories'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<CategoryBloc>()
                          .add(const LoadCategories()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CategoryLoaded) {
            if (state.categories.isEmpty) {
              return const Center(child: Text('No categories available'));
            }

            return Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.6,
                ),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return CategoryChip(category: category);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
