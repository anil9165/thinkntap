class Task {
  int id;
  int userId;
  String title;
  bool completed;

  Task({required this.id, required this.title, required this.completed,required this.userId});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
      'completed': completed ? 1 : 0,
    };
  }
}
