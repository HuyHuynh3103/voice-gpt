class Message {
  String id;
  String content;
  bool isSender;
  bool isLoading;
  bool isError;
  Message({
    required this.id,
    this.content = "",
    this.isSender = true,
    this.isLoading = false,
    this.isError = false,
  });

  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      isSender: json['isSender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isSender': isSender,
    };
  }
}
