import 'package:campus_thrift/pages/landing/landing.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://xfgryarmntclonzbyllo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhmZ3J5YXJtbnRjbG9uemJ5bGxvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg3NTg1MjksImV4cCI6MjA0NDMzNDUyOX0.EPjoh6zDazbjyFsmoHsnL6rQYzveFDqaA_pYPPR9e5s',
  );

  runApp(ProviderScope(child: App()));
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LandingPage(),
      ),
    );
  }
}
