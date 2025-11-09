import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'practice_library_screen.dart';
import 'progress_insights_screen.dart';
import 'community_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  static const String routeName = '/home';

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const <Widget>[
          DashboardScreen(),
          PracticeLibraryScreen(),
          ProgressInsightsScreen(),
          CommunityScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        height: 72,
        onDestinationSelected: (int index) => setState(() => _currentIndex = index),
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.mic_external_on_rounded), label: 'Practice'),
          NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'Progress'),
          NavigationDestination(icon: Icon(Icons.groups_2_rounded), label: 'Community'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        surfaceTintColor: theme.colorScheme.surface,
      ),
    );
  }
}
