import 'package:flutter/material.dart';

import '../models/recitation_session.dart';

class RecitationResultScreen extends StatelessWidget {
  const RecitationResultScreen({super.key, required this.session});

  final RecitationSession session;

  String get _qualitativeGrade {
    if (session.overallScore >= 90) return 'Excellent';
    if (session.overallScore >= 80) return 'Great job';
    if (session.overallScore >= 70) return 'Keep improving';
    return 'Let’s focus';
  }

  Color _gradeColor(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (session.overallScore >= 90) return theme.colorScheme.primary;
    if (session.overallScore >= 80) return const Color(0xFF2A9D8F);
    if (session.overallScore >= 70) return const Color(0xFFFA9F42);
    return theme.colorScheme.error;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI grading summary'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _gradeColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: _gradeColor(context),
                    child: Text(
                      '${session.overallScore.toStringAsFixed(0)}%',
                      style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_qualitativeGrade, style: theme.textTheme.headlineSmall),
                        Text('${session.surah} · ${session.ayahRange}', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        Text(session.feedbackSummary, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Score breakdown', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                _ScoreChip(label: 'Tajweed rules', value: session.tajweedScore),
                _ScoreChip(label: 'Pronunciation clarity', value: session.pronunciationScore),
                _ScoreChip(label: 'Fluency & pacing', value: session.fluencyScore),
              ],
            ),
            const SizedBox(height: 24),
            Text('AI powered focus plan', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            ...session.recommendedFocus.map(
              (String focus) => Card(
                child: ListTile(
                  leading: const Icon(Icons.auto_fix_high_outlined),
                  title: Text(focus),
                  subtitle: const Text('Repeat 3x · Track improvements with next recording'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Share progress', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.ios_share_rounded),
                  label: const Text('Share report'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Practice again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$value%', style: theme.textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
