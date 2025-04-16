class ChatMessage {
  final String receiver;
  final String message;
  final String time;
  final String imageUrl;
  final bool isOnline;

  ChatMessage({
    required this.receiver,
    required this.message,
    required this.time,
    required this.imageUrl,
    required this.isOnline,
  });
}

class ChatUser {
  final String name;
  final String imageUrl;
  final String? id;
  final bool isOnline;

  ChatUser({
    required this.name,
    required this.imageUrl,
    this.id,
    this.isOnline = false,
  });
}

class Message {
  final String text;
  final String time;
  final bool isSentByMe;

  Message({
    required this.text,
    required this.time,
    required this.isSentByMe,
  });
}
