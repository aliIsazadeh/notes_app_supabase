import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Service/Services.dart';
import '../model/note.dart';

class NotePage extends StatefulWidget {
  final Note? note;

  const NotePage({this.note});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Future<void> _saveNote_() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (_titleController.text.trim().isEmpty) {
      _showSnackBar('Title can not be empty!');
    }
    final note =await _createOrUpdateNote(title, content );

    if(note != null){
      Navigator.pop(context,note);
    }
    else{
      _showSnackBar('something went wrong');
    }

  }

  Future<Note?>_createOrUpdateNote(String title , String content) {

    final notesService = Services.of(context).notesService;
    if(widget.note!=null){
      return notesService.updateNote(widget.note!.id, title , content);
    }
    else{
      return notesService.createNote(title , content);
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
  @override
  void initState() {
    super.initState();

    if(widget.note != null){
      _titleController.text= widget.note!.title;
      _contentController.text= widget.note!.content ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.note != null? 'Edit note' : 'New note'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'title'),
              maxLength: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
            child: TextField(
              controller: _contentController,
              decoration: const InputDecoration(hintText: 'content'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveNote_,
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

    super.dispose();
  }
}
