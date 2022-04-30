import 'package:flutter/material.dart';
import 'package:notes_app_supabase/Service/Services.dart';
import 'package:notes_app_supabase/screen/notes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signIn() async {
    final success = await Services.of(context)
        .authService
        .singIn(_emailController.text.trim(), _passwordController.text.trim());

    if (success) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NotesPage()),
      );
    }
  }

  void _signUp() async {
    final success = await Services.of(context)
        .authService
        .singUp(_emailController.text.trim(), _passwordController.text.trim());

    if (success) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const NotesPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                decoration: const InputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                decoration: const InputDecoration(hintText: 'Password'),
                keyboardType: TextInputType.emailAddress,
                controller: _passwordController,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _signIn,
              icon: const Icon(Icons.login),
              label: const Text('Sign In'),
            ),
            ElevatedButton.icon(
              onPressed: _signUp,
              icon: const Icon(Icons.app_registration),
              label: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
