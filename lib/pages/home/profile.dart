import 'package:campus_cart/services/auth_handler.dart';
import 'package:campus_cart/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authServiceProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Picture Section
            Center(
              child: GestureDetector(
                onTap: () async {
                  await _chooseImage(context, user?.id);
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    user?.userMetadata?['profile_picture'] ?? "",
                  ),
                  child: user?.userMetadata?['profile_picture'] == null
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),

            // User Info Cards
            Card(
              elevation: 4,
              child: ListTile(
                title: Text('Email'),
                subtitle: Text(user?.email ?? 'No email'),
              ),
            ),
            SizedBox(height: 10),

            FutureBuilder<String?>(
              future: _getDisplayName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text('Display Name'),
                      subtitle: Center(child: CircularProgressIndicator()),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text('Display Name'),
                      subtitle: Text('Error: ${snapshot.error}'),
                    ),
                  );
                } else {
                  final displayName = snapshot.data ?? 'No display name set';
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text('Display Name'),
                      subtitle: Text(displayName),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                _showEditProfileDialog(context);
              },
              child: Text('Edit Profile'),
            ),
            SizedBox(height: 10),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                ref.read(authServiceProvider.notifier).logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out successfully')),
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AuthHandler()),
                  (route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _chooseImage(BuildContext context, String? userId) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Upload the image to Supabase Storage
      final imageUrl = await _uploadImage(image);
      if (imageUrl != null && userId != null) {
        // Update user metadata with the new profile picture URL
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(data: {'profile_picture': imageUrl}),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated!')),
        );
      }
    }
  }

  Future<String?> _uploadImage(XFile image) async {
    final fileBytes = File(image
        .path); // convert the image to bytes before uploading to Supabase Storage
    final response =
        await Supabase.instance.client.storage.from('profile_pictures').upload(
              'profile_pics/${image.name}',
              fileBytes,
              fileOptions: FileOptions(
                  contentType: 'image/png'), // adjust based on image type
            );

    print(response);
    // if (response.isEmpty) {
    //   // Get the public URL of the uploaded image
    //   final url = await Supabase.instance.client.storage
    //       .from('profile_pictures')
    //       .getPublicUrl(response.data!);
    //   return url;
    // } else {
    //   print('Error uploading image: ${response.error!.message}');
    //   return null;
    // }
  }

  // Function to fetch display name from Supabase
  Future<String?> _getDisplayName() async {
    final userInformation = await Supabase.instance.client.auth.getUser();
    var displayName = userInformation.user!.userMetadata?['display_name'];

    return displayName;
  }

  // Function to show edit profile dialog
  void _showEditProfileDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Enter new display name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newDisplayName = _controller.text;
                if (newDisplayName.isNotEmpty) {
                  await Supabase.instance.client.auth.updateUser(
                    UserAttributes(data: {'display_name': newDisplayName}),
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Display name updated!')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
