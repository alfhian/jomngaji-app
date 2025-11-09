import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/recitation_session.dart';

class ProgressInsightsScreen extends StatelessWidget {
  const ProgressInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState state, Widget? _) {
        final Map<String, dynamic> stats = state.learningStats;
        return Scaffold(
          appBar: AppBar(title: const Text('Progress insights')),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              _SummaryPanel(stats: stats),
              const SizedBox(height: 24),
              Text('Assessment history', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              if (state.recentSessions.isEmpty)
                _EmptyState(
                  message:
                      'Run your first AI assessment to populate your tajweed, pronunciation, and fluency charts.',
                )
              else
                ...state.recentSessions
                    .map((RecitationSession session) => _HistoryTile(session: session))
                    .toList(),
              const SizedBox(height: 24),
              Text('Weekly focus recommendations', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const _RecommendationCard(
                title: 'Strengthen qalqalah articulation',
                description:
                    'Focus on letters qaaf, taa, and baa across Surah Al-Qadr. Use slow metronome playback to refine stops.',
                actionLabel: 'Launch drill',
              ),
              const SizedBox(height: 12),
              const _RecommendationCard(
                title: 'Elevate melodic flow',
                description:
                    'Practice the ascending melody pattern in Surah Ar-Rahman ayat 26-30. Record twice daily for rhythm control.',
                actionLabel: 'Open practice',
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.stats});

  final Map<String, dynamic> stats;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Your learning analytics', style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: <Widget>[
                _SummaryTile(
                  label: 'Avg. overall score',
                  value: '${stats['overallScore']}%',
                  icon: Icons.insights_rounded,
                ),
                _SummaryTile(
                  label: 'Avg. tajweed score',
                  value: '${stats['tajweedScore']}%',
                  icon: Icons.rule_folder_rounded,
                ),
                _SummaryTile(
                  label: 'Avg. fluency score',
                  value: '${stats['fluencyScore']}%',
                  icon: Icons.graphic_eq_rounded,
                ),
                _SummaryTile(
                  label: 'Active streak',
                  value: '${stats['streak']} days',
                  icon: Icons.local_fire_department_rounded,
                ),
                _SummaryTile(
                  label: 'Guided minutes',
                  value: '${double.tryParse(stats['hours'].toString()) != null ? double.parse(stats['hours']).toStringAsFixed(1) : stats['hours']} hrs',
                  icon: Icons.timer_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: 160,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(height: 14),
          Text(value, style: theme.textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.session});

  final RecitationSession session;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text('${session.surah} · ${session.ayahRange}'),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Overall ${session.overallScore}% · Tajweed ${session.tajweedScore}% · Fluency ${session.fluencyScore}%'),
              Text('Recorded ${_timeAgo(session.timestamp)}'),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.open_in_new_rounded),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (BuildContext context) => _HistoryBottomSheet(session: session),
            );
          },
        ),
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final Duration difference = DateTime.now().difference(time);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours} hrs ago';
    }
    return '${difference.inDays} days ago';
  }
}

class _HistoryBottomSheet extends StatelessWidget {
  const _HistoryBottomSheet({required this.session});

  final RecitationSession session;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Detailed scores', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          _ScoreRow(label: 'Overall accuracy', value: session.overallScore),
          _ScoreRow(label: 'Tajweed rules', value: session.tajweedScore),
          _ScoreRow(label: 'Pronunciation', value: session.pronunciationScore),
          _ScoreRow(label: 'Fluency & pacing', value: session.fluencyScore),
          const SizedBox(height: 16),
          Text('AI feedback', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(session.feedbackSummary, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          Text('Recommended drills', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          ...session.recommendedFocus.map((String focus) => ListTile(
                leading: const Icon(Icons.check_circle_outline_rounded),
                title: Text(focus),
              )),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          const SizedBox(width: 12),
          Text('${value.toStringAsFixed(1)}%', style: theme.textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.title,
    required this.description,
    required this.actionLabel,
  });

  final String title;
  final String description;
  final String actionLabel;

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
            const SizedBox(height: 8),
            Text(description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
      ),
      child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
