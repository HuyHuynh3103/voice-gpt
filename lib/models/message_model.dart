class Message {
  String id;
  String content;
  bool isSender;
  bool isTyping;
  bool isError;
  DateTime createdAt;

  Message({
    required this.id,
    this.content = "",
    this.isSender = true,
    this.isTyping = false,
    this.isError = false,
    required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      isSender: json['isSender'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isSender': isSender,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
