import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro_codex/core/constants/app_spacing.dart';
import 'package:task_management_pro_codex/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:task_management_pro_codex/features/settings/presentation/bloc/settings_event.dart';
import 'package:task_management_pro_codex/features/settings/presentation/bloc/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkModeEnabled = false;
  TimeOfDay? _dailySummaryTime;

  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<SettingsBloc>();
    if (bloc.state is SettingsInitial) {
      bloc.add(const LoadSettings());
    }
  }

  void _hydrateFromState(SettingsLoaded state) {
    _darkModeEnabled = state.themeMode == ThemeMode.dark;
    _dailySummaryTime = state.dailySummaryTime;
    _hasLoadedOnce = true;
  }

  Future<void> _pickTime(BuildContext context) async {
    final initial = _dailySummaryTime ?? TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (picked != null) {
      setState(() {
        _dailySummaryTime = picked;
        _onSave();
      });
    }
  }

  void _onSave() {
    context.read<SettingsBloc>().add(
          UpdateSettingsEvent(
            themeMode: _darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            dailySummaryTime: _dailySummaryTime,
          ),
        );
  }

  String _formatTime(BuildContext context, TimeOfDay? time) {
    if (time == null) return 'Not set';
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded) {
            setState(() {
              _hydrateFromState(state);
            });
          } else if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Failed to load settings')),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading || state is SettingsInitial) {
            if (!_hasLoadedOnce) {
              return const Center(child: CircularProgressIndicator());
            }
          }

          if (!_hasLoadedOnce && state is SettingsError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message ?? 'Failed to load settings'),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<SettingsBloc>().add(const LoadSettings()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final isUpdating = state is SettingsLoading;

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Dark mode'),
                  value: _darkModeEnabled,
                  onChanged: isUpdating
                      ? null
                      : (value) {
                          setState(() {
                            _darkModeEnabled = value;
                            _onSave();
                          });
                        },
                ),
                const SizedBox(height: AppSpacing.l),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Daily summary notification'),
                  subtitle: Text(_formatTime(context, _dailySummaryTime)),
                  trailing: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: isUpdating ? null : () => _pickTime(context),
                  ),
                  onTap: isUpdating ? null : () => _pickTime(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
