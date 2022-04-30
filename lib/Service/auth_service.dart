import 'dart:developer';

import 'package:supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  final GoTrueClient _client;

  AuthService(this._client);

  static const supabaseSessionKey = 'supabase_session';

  Future<bool> singUp(String email, String password) async {
    final response = await _client.signUp(email, password);
    if(response.error==null){
      log('Sing up was successful for user ID : ${response.user!.id}');
      _persistSession(response.data!);
      return true;
    }
    log('Sign up error: ${response.error!.message}');
    return false;
  }


  Future<bool> singIn(String email , String password) async {

    final response = await _client.signIn(email:email ,password:password );
    if(response.error==null){
      log('Sign in was successful for user ID : ${response.user!.id}');
      _persistSession(response.data!);
      return true;
    }
    log('Sign in error : ${response.error!.message}');
    return false;
  }

  Future<bool> signOut() async {

    final response = await _client.signOut();
    if(response.error==null){
      return true;
    }
    log('Sign out error : ${response.error!.message}');
    return false;
  }

  Future<void> _persistSession(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    log('Persisting session string');
    await prefs.setString(supabaseSessionKey, session.persistSessionString);
  }

  Future<bool> recoverSession() async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.containsKey(supabaseSessionKey)){
      log('Found persisted session string, attempting to recover session');
      final jsonString = prefs.getString(supabaseSessionKey)!;
      final response = await _client.recoverSession(jsonString);

      if (response.error==null){
        log('Session successfully recoverd for user ID: ${response.user!.id}');
        _persistSession(response.data!);
        return true;
      }
    }
    return false;
  }

}
