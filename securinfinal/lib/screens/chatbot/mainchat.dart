import 'package:flutter/material.dart';
import 'message.dart';
import 'chatservice.dart';

class GeminiChatScreen extends StatefulWidget {
  const GeminiChatScreen({Key? key}) : super(key: key);

  @override
  _GeminiChatScreenState createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  // The service now manages its own API key
  late final GeminiChatService _chatService;

  @override
  void initState() {
    super.initState();
    _chatService = GeminiChatService();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();

    setState(() {
      _messages.add(Message(
        text: text,
        isUserMessage: true,
      ));
      _isLoading = true;
    });

    _getResponseFromGemini(text);
  }

  Future<void> _getResponseFromGemini(String message) async {
    try {
      final response = await _chatService.sendMessage(message);

      setState(() {
        _messages.add(Message(
          text: response,
          isUserMessage: false,
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(
          text: "Error: $e",
          isUserMessage: false,
        ));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LawyerUP Chatbot"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildWelcomeMessage()
                : _buildChatList(),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            "Welcome to LawyerUP chat",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Start a conversation with LawyerUP regarding knowledge about the laws you need to know...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      reverse: true,
      itemCount: _messages.length,
      itemBuilder: (_, int index) {
        return _buildMessageItem(_messages[_messages.length - index - 1]);
      },
    );
  }

  Widget _buildMessageItem(Message message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: message.isUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUserMessage)
            _buildAvatar(isUser: false),

          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: message.isUserMessage ? 60.0 : 8.0,
                right: message.isUserMessage ? 8.0 : 60.0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: message.isUserMessage
                    ? Theme.of(context).primaryColor.withOpacity(0.8)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.isUserMessage ? "You" : "LawyerUP AI",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: message.isUserMessage ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUserMessage ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (message.isUserMessage)
            _buildAvatar(isUser: true),
        ],
      ),
    );
  }

  Widget _buildAvatar({required bool isUser}) {
    return CircleAvatar(
      backgroundColor: isUser ? Colors.blue[700] : Colors.green[600],
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        color: Colors.grey,
        size: 20,
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              minLines: 1,
              maxLines: 5,
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: () => _handleSubmitted(_textController.text),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 2,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}