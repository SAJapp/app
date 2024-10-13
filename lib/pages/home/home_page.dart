import 'package:campus_cart/main.dart';
import 'package:campus_cart/pages/chat/chat_list.dart';
import 'package:campus_cart/pages/chat/chat_page.dart';
import 'package:campus_cart/pages/home/profile.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Future to hold the data fetching operation
  Future<List<Map<String, dynamic>>> fetchItems() async {
    final response = await Supabase.instance.client
        .from('posts') // Replace with your actual table name
        .select();

    if (response.isEmpty) {
      return [];
    }

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Campus Cart',
              style: TextStyle(
                  fontSize: 22, color: Theme.of(context).primaryColor),
            ),
            Spacer(),
            IconButton(
              icon: Icon(LucideIcons.messageCircle,
                  color: Theme.of(context).iconTheme.color),
              onPressed: () {
                // Navigate to the chat page

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatListPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(LucideIcons.user,
                  color: Theme.of(context).iconTheme.color),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 16),
            _buildTags(),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchItems(), // Use the fetchItems method
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While the future is loading, show a loading indicator
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // If there was an error fetching the data, show an error message
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Show empty icon if no items
                    return Center(
                      child: Icon(
                        LucideIcons.trash,
                        size: 64,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    );
                  }

                  // If the future completed successfully, display the items
                  final items = snapshot.data!;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildItemCard(item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(LucideIcons.search,
                color: Theme.of(context).iconTheme.color),
          ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for items',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list,
                color: Theme.of(context).iconTheme.color),
            onPressed: () {
              // TODO: Add filter functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTag('All'),
        SizedBox(width: 8),
        _buildTag('Textbooks'),
        SizedBox(width: 8),
        _buildTag('Clothes'),
      ],
    );
  }

  Widget _buildTag(String label) {
    return GestureDetector(
      onTap: () {
        // TODO: Add tag filtering functionality
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: Theme.of(context).primaryTextTheme.bodyMedium?.color),
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      item['pictures'] != null && item['pictures'].length != 0
                          ? SizedBox(
                              height: 250.0, // Adjust height if needed
                              child: CarouselView(
                                itemExtent:
                                    MediaQuery.of(context).size.width * 0.7,
                                children: item['pictures'].map<Widget>((url) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 10),
                      Text(
                        item['title'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        item['description'] ?? 'No description',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '\$${item['price']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  image: DecorationImage(
                    image:
                        item['pictures'] != null && item['pictures'].isNotEmpty
                            ? NetworkImage(item['pictures'][0])
                            : NetworkImage('https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item['title'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Price: \$${item['price']}',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text('${item['condition']}',
                      style: TextStyle(
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color)),
                ],
              ),
            ),
            // for each category in the item, display a badge

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                children: List.generate(item['category'].length, (index) {
                  return _buildTag(item['category'][index]);
                }),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    // add post to saved_posts array in user's document

                    await supabase.client.from('bookmarks').upsert([
                      {
                        'owner': supabase.client.auth.currentUser!.id,
                        'post_id': item['id'],
                      }
                    ]);
                  },
                  child: Text('Save'),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    // add myself and the owner to the chat

                    // create a new chat
                    final chat = await supabase.client.from('chats').insert({
                      'participants': [
                        supabase.client.auth.currentUser!.id,
                        item['author_id']
                      ],
                      'title':
                          'Chat from ${supabase.client.auth.currentUser!.userMetadata?['display_name'] ?? supabase.client.auth.currentUser!.email}',
                    }).select();

                    // navigate to the chat screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(chatId: chat[0]['id']),
                      ),
                    );
                  },
                  child: Text('Ping', style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
