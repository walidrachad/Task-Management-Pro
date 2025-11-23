import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:task_management_pro_codex/app/routes.dart';
import 'package:task_management_pro_codex/features/home/presentation/widgets/home_section.dart';
import 'package:task_management_pro_codex/features/settings/presentation/pages/settings_page.dart';
import 'package:task_management_pro_codex/features/task/presentation/pages/task_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      _NavItem(
        label: l10n.home,
        icon: Icons.home_rounded,
        builder: (_) => const HomeSection(),
      ),
      _NavItem(
        label: l10n.tasks,
        icon: Icons.list_alt_rounded,
        builder: (_) => const TaskListPage(),
      ),
      _NavItem(
        label: l10n.settings,
        icon: Icons.settings,
        builder: (_) => const SettingsPage(),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: items.map((item) => item.builder(context)).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: items
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
        onDestinationSelected: _onItemTapped,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.createTask);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.builder,
  });

  final String label;
  final IconData icon;
  final WidgetBuilder builder;
}
