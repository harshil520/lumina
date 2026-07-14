/// A single event in an order's status timeline.
class TimelineEvent {
  const TimelineEvent({
    required this.date,
    required this.status,
    required this.description,
    this.isCompleted = true,
  });

  final DateTime date;
  final String status;
  final String description;
  final bool isCompleted;
}
