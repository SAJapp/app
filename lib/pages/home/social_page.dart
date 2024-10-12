import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final ScrollController _scrollController = ScrollController();
  // final supabase = Supabase.instance.client;
  List<dynamic> posts = [];
  bool isLoading = false;
  int page = 0; // For pagination
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_onScroll);
    // _loadPosts(); // Load the first batch of posts
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Function to load posts from Supabase
  // Future<void> _loadPosts() async {
  //   if (isLoading) return; // Prevent multiple API calls at once
  //   setState(() {
  //     isLoading = true;
  //   });

  //   final response = await supabase
  //       .from('posts')
  //       .select()
  //       .order('timestamp', ascending: false)
  //       .range(page * pageSize, (page + 1) * pageSize - 1) // Pagination
  //       .execute();

  //   if (response.error == null) {
  //     setState(() {
  //       posts.addAll(response.data);
  //       page++; // Increment page for next batch
  //     });
  //   } else {
  //     // Handle error
  //     print("Error: ${response.error!.message}");
  //   }

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // // Infinite scrolling detection
  // void _onScroll() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     _loadPosts();
  //   }
  // }
  //
  // dummy data

  Map<String, dynamic> post1 = {
    'id': 1,
    'username': 'John Doe',
    'content': 'Hello, World!',
    'likes': 10,
    'comments': 5,
    'timestamp': DateTime.now().toIso8601String(),
  };

  Map<String, dynamic> post2 = {
    'id': 2,
    'username': 'Jane Doe',
    'content': 'This is a test post',
    'likes': 20,
    'comments': 10,
    'timestamp': DateTime.now().toIso8601String(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPostList(),
    );
  }

  // Widget to build the ListView with posts
  Widget _buildPostList() {
    if (posts.isEmpty && isLoading) {
      return Center(
          child:
              CircularProgressIndicator()); // Loading indicator for the first batch
    }

    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: posts.length +
                  (isLoading
                      ? 1
                      : 0), // Add extra space for the loading indicator
              itemBuilder: (context, index) {
                if (index < posts.length) {
                  final post = posts[index];
                  return _buildPostItem(post);
                } else {
                  return Center(
                      child: CircularProgressIndicator()); // Loading more posts
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build each post
  Widget _buildPostItem(dynamic post) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['user_id'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(post['content']),
            SizedBox(height: 8),
            Text(
              post['timestamp'],
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
