import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/learning_module.dart';
import '../models/recitation_session.dart';
import '../widgets/primary_button.dart';
import 'recitation_practice_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState state, Widget? _) {
        final Map<String, num> stats = state.learningStats;
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Salam, ${state.greetingName}'),
                Text(
                  'Ready for your next recitation journey?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: <Widget>[
              _HeroPracticeCard(onStartPractice: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const RecitationPracticeScreen(),
                  ),
                );
              }),
              const SizedBox(height: 24),
              Text('Learning streak', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _StatsRow(stats: stats),
              const SizedBox(height: 24),
              Text('Recommended for you', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.recommendedModules.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (BuildContext context, int index) {
                    final LearningModule module = state.recommendedModules[index];
                    return SizedBox(
                      width: 260,
                      child: _LearningModuleCard(module: module),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text('Recent AI assessments', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              if (state.recentSessions.isEmpty)
                _EmptyState(
                  title: 'No assessments yet',
                  message: 'Launch a practice session to unlock personalised AI grading and insights.',
                )
              else
                ...state.recentSessions
                    .take(3)
                    .map((RecitationSession session) => _RecentAssessmentTile(session: session)),
              const SizedBox(height: 32),
              Text('Upcoming community circles', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ...state.upcomingCommunityCircles.map(
                (Map<String, String> circle) => _CommunityCard(circle: circle),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _HeroPracticeCard extends StatelessWidget {
  const _HeroPracticeCard({required this.onStartPractice});

  final VoidCallback onStartPractice;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            theme.colorScheme.primary,
            theme.colorScheme.tertiary.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -12,
            top: -16,
            child: Opacity(
              opacity: 0.35,
              child: SvgPicture.asset(
                'assets/illustrations/onboarding_hero.svg',
                width: 160,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(Icons.auto_graph_rounded, color: Colors.white),
                  ),
                  const Spacer(),
                  Chip(
                    label: const Text('AI powered'),
                    backgroundColor: Colors.white.withOpacity(0.18),
                    labelStyle: theme.textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'Continue Surah Al-Mulk practice',
                style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                '3 improvement points identified. Let’s close the gap with a guided session.',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Start guided practice',
                icon: Icons.mic_rounded,
                onPressed: onStartPractice,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final Map<String, num> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _StatCard(
            value: '${stats['streak']} days',
            label: 'Practice streak',
            icon: Icons.local_fire_department_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: '${(stats['hours'] ?? 0).toStringAsFixed(1)} hrs',
            label: 'Guided time',
            icon: Icons.timer_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: '${(stats['overallScore'] ?? 0).toStringAsFixed(1)}%',
            label: 'Avg. score',
            icon: Icons.grade_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 18),
            Text(
              value,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _LearningModuleCard extends StatelessWidget {
  const _LearningModuleCard({required this.module});

  final LearningModule module;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Chip(label: Text(module.level)),
            const SizedBox(height: 16),
            Text(module.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(module.description, style: theme.textTheme.bodyMedium),
            const Spacer(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: module.focusAreas
                  .map((String focus) => Chip(
                        label: Text(focus),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentAssessmentTile extends StatelessWidget {
  const _RecentAssessmentTile({required this.session});

  final RecitationSession session;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Text('${session.surah} · ${session.ayahRange}', style: theme.textTheme.titleLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 6),
            Text(session.feedbackSummary, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                _ScorePill(label: 'Overall', score: session.overallScore),
                const SizedBox(width: 8),
                _ScorePill(label: 'Tajweed', score: session.tajweedScore),
                const SizedBox(width: 8),
                _ScorePill(label: 'Fluency', score: session.fluencyScore),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.keyboard_arrow_right_rounded),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => AssessmentDetailSheet(session: session),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.label, required this.score});

  final String label;
  final double score;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text('$label ${score.toStringAsFixed(1)}%',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary)),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({required this.circle});

  final Map<String, String> circle;

  @override
  Widget build(BuildContext context) {
    return Card(
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
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text('Remind me'),
        ),
      ),
    );
  }
}

class AssessmentDetailSheet extends StatelessWidget {
  const AssessmentDetailSheet({super.key, required this.session});

  final RecitationSession session;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI assessment breakdown'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${session.surah} · ${session.ayahRange}', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                _ScoreTile(label: 'Overall accuracy', value: session.overallScore),
                _ScoreTile(label: 'Tajweed rules', value: session.tajweedScore),
                _ScoreTile(label: 'Pronunciation', value: session.pronunciationScore),
                _ScoreTile(label: 'Fluency & pacing', value: session.fluencyScore),
              ],
            ),
            const SizedBox(height: 24),
            Text('AI insights', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(session.feedbackSummary, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            Text('Next focus areas', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            ...session.recommendedFocus
                .map((String focus) => ListTile(
                      leading: const Icon(Icons.check_circle_outline_rounded),
                      title: Text(focus),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}

class _ScoreTile extends StatelessWidget {
  const _ScoreTile({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$value%', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.primary.withOpacity(0.07),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
