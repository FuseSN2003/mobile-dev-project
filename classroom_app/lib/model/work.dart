class Work {
  final String title;
  final String description;
  final DateTime created_at;
  final DateTime due_date;
  final int score;

  Work({
    required this.title,
    required this.description,
    required this.created_at,
    required this.due_date,
    required this.score,
  });
}
