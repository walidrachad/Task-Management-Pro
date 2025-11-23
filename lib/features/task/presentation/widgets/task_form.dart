import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';
import 'package:task_management_pro_codex/core/ui/bloc/dropdown_field/dropdown_field_bloc.dart';
import 'package:task_management_pro_codex/core/ui/bloc/text_field/text_field_bloc.dart';
import 'package:task_management_pro_codex/core/ui/widgets/bloc_dropdown_field.dart';
import 'package:task_management_pro_codex/core/ui/widgets/custom_button.dart';
import 'package:task_management_pro_codex/core/ui/widgets/custom_text_field.dart';
import 'package:task_management_pro_codex/core/ui/widgets/date_picker_field.dart';
import 'package:task_management_pro_codex/features/task/domain/enums/task_priority.dart';
import 'package:task_management_pro_codex/features/task/presentation/widgets/category_dropdown.dart';
import 'package:task_management_pro_codex/features/task/presentation/widgets/priority_chip.dart';

class TaskForm extends StatelessWidget {
  const TaskForm(
      {super.key,
      required this.titleBloc,
      required this.descriptionBloc,
      required this.submit,
      required this.onDateChanged,
      this.dueDate,
      required this.categoryBloc,
      required this.reminderEnabled,
      this.onReminderChanged});

  final TextFieldBloc titleBloc;
  final TextFieldBloc descriptionBloc;
  final Function(BuildContext context) submit;
  final ValueChanged<DateTime?> onDateChanged;
  final DateTime? dueDate;
  final DropdownFieldBloc categoryBloc;
  final bool reminderEnabled;
  final ValueChanged<bool>? onReminderChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocProvider<TextFieldBloc>.value(
          value: titleBloc,
          child: const BlocTextField(
            label: 'Title',
            hintText: 'Title',
            maxLine: 1,
            keyboardType: TextInputType.text,
          ),
        ),
        const SizedBox(height: AppSpacing.l),
        BlocProvider<TextFieldBloc>.value(
          value: descriptionBloc,
          child: const BlocTextField(
            label: 'Description',
            hintText: 'Description ... ',
            maxLine: 6,
            keyboardType: TextInputType.multiline,
          ),
        ),
        const SizedBox(height: AppSpacing.l),
        BlocDropdownField<TaskPriority>(
          label: 'Priority',
          hintText: 'Choose priority',
          items: TaskPriority.values
              .map(
                (priority) => DropdownMenuItem<TaskPriority>(
                  value: priority,
                  child: Row(
                    children: [
                      PriorityChip(priority: priority),
                      const SizedBox(width: AppSpacing.s),
                      Text(priority.label),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.l),
        CategoryDropdown(
          categoryBloc: categoryBloc,
        ),
        const SizedBox(height: AppSpacing.l),
        DatePickerField(
          label: 'Due date',
          value: dueDate,
          hintText: '',
          onChanged: onDateChanged,
        ),
        const SizedBox(height: AppSpacing.l),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enable reminder'),
          value: reminderEnabled,
          onChanged: onReminderChanged,
        ),
        const SizedBox(height: AppSpacing.xl),
        CustomBlocButton(
          label: 'Create Task',
          icon: Icons.check_rounded,
          onPressed: () {
            submit(context);
          },
        ),
      ],
    );
  }
}
