class Task {
  String title;
  String description;
  String deadline;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.deadline,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline,
      'isCompleted': isCompleted.toString(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      deadline: map['deadline'] ?? '',
      isCompleted: map['isCompleted'] == 'true',
    );
  }
}
