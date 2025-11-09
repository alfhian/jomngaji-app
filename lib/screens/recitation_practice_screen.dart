import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models/recitation_session.dart';
import 'recitation_result_screen.dart';

class RecitationPracticeScreen extends StatefulWidget {
  const RecitationPracticeScreen({super.key, this.defaultSurah});

  static const String routeName = '/practice';

  final String? defaultSurah;

  @override
  State<RecitationPracticeScreen> createState() => _RecitationPracticeScreenState();
}

class _RecitationPracticeScreenState extends State<RecitationPracticeScreen> {
  final List<String> _surahOptions = const <String>['Al-Fatihah', 'Al-Mulk', 'Yasin', 'Ar-Rahman', 'Al-Kahf'];
  final List<String> _ayahSegments = const <String>['Ayat 1-5', 'Ayat 6-10', 'Ayat 11-15', 'Complete Surah'];

  late String _selectedSurah;
  String _selectedAyah = 'Ayat 1-5';
  bool _isRecording = false;
  double _recordingProgress = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _selectedSurah = widget.defaultSurah ?? _surahOptions.first;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleRecording() {
    if (_isRecording) {
      _finishRecording();
    } else {
      setState(() {
        _isRecording = true;
        _recordingProgress = 0;
      });
      _timer = Timer.periodic(const Duration(milliseconds: 400), (Timer timer) {
        setState(() {
          _recordingProgress += 0.08;
          if (_recordingProgress >= 1) {
            timer.cancel();
            _finishRecording();
          }
        });
      });
    }
  }

  Future<void> _finishRecording() async {
    _timer?.cancel();
    setState(() => _isRecording = false);
    final RecitationSession session = context
        .read<AppState>()
        .simulateAiAssessment(surah: _selectedSurah, ayahRange: _selectedAyah);
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => RecitationResultScreen(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided recitation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Select focus', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _surahOptions
                  .map(
                    (String surah) => ChoiceChip(
                      label: Text(surah),
                      selected: surah == _selectedSurah,
                      onSelected: (bool value) {
                        if (!value) return;
                        setState(() => _selectedSurah = surah);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedAyah,
              items: _ayahSegments
                  .map((String ayah) => DropdownMenuItem<String>(
                        value: ayah,
                        child: Text(ayah),
                      ))
                  .toList(),
              onChanged: (String? value) {
                if (value == null) return;
                setState(() => _selectedAyah = value);
              },
              decoration: const InputDecoration(
                labelText: 'Ayat focus range',
                prefixIcon: Icon(Icons.stacked_line_chart_rounded),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: _PracticeConsole(
                isRecording: _isRecording,
                progress: _recordingProgress,
                onToggleRecording: _toggleRecording,
                surah: _selectedSurah,
                ayah: _selectedAyah,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticeConsole extends StatelessWidget {
  const _PracticeConsole({
    required this.isRecording,
    required this.progress,
    required this.onToggleRecording,
    required this.surah,
    required this.ayah,
  });

  final bool isRecording;
  final double progress;
  final VoidCallback onToggleRecording;
  final String surah;
  final String ayah;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Current track', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.menu_book_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(surah, style: theme.textTheme.titleLarge),
                        Text(ayah, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Reference audio'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 160,
                          width: 160,
                          child: CircularProgressIndicator(
                            value: isRecording ? progress : 0,
                            strokeWidth: 10,
                          ),
                        ),
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: isRecording ? theme.colorScheme.error.withOpacity(0.15) : theme.colorScheme.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                            color: isRecording ? theme.colorScheme.error : theme.colorScheme.primary,
                            size: 48,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isRecording ? 'Recording in progress...' : 'Tap to start recording',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 220,
                    child: ElevatedButton.icon(
                      onPressed: onToggleRecording,
                      icon: Icon(isRecording ? Icons.stop_circle_rounded : Icons.mic_none_rounded),
                      label: Text(isRecording ? 'Finish & grade' : 'Start AI capture'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isRecording ? theme.colorScheme.error : theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tip: maintain consistent airflow and emphasise qalqalah letters. Our AI listens for tajweed accuracy and rhythm.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
