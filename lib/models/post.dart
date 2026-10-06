class Post {
  final int? id;
  final int userId;
  final String title;
  final String body;

  Post({
    this.id,
    this.userId = 1,
    required this.title,
    required this.body,
  });

  // JSON (Map) -> Dart object
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int?,
      userId: (json['userId'] ?? 1) as int,
      title: (json['title'] ?? '') as String,
      body: (json['body'] ?? '') as String,
    );
  }

  // Dart object -> JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}
