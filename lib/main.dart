import 'package:flutter/material.dart';
import 'package:notes_app_supabase/Service/Services.dart';
import 'package:notes_app_supabase/screen/home_page.dart';
import 'package:notes_app_supabase/screen/notes_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Services(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: FlexThemeData.dark(
          scheme: FlexScheme.amber
        ),
        home: Builder(
          builder: (context) {
            return FutureBuilder<bool>(
            future: Services.of(context).authService.recoverSession(),
            builder: (context,snapshot){
              final sessionRecovered = snapshot.data ?? false;
              return sessionRecovered? const NotesPage() : const HomePage();
            });
          },
        ),
      ),
    );
  }
}

