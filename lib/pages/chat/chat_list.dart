import 'package:campus_cart/main.dart';
import 'package:campus_cart/pages/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchChats(), // Fetch chats when the widget builds
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the data is being fetched
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error fetching the data
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If no chats are found
            return Center(child: Text('No chats available.'));
          } else {
            // Successfully fetched chats
            final chats = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final chatId = chat['id'];
                  final participants = List<String>.from(chat['participants']);

                  final chatWithText = participants.length == 1
                      ? 'Chat with ${participants[0]}'
                      : 'Group chat';
                  // Display a chat item
                  return ListTile(
                    title: Text(chatWithText),
                    subtitle: Text('Participants: ${participants.join(", ")}'),
                    onTap: () => navigateToChat(context, chatId),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchChats() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    // Fetch chats where the current user is a participant
    final response = await Supabase.instance.client
        .from('chats')
        .select('id, participants')
        .contains('participants', [userId]);

    if (response.isNotEmpty) {
      return response.map((chat) => chat as Map<String, dynamic>).toList();
    } else {
      return []; // Return an empty list if no chats are found
    }
  }

  void navigateToChat(BuildContext context, int chatId) {
    // Navigate to the ChatPage with the selected chatId
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(chatId: chatId),
      ),
    );
  }
}
