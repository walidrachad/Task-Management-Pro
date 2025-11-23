import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/app/routes.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_bloc.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_state.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_event.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_state.dart';
import 'package:task_management_pro_codex/features/task/presentation/widgets/task_card.dart';
import 'package:task_management_pro_codex/features/task/presentation/animations/shimmer.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _statusFilter;
  String? _priorityFilter;
  String? _categoryFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    context.read<TaskBloc>().add(const LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  border: InputBorder.none,
                ),
                onChanged: (query) =>
                    context.read<TaskBloc>().add(SearchTasks(query)),
              )
            : const Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _isSearching ? _stopSearch : _startSearch,
          ),
          PopupMenuButton<SortField>(
            icon: const Icon(Icons.sort),
            onSelected: (value) =>
                context.read<TaskBloc>().add(SortTasks(value)),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: SortField.date,
                child: Text('Sort by date'),
              ),
              PopupMenuItem(
                value: SortField.priority,
                child: Text('Sort by priority'),
              ),
              PopupMenuItem(
                value: SortField.status,
                child: Text('Sort by status'),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading || state is TaskInitial) {
            return const ShimmerListPlaceholder();
          }
          if (state is TaskLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(const RefreshTasks());
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.l),
                itemCount: state.tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return TaskCard(task: task);
                },
              ),
            );
          }

          if (state is TaskEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(const RefreshTasks());
              },
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.l),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Center(
                      child: Text(state.message ?? 'No tasks available'),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is TaskError) {
            return Center(
              child: Text(state.message ?? 'Something went wrong'),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Tasks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.l),
                DropdownButtonFormField<String?>(
                  value: _statusFilter,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Any')),
                    DropdownMenuItem(value: 'Todo', child: Text('Todo')),
                    DropdownMenuItem(
                        value: 'In Progress', child: Text('In Progress')),
                    DropdownMenuItem(
                        value: 'Completed', child: Text('Completed')),
                  ],
                  onChanged: (value) => setState(() => _statusFilter = value),
                ),
                const SizedBox(height: AppSpacing.l),
                DropdownButtonFormField<String?>(
                  value: _priorityFilter,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Any')),
                    DropdownMenuItem(value: 'Low', child: Text('Low')),
                    DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'High', child: Text('High')),
                    DropdownMenuItem(value: 'Urgent', child: Text('Urgent')),
                  ],
                  onChanged: (value) => setState(() => _priorityFilter = value),
                ),
                const SizedBox(height: AppSpacing.l),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    final categories =
                        state is CategoryLoaded ? state.categories : [];
                    return DropdownButtonFormField<String?>(
                      value: _categoryFilter,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Any')),
                        ...categories.map(
                          (category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _categoryFilter = value),
                    );
                  },
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _statusFilter = null;
                            _priorityFilter = null;
                            _categoryFilter = null;
                          });
                          context.read<TaskBloc>().add(
                                const LoadTasks(),
                              );
                          Navigator.of(context).maybePop();
                        },
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<TaskBloc>().add(
                                FilterTasks(
                                  status: _statusFilter,
                                  priority: _priorityFilter,
                                  categoryId: _categoryFilter,
                                ),
                              );
                          Navigator.of(context).maybePop();
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
