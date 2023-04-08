class Message {
  String content;
  bool isSender;
  Message({required this.content, this.isSender = true});

  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      isSender: json['isSender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isSender': isSender,
      
    };
  }
}
