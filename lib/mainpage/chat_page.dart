import 'package:flutter/material.dart';
import 'package:match_for_u/mainpage/chat_detail.dart';
import 'package:match_for_u/models/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> messages = [
    ChatMessage(
        sender: "Nasikabu ja",
        message: "Hii👋",
        time: "23 min",
        imageUrl: "https://via.placeholder.com/150",
        isOnline: true),
    ChatMessage(
        sender: "Nasikabu ja",
        message: "morning",
        time: "27 min",
        imageUrl: "https://via.placeholder.com/150",
        isOnline: false),
    ChatMessage(
        sender: "Nasikabu ja",
        message: "Shall we go on a date 😜",
        time: "33 min",
        imageUrl: "https://via.placeholder.com/150",
        isOnline: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages"), centerTitle: true),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ChatTile(
            chatMessage: messages[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    chatUser: ChatUser(
                      name: messages[index].sender,
                      imageUrl: messages[index].imageUrl,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final ChatMessage chatMessage;
  final VoidCallback onTap;

  const ChatTile({super.key, required this.chatMessage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(chatMessage.imageUrl)),
            if (chatMessage.isOnline)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2))),
              ),
          ],
        ),
        title: Text(chatMessage.sender,
            style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(chatMessage.message),
        trailing: Text(chatMessage.time,
            style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
