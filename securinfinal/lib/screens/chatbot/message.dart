class Message {
  final String text;
  final bool isUserMessage;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUserMessage,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}