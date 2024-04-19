class Task {
  final int? id;
  String title;
  final String username;
  bool isCompleted;

  Task(
      {this.id,
      required this.title,
      required this.username,
      this.isCompleted = false});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      username: map['username'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  Map<String, dynamic> toMapWithId() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
