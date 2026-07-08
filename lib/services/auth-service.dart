import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'supabase-service.dart';

class AuthService {
  final SupabaseClient _client = SupabaseService.client;

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.session != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
      }
      
      return response;
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  Future<AuthResponse> signUp(String email, String password) async {
    try {
      return await _client.auth.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Erro ao cadastrar: $e');
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
  }

  User? get currentUser => _client.auth.currentUser;
}