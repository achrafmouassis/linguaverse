class Lesson {
  final String id;
  final String title;
  final bool isCompleted;

  const Lesson({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Lesson copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
