import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String _supabaseUrl = 'https://tvvqxjlttzrtualkktfi.supabase.co';
  static const String _supabaseAnonKey = 'sb_publishable_-t0JPdVovGEaUK8HClYsug_8cEA_HrZ';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  static final SupabaseClient client = Supabase.instance.client;
}