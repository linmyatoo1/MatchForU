import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:match_for_u/mainpage/chat_detail.dart';
import 'package:match_for_u/models/chat_message.dart' as model;
import 'package:match_for_u/models/token.dart';
import 'package:match_for_u/constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<model.ChatMessage> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMatchedUsers();
  }

  Future<void> fetchMatchedUsers() async {
    final url = Uri.parse('$baseUrl/users/match');

    final token = await StorageService.getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List matches = data['matchUsersProfile'] ?? [];
        print(matches);
        print(data);

        final List<model.ChatMessage> loadedMessages = matches.map((item) {
          return model.ChatMessage(
            receiver: item['name'],
            message: "Say hi 👋",
            time: "Just now",
            imageUrl: item['photo'],
            isOnline: false,
          );
        }).toList();
        print(loadedMessages);
        setState(() {
          messages = loadedMessages;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages"), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatTile(
                  chatMessage: messages[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          chatUser: model.ChatUser(
                            name: messages[index].receiver,
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
  final model.ChatMessage chatMessage;
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
              backgroundImage: NetworkImage(chatMessage.imageUrl),
            ),
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
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(chatMessage.receiver,
            style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(chatMessage.message),
        trailing: Text(chatMessage.time,
            style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
