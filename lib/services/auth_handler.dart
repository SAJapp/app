import 'package:campus_thrift/pages/accounts/registration.dart';
import 'package:campus_thrift/pages/rail.dart';
import 'package:campus_thrift/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthHandler extends ConsumerStatefulWidget {
  AuthHandler({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthHandler> createState() => _AuthHandlerState();
}

class _AuthHandlerState extends ConsumerState<AuthHandler> {
  @override
  void initState() {
    super.initState();
  }

  Future<User?> getUser() async {
    final user = await Supabase.instance.client.auth.currentUser;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.data == null) {
            return RegistrationPage();
          }

          return RailPage();
        },
      ),
    );
  }
}
