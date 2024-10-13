import 'package:campus_cart/pages/landing/landing.dart';
import 'package:campus_cart/pages/rail.dart';
import 'package:campus_cart/services/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Supabase supabase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Check onboarding status
  final prefs = await SharedPreferences.getInstance();
  bool isOnboarded = prefs.getBool('onboarded') ?? false;

  supabase = Supabase.instance;
  runApp(ProviderScope(child: App(isOnboarded: isOnboarded)));
}

class App extends StatelessWidget {
  final bool isOnboarded;

  App({Key? key, required this.isOnboarded}) : super(key: key);

  @override
  Widget build(context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: isOnboarded ? AuthHandler() : LandingPage(),
      ),
    );
  }
}
