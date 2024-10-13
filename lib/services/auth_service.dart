import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStateData {
  final User? user;

  AuthStateData({this.user});
}

class AuthService extends StateNotifier<AuthStateData> {
  AuthService(AuthStateData state) : super(state);

  get isAuthenticated => state.user != null;

  get user => state.user;

  init() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      state = AuthStateData(user: user);
    }
  }

  void setUser(User? user) {
    state = AuthStateData(user: user);
  }

  Future<void> login(String email, String password) async {
    final response = await Supabase.instance.client.auth
        .signInWithPassword(email: email, password: password);

    if (response.user != null) {
      state = AuthStateData(user: response.user);
    }
  }

  Future<void> register(
    String email,
    String password,
    String? displayName,
  ) async {
    final response = await Supabase.instance.client.auth
        .signUp(email: email, password: password);

    // add the display name to the user profile
    if (response.user != null) {
      await Supabase.instance.client.from('users').upsert({
        'id': response.user!.id,
        'display_name': displayName,
      });

      // add display name to internal user profile

      await Supabase.instance.client.auth
          .updateUser(UserAttributes(data: {'display_name': displayName}));

      state = AuthStateData(user: response.user);

      await Supabase.instance.client.auth
          .updateUser(UserAttributes(data: {'display_name': displayName}));
    }
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
