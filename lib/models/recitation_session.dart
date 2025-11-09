class RecitationSession {
  RecitationSession({
    required this.surah,
    required this.ayahRange,
    required this.timestamp,
    required this.overallScore,
    required this.fluencyScore,
    required this.tajweedScore,
    required this.pronunciationScore,
    required this.feedbackSummary,
    required this.recommendedFocus,
  });

  final String surah;
  final String ayahRange;
  final DateTime timestamp;
  final double overallScore;
  final double fluencyScore;
  final double tajweedScore;
  final double pronunciationScore;
  final String feedbackSummary;
  final List<String> recommendedFocus;
}
