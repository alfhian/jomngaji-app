import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState state, Widget? _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile & settings')),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      state.greetingName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(state.greetingName, style: Theme.of(context).textTheme.titleLarge),
                  subtitle: const Text('Premium learner · AI guided'),
                  trailing: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Edit profile'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Practice schedule', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const _ScheduleCard(
                title: 'Morning warm-up',
                description: '7:00 AM · 15 minutes · Breath control & makharij drills',
              ),
              const SizedBox(height: 12),
              const _ScheduleCard(
                title: 'Evening guided session',
                description: '8:30 PM · AI assessment · Surah Al-Mulk segments',
              ),
              const SizedBox(height: 24),
              Text('Preferences', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const _PreferenceTile(
                icon: Icons.notifications_active_outlined,
                title: 'Smart reminders',
                description: 'Receive progress nudges and halaqah alerts.',
              ),
              const _PreferenceTile(
                icon: Icons.language_outlined,
                title: 'Interface language',
                description: 'English (change)',
              ),
              const _PreferenceTile(
                icon: Icons.security_outlined,
                title: 'Privacy controls',
                description: 'Manage shared recordings and community visibility.',
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => state.signOut(),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Sign out'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(Icons.calendar_today_rounded, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.titleLarge),
        subtitle: Text(description, style: theme.textTheme.bodyMedium),
        trailing: OutlinedButton(
          onPressed: () {},
          child: const Text('Reschedule'),
        ),
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.titleLarge),
        subtitle: Text(description, style: theme.textTheme.bodyMedium),
        trailing: Switch(
          value: true,
          onChanged: (_) {},
        ),
      ),
    );
  }
}
