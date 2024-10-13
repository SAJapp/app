import 'package:campus_cart/main.dart';
import 'package:campus_cart/pages/chat/chat_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Bookmarks extends StatefulWidget {
  Bookmarks({Key? key}) : super(key: key);

  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  Future<List<Map<String, dynamic>>> fetchBookmarks() async {
    final response = await Supabase.instance.client
        .from('bookmarks')
        .select('post_id')
        .eq('owner', Supabase.instance.client.auth.currentUser!.id);

    if (response.isEmpty) {
      return [];
    }

    final bookmarksData = response;

    final postDetails = await fetchPostDetails(bookmarksData);

    return postDetails;
  }

  Future<List<Map<String, dynamic>>> fetchPostDetails(
      List<dynamic> bookmarksData) async {
    final postIds =
        bookmarksData.map((bookmark) => bookmark['post_id']).toList();

    final response = await Supabase.instance.client
        .from('posts')
        .select()
        .filter('id', 'in', postIds)
        .select();

    return response;
  }

  Future<void> removeBookmark(String postId) async {
    await Supabase.instance.client
        .from('bookmarks')
        .delete()
        .filter('post_id', 'eq', postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Icon(
                LucideIcons.trash,
                size: 64,
                color: Theme.of(context).iconTheme.color,
              ),
            );
          } else {
            final bookmarks = snapshot.data!;
            return ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                final description = bookmark['description'];
                final categories =
                    bookmark['category'] ?? []; // List of categories

                return Card(
                  margin: EdgeInsets.all(12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Carousel slider for images
                        bookmark['pictures'] != null &&
                                bookmark['pictures'].isNotEmpty
                            ? CarouselSlider(
                                options: CarouselOptions(
                                  height: 200,
                                  aspectRatio: 16 / 9,
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll: false,
                                  viewportFraction: 0.8,
                                ),
                                items: bookmark['pictures']
                                    .map<Widget>((imageUrl) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  );
                                }).toList(),
                              )
                            : SizedBox(
                                height: 200,
                                child: Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        SizedBox(height: 10),

                        // Title and Price
                        Text(
                          bookmark['title'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('Price: \$${bookmark['price']}',
                            style: TextStyle(fontSize: 16)),

                        // Description
                        if (description != null && description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              description,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),

                        // Categories
                        if (categories.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: categories.map<Widget>((category) {
                                return Chip(
                                  label: Text(category),
                                  backgroundColor: Colors.blue[100],
                                );
                              }).toList(),
                            ),
                          ),

                        // Remove button
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              setState(() {
                                removeBookmark(bookmark['id']);
                                bookmarks.removeAt(index);
                              });
                            },
                          ),
                        ),
                        // ping button
                        TextButton(
                          onPressed: () async {
                            // add myself and the owner to the chat

                            // create a new chat
                            final chat =
                                await supabase.client.from('chats').insert({
                              'participants': [
                                supabase.client.auth.currentUser!.id,
                                bookmark['author_id']
                              ],
                              'title':
                                  'Chat from ${supabase.client.auth.currentUser!.userMetadata?['display_name'] ?? supabase.client.auth.currentUser!.email}',
                            });

                            // navigate to the chat screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatPage(chatId: chat['id']),
                              ),
                            );
                          },
                          child: Text('Ping',
                              style: TextStyle(color: Colors.white)),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
