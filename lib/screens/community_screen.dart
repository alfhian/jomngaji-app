import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState state, Widget? _) {
        final List<Map<String, String>> circles = state.upcomingCommunityCircles;
        return Scaffold(
          appBar: AppBar(title: const Text('Community circles')),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                    child: Icon(Icons.handshake_rounded, color: Theme.of(context).colorScheme.primary),
                  ),
                  title: Text('Connect with certified ustaz & peers', style: Theme.of(context).textTheme.titleLarge),
                  subtitle: Text(
                    'Reserve live classes, get annotated feedback from mentors, and collaborate with fellow reciters.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Browse mentors'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Upcoming halaqah & workshops', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ...circles.map(
                (Map<String, String> circle) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(circle['title'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 4),
                        Text(circle['time'] ?? ''),
                        const SizedBox(height: 4),
                        Text(circle['description'] ?? ''),
                      ],
                    ),
                    trailing: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Reserve spot'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Peer leaderboards', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const _LeaderboardCard(
                title: 'Consistency champions',
                description: 'Top 10 learners with the highest weekly recitation streak.',
                participants: <String>['Amina', 'Farid', 'Sakinah', 'Hafiz'],
              ),
              const SizedBox(height: 12),
              const _LeaderboardCard(
                title: 'Top tajweed progress',
                description: 'Learners who improved tajweed accuracy by 15% or more this month.',
                participants: <String>['Haziq', 'Maryam', 'Rania', 'Yusuf'],
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard({
    required this.title,
    required this.description,
    required this.participants,
  });

  final String title;
  final String description;
  final List<String> participants;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: participants
                  .map((String name) => Chip(
                        avatar: const CircleAvatar(child: Icon(Icons.person_outline, size: 18)),
                        label: Text(name),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
