import 'package:campus_cart/pages/accounts/registration.dart';
import 'package:campus_cart/pages/rail.dart';
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

  @override
  Widget build(BuildContext context) {
    // Get the current user from Supabase
    final user = Supabase.instance.client.auth.currentUser;

    // If no user is logged in, show the registration page
    if (user == null) {
      return Scaffold(
        body: RegistrationPage(),
      );
    }

    // If the user is logged in, show the rail page
    return Scaffold(
      body: RailPage(),
    );
  }
}
