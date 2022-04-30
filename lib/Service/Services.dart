
import 'package:flutter/cupertino.dart';
import 'package:notes_app_supabase/Service/notes_service.dart';
import 'package:notes_app_supabase/Service/secret.dart';
import 'package:supabase/supabase.dart';

import 'auth_service.dart';

class Services extends InheritedWidget {
  final AuthService authService;
  final NotesService notesService;

  const Services._({required this.authService,required this.notesService ,required Widget child})
      : super(child: child);
  
  factory Services({required Widget child}){
    final client = SupabaseClient(supabaseUrl, supabaseKey);
    final authService = AuthService(client.auth);
    final noteService = NotesService(client);
    return Services._(authService: authService,notesService: noteService ,child: child);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }
  static Services of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Services>()!;
  }

}


