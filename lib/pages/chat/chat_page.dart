import 'dart:convert';

import 'package:campus_cart/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatefulWidget {
  final int chatId;
  ChatPage({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _limit = 20;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMoreMessages();
    }
  }

  void _loadMoreMessages() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _limit += 20;
      });
    }
  }

  Stream<List<Map<String, dynamic>>> _getMessagesStream() {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    return Supabase.instance.client
        .from('chats')
        .stream(primaryKey: ['id'])
        .eq('id', widget.chatId)
        .map((event) {
          final chatData =
              event.firstWhere((row) => row['id'] == widget.chatId);
          final messages =
              List<Map<String, dynamic>>.from(chatData['messages'] ?? []);
          messages.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
          return messages.take(_limit).toList();
        });
  }

  Future<void> sendMessage(String message) async {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    // Fetch existing messages for the chat
    final response = await Supabase.instance.client
        .from('chats')
        .select('messages')
        .eq('id', widget.chatId)
        .single();

    if (response.isEmpty) {
      // Handle error fetching existing messages
      print('Error fetching messages:');
      return;
    }

    // Retrieve existing messages or create an empty list if none exist
    List<dynamic> existingMessages = response['messages'] ?? [];

    // Create the new message data
    final messageData = {
      'sendId': userId,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Add the new message to the existing list
    existingMessages.add(messageData);

    // Update the messages in the database
    final updateResponse = await Supabase.instance.client
        .from('chats')
        .update({'messages': existingMessages}).eq('id', widget.chatId);

    if (updateResponse == null) {
      // Handle error updating the messages
      print('Error updating messages: ${updateResponse}');
    } else {
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox();
                    }
                    final msg = messages[index];
                    final isSent = msg['sendId'] ==
                        Supabase.instance.client.auth.currentUser!.id;

                    return Align(
                      alignment:
                          isSent ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSent ? Colors.blue[200] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(msg['message']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      sendMessage(_messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
