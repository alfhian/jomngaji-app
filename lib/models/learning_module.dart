class LearningModule {
  LearningModule({
    required this.title,
    required this.description,
    required this.level,
    required this.focusAreas,
    this.durationMinutes = 25,
  });

  final String title;
  final String description;
  final String level;
  final List<String> focusAreas;
  final int durationMinutes;
}
