import 'package:campus_cart/services/auth_handler.dart';
import 'package:campus_cart/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  "",
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
                // Implement edit profile functionality
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
                      UserAttributes(data: {'display_name': newDisplayName}));
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
