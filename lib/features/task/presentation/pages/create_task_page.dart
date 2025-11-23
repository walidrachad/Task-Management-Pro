import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/core/ui/bloc/button/button_bloc.dart';
import 'package:task_management_pro_codex/core/ui/bloc/button/button_event.dart';
import 'package:task_management_pro_codex/core/ui/bloc/dropdown_field/dropdown_field_bloc.dart';
import 'package:task_management_pro_codex/core/ui/bloc/dropdown_field/dropdown_field_event.dart';
import 'package:task_management_pro_codex/core/utils/validators/base/text_validator.dart';
import 'package:task_management_pro_codex/core/ui/bloc/text_field/text_field_bloc.dart';
import 'package:task_management_pro_codex/core/ui/bloc/text_field/text_field_event.dart';
import 'package:task_management_pro_codex/core/utils/validators/required_selection_validator.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_bloc.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_event.dart';
import 'package:task_management_pro_codex/features/category/presentation/bloc/category_state.dart';
import 'package:task_management_pro_codex/features/task/domain/entities/task_entity.dart';
import 'package:task_management_pro_codex/features/task/domain/enums/task_priority.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_management_pro_codex/features/task/presentation/bloc/task_event.dart';
import 'package:task_management_pro_codex/features/task/presentation/widgets/task_form.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key, this.task});

  final TaskEntity? task;

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  late final TextFieldBloc _titleBloc;
  late final TextFieldBloc _descriptionBloc;
  late final ButtonBloc _buttonBloc;
  late final DropdownFieldBloc<TaskPriority> _priorityBloc;
  late final DropdownFieldBloc<String> _categoryBloc;
  DateTime? _dueDate;
  bool _reminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleBloc = TextFieldBloc(
      validator: RequiredValidator(message: 'Title is required'),
    );
    _descriptionBloc = TextFieldBloc();
    _buttonBloc = ButtonBloc(initialEnabled: true);
    _priorityBloc = DropdownFieldBloc<TaskPriority>(
      validator: RequiredSelectionValidator<TaskPriority>(
        message: 'Please choose a priority',
      ),
      initialValue: widget.task?.priority,
    );
    _categoryBloc = DropdownFieldBloc<String>(
      validator: RequiredSelectionValidator<String>(
        message: 'Please choose a category',
      ),
      initialValue: widget.task?.categoryId,
    );
    _dueDate = widget.task?.dueDate;
    _reminderEnabled = widget.task?.isReminderEnabled ?? false;
    _prefillFields();
    _ensureCategoriesLoaded();
  }

  @override
  void dispose() {
    _titleBloc.close();
    _descriptionBloc.close();
    _buttonBloc.close();
    _priorityBloc.close();
    _categoryBloc.close();
    super.dispose();
  }

  void _submit(BuildContext context) {
    _triggerValidation();

    if (_hasValidationErrors()) {
      return;
    }

    final isEditing = widget.task != null;
    final title = _titleBloc.state.value.trim();
    final description = _descriptionBloc.state.value.trim();
    final priority = _priorityBloc.state.value;
    if (priority == null) return;

    final task = TaskEntity(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description.isEmpty ? null : description,
      dueDate: _dueDate,
      status: widget.task?.status ?? 'Pending',
      priority: priority,
      categoryId: _categoryBloc.state.value,
      isReminderEnabled: _reminderEnabled,
    );

    _setButtonLoading(true);

    context.read<TaskBloc>().add(
          isEditing ? UpdateTaskEvent(task) : CreateTaskEvent(task),
        );
    Navigator.of(context).pop();
    _setButtonLoading(false);
  }

  void _triggerValidation() {
    _titleBloc.add(const TextFieldSubmitted());
    _descriptionBloc.add(const TextFieldSubmitted());
    _priorityBloc.add(const DropdownSubmitted<TaskPriority>());
    _categoryBloc.add(const DropdownSubmitted<String>());
  }

  bool _hasValidationErrors() {
    final hasTitleError =
        _titleBloc.validator?.validate(_titleBloc.state.value) != null;
    final hasPriorityError =
        _priorityBloc.validator?.validate(_priorityBloc.state.value) != null;
    final hasCategoryError =
        _categoryBloc.validator?.validate(_categoryBloc.state.value) != null;
    return hasTitleError || hasPriorityError || hasCategoryError;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ButtonBloc>.value(value: _buttonBloc),
        BlocProvider<DropdownFieldBloc<TaskPriority>>.value(
          value: _priorityBloc,
        ),
        BlocProvider<DropdownFieldBloc<String>>.value(
          value: _categoryBloc,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Task'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskForm(
                titleBloc: _titleBloc,
                descriptionBloc: _descriptionBloc,
                onDateChanged: (date) {
                  setState(() => _dueDate = date);
                },
                dueDate: _dueDate,
                categoryBloc: _categoryBloc,
                reminderEnabled: _reminderEnabled,
                onReminderChanged:(value) {
                  setState(() {
                    _reminderEnabled = value;
                  });
                },
                submit: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _prefillFields() {
    final task = widget.task;
    if (task == null) return;

    _titleBloc.add(TextFieldTextChanged(task.title));
    _descriptionBloc.add(TextFieldTextChanged(task.description ?? ''));
  }

  void _setButtonLoading(bool isLoading) {
    _buttonBloc
      ..add(ButtonSetLoading(isLoading))
      ..add(ButtonSetEnabled(!isLoading));
  }

  void _ensureCategoriesLoaded() {
    final categoryBloc = context.read<CategoryBloc>();
    final currentState = categoryBloc.state;

    if (currentState is CategoryInitial || currentState is CategoryError) {
      categoryBloc.add(const LoadCategories());
    }
  }
}
