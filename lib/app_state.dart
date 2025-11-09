import 'dart:math';

import 'package:flutter/material.dart';

import 'models/learning_module.dart';
import 'models/recitation_session.dart';

class AppState extends ChangeNotifier {
  AppState();

  bool _onboardingComplete = false;
  bool _authenticated = false;
  String? _displayName;
  final List<RecitationSession> _sessions = <RecitationSession>[];
  final Random _random = Random();

  bool get onboardingComplete => _onboardingComplete;
  bool get isAuthenticated => _authenticated;
  String get greetingName => _displayName ?? 'Student';
  List<RecitationSession> get recentSessions => List.unmodifiable(_sessions);

  List<LearningModule> get recommendedModules => <LearningModule>[
        LearningModule(
          title: 'Makharij & Pronunciation Mastery',
          description:
              'Strengthen letter articulation through focused warm-ups and AI-guided correction loops.',
          level: 'Intermediate',
          focusAreas: const <String>['Makharij', 'Pronunciation', 'Warm-up'],
        ),
        LearningModule(
          title: 'Melodic Recitation Practice',
          description:
              'Build vocal confidence by repeating melodic patterns and breathing techniques.',
          level: 'Beginner',
          focusAreas: const <String>['Taranum', 'Breathing', 'Confidence'],
        ),
        LearningModule(
          title: 'Advanced Tajweed Clinic',
          description:
              'Deep dive into Idgham and Ikhfa rules with visual guidance and AI paired examples.',
          level: 'Advanced',
          focusAreas: const <String>['Idgham', 'Ikhfa', 'Rules Application'],
        ),
      ];

  List<Map<String, String>> get upcomingCommunityCircles => <Map<String, String>>[
        <String, String>{
          'title': 'Virtual Halaqah with Ustazah Maryam',
          'time': 'Tonight · 8:30 PM',
          'description': 'Focus on Surah Al-Mulk with live tajweed drills.',
        },
        <String, String>{
          'title': 'Weekend Recitation Circle',
          'time': 'Sat · 9:00 AM',
          'description': 'Peer review and AI-assisted correction sharing session.',
        },
        <String, String>{
          'title': 'Breathing Technique Workshop',
          'time': 'Sun · 4:00 PM',
          'description': 'Practical exercises for controlled recitation flow.',
        },
      ];

  Map<String, num> get learningStats {
    if (_sessions.isEmpty) {
      return <String, num>{
        'streak': 0,
        'hours': 0.0,
        'overallScore': 0.0,
        'tajweedScore': 0.0,
        'fluencyScore': 0.0,
      };
    }

    final double overallScore =
        _sessions.fold<double>(0, (double previousValue, RecitationSession element) => previousValue + element.overallScore) /
            _sessions.length;
    final double tajweedScore =
        _sessions.fold<double>(0, (double previousValue, RecitationSession element) => previousValue + element.tajweedScore) /
            _sessions.length;
    final double fluencyScore =
        _sessions.fold<double>(0, (double previousValue, RecitationSession element) => previousValue + element.fluencyScore) /
            _sessions.length;

    return <String, num>{
      'streak': _sessions.length,
      'hours': double.parse((_sessions.length * 0.5).toStringAsFixed(1)),
      'overallScore': double.parse(overallScore.toStringAsFixed(1)),
      'tajweedScore': double.parse(tajweedScore.toStringAsFixed(1)),
      'fluencyScore': double.parse(fluencyScore.toStringAsFixed(1)),
    };
  }

  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

  void signIn(String name) {
    _displayName = name.isEmpty ? 'Student' : name;
    _authenticated = true;
    notifyListeners();
  }

  void signOut() {
    _authenticated = false;
    notifyListeners();
  }

  RecitationSession simulateAiAssessment({
    required String surah,
    required String ayahRange,
  }) {
    final double baseScore = 70 + _random.nextInt(25) + _random.nextDouble();
    final double tajweedScore = min(100, baseScore + _random.nextDouble() * 5);
    final double pronunciationScore = min(100, baseScore - 5 + _random.nextDouble() * 8);
    final double fluencyScore = min(100, baseScore - 3 + _random.nextDouble() * 6);
    final RecitationSession session = RecitationSession(
      surah: surah,
      ayahRange: ayahRange,
      timestamp: DateTime.now(),
      overallScore: double.parse(baseScore.toStringAsFixed(1)),
      fluencyScore: double.parse(fluencyScore.toStringAsFixed(1)),
      tajweedScore: double.parse(tajweedScore.toStringAsFixed(1)),
      pronunciationScore: double.parse(pronunciationScore.toStringAsFixed(1)),
      feedbackSummary:
          'Great effort! Pay attention to prolonged vowels in ayat 3 and smooth your transitions between qalqalah letters.',
      recommendedFocus: <String>[
        'Repeat ayat 3-5 with metronome guidance.',
        'Slow drills for qalqalah articulation.',
        'Record twice daily for consistency.',
      ],
    );
    _sessions.insert(0, session);
    notifyListeners();
    return session;
  }

  List<Map<String, String>> get practiseLibrary => <Map<String, String>>[
        <String, String>{
          'surah': 'Al-Fatihah',
          'level': 'Foundation',
          'duration': '5 min warm-up',
          'focus': 'Opening recitation mastery',
        },
        <String, String>{
          'surah': 'Al-Mulk',
          'level': 'Intermediate',
          'duration': '12 min guided',
          'focus': 'Breathing & pauses',
        },
        <String, String>{
          'surah': 'Yasin',
          'level': 'Advanced',
          'duration': '20 min deep practice',
          'focus': 'Tajweed with melody',
        },
        <String, String>{
          'surah': 'Ar-Rahman',
          'level': 'Advanced',
          'duration': '18 min immersive',
          'focus': 'Voice control & intonation',
        },
      ];
}
