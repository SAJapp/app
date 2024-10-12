import 'package:campus_thrift/pages/accounts/registration.dart';
import 'package:campus_thrift/pages/pages.dart';
import 'package:campus_thrift/pages/rail.dart';
import 'package:campus_thrift/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthHandler extends ConsumerStatefulWidget {
  AuthHandler({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthHandler> createState() => _AuthHandlerState();
}

class _AuthHandlerState extends ConsumerState<AuthHandler> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(Duration(seconds: 2));
    // Replace the following line with your actual authentication check using Supabase
    bool isAuthenticated =
        await ref.read(authServiceProvider.notifier).isAuthenticated;

    if (isAuthenticated) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RailPage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RegistrationPage()));
    }
  }

  @override
  Widget build(context) {
    return const Scaffold(
      body: Center(
        child: Text('Checking authentication status'),
      ),
    );
  }
}
