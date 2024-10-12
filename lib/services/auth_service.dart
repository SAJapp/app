import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStateData {
  final User? user;

  AuthStateData({this.user});
}

class AuthService extends StateNotifier<AuthStateData> {
  AuthService(AuthStateData state) : super(state);

  get isAuthenticated => state.user != null;

  void setUser(User? user) {
    state = AuthStateData(user: user);
  }

  void login(String email, String password) async {
    final response = await Supabase.instance.client.auth
        .signInWithPassword(email: email, password: password);
  }

  void register(String email, String password) async {
    final response = await Supabase.instance.client.auth
        .signUp(email: email, password: password);
  }

  void logout() {
    state = AuthStateData(user: null);
    Supabase.instance.client.auth.signOut();
  }
}

final authServiceProvider =
    StateNotifierProvider<AuthService, AuthStateData>((ref) {
  return AuthService(AuthStateData());
});
