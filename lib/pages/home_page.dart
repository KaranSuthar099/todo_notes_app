import 'package:flutter/material.dart';
import 'package:todo_notes_app/components/note_tile_widget.dart';
import 'package:todo_notes_app/database/note_database.dart';
import 'package:todo_notes_app/models/note.dart';
import 'package:todo_notes_app/pages/note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> noteList = [];

  // function to get all the data form the database into a list of notes type
  void refreshNoteList() async {
    noteList = await NoteDatabase.instance.getAll();
    setState(() {});
  }

  Future<void> navigateToNotePage(BuildContext context) async {
    bool? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NotePage(),
      ),
    );
    if (result != null && result == true) {
      refreshScreen();
    }
  }

  void refreshScreen() {
    refreshNoteList();
  }

  @override
  void initState() {
    super.initState();
    noteList = [];
    refreshNoteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notes App",
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      floatingActionButton: (noteList.isNotEmpty)
          ? FloatingActionButton(
              child: const Icon(Icons.add_rounded),
              onPressed: () => navigateToNotePage(context),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: noteList.isEmpty
            ? Center(
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  color: Theme.of(context).cardColor,
                  child: InkWell(
                    onTap: () => navigateToNotePage(context),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_add_rounded,
                            size: 150,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Add More Notes to See",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: noteList.length,
                itemBuilder: (context, index) {
                  return NoteTileWidget(
                    note: noteList[index],
                    refresh: refreshScreen,
                  );
                },
              ),
      ),
    );
  }
}
