import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_supabase/Service/Services.dart';
import 'package:notes_app_supabase/screen/home_page.dart';

import '../model/note.dart';
import 'note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Future<void> _signOut(BuildContext context) async {
    final success = await Services.of(context).authService.signOut();

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('There was an issue logging out'),
      ));
    }
  }

  Future<void> _addNote() async {
    final note = await Navigator.push<Note?>(
      context,
      MaterialPageRoute(builder: (context)=>const  NotePage()),
    );
    if (note != null){
      setState(() {

      });
    }
  }

  Future<void> _editNote(Note note) async {
    final updateNote = await Navigator.push<Note?>(
      context,
      MaterialPageRoute(builder: (context) => NotePage(note : note)),
    );
    if(updateNote != null){
      setState(() {
        
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supanotes'),
        actions: [_logOutButton(context)],
      ),
      body: ListView(
        children: [
          FutureBuilder(
            future: Services.of(context).notesService.getNotesByUserId(),
            builder: (context, snapshot) {
              final notes = (snapshot.data as List<Note>  )
                ..sort((x, y) =>
                    y.modifyTime.difference(x.modifyTime).inMilliseconds);
              return Column(
                children: notes.map(_toNoteWidget).toList(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        label: const Text('Add note'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _toNoteWidget(Note note) {
    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_)=> Services.of(context).notesService.deleteNote(note.id),
      background: Container(
          color: Colors.red,
        child: const Icon(Icons.delete),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 2, color: Colors.green)),
        child: ListTile(
          title: Text(note.title),
          subtitle: Text(note.content ?? ''),
          onTap: () => _editNote(note),
        ),
      ),
    );
  }

  Widget _logOutButton(BuildContext context) {
    return IconButton(
      onPressed: () => _signOut(context),
      icon: const Icon(Icons.logout),
    );
  }
}
