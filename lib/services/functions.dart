import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> _getDisplayName() async {
  final response = await Supabase.instance.client
      .from('users')
      .select()
      .eq('id', Supabase.instance.client.auth.currentUser!.id)
      .select();

  if (response.isEmpty) {
    return null;
  } else {
    return response.first['display_name'];
  }
}
