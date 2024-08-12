import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:todo_notes_app/database/note_database.dart';
import 'package:todo_notes_app/models/note.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key, this.note});

  final Note? note;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerContent = TextEditingController();
  final QuillController quillController = QuillController.basic();

  Future<void> saveToDatabase(BuildContext context) async {
    String title = controllerTitle.value.text;
    String content = controllerContent.value.text;

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: Duration(milliseconds: 1000),
          content: Center(
            child: Card(
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Title or Content can't be empty",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900)),
              ),
            ),
          ),
        ),
      );
      return;
    }

    if (widget.note == null) {
      NoteDatabase.instance.insertData(title, content);
    } else {
      NoteDatabase.instance.updateData(widget.note!, title, content);
    }
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      controllerTitle.text = widget.note!.title;
      controllerContent.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerContent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null ? "Create Note" : "Edit Note",
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton.filledTonal(
              onPressed: () => saveToDatabase(context),
              icon: const Icon(Icons.save_rounded)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controllerTitle,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: "Title Here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLines: null,
                  controller: controllerContent,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Text Can't be Empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Text Here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
