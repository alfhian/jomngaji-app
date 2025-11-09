import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import 'recitation_practice_screen.dart';

class PracticeLibraryScreen extends StatelessWidget {
  const PracticeLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState state, Widget? _) {
        final List<Map<String, String>> library = state.practiseLibrary;
        return Scaffold(
          appBar: AppBar(title: const Text('Practice studio')),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.info_outline_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Select a surah focus below to begin a guided recording session with AI alignment.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ...library.map((Map<String, String> practise) => _PracticeTile(practise: practise)),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Need a personalised plan?', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        'Upload your last recitation and our AI will build a weekly programme tuned to your tajweed goals.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.cloud_upload_outlined),
                        label: const Text('Upload recording'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PracticeTile extends StatelessWidget {
  const _PracticeTile({required this.practise});

  final Map<String, String> practise;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(practise['surah'] ?? '', style: theme.textTheme.titleLarge),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Focus: ${practise['focus']}'),
              Text('Level: ${practise['level']} • Duration: ${practise['duration']}'),
            ],
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => RecitationPracticeScreen(
                  defaultSurah: practise['surah'],
                ),
              ),
            );
          },
          child: const Text('Start'),
        ),
      ),
    );
  }
}
