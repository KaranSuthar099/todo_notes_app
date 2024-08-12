import 'package:flutter/material.dart';
import 'package:todo_notes_app/database/note_database.dart';
import 'package:todo_notes_app/models/note.dart';
import 'package:todo_notes_app/pages/note_page.dart';

class NoteTileWidget extends StatelessWidget {
  const NoteTileWidget({
    super.key,
    required this.note,
    required this.refresh,
  });

  final Note note;
  final Function refresh;

  Future<void> navigateToNotePage(BuildContext context) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotePage(note: note),
      ),
    );

    if (result == true) refresh();
  }

  String subtitle() {
    return stringCharLimitFormat(40, note.content);
  }

  String title() {
    return stringCharLimitFormat(20, note.title);
  }

  String stringCharLimitFormat(int limit, String value) {
    // used /n while checking to avoid inputs like "\n \n \n \n \n \n \n \n \n \n \n "
    // as that would increase the size unnecesarily

    return value.split("/n")[0].length > limit
        ? "${value.split("\n")[0].substring(0, limit)}..."
        : value.split("\n")[0];
  }

  @override
  Widget build(BuildContext context) {
    print(note.id);
    print(note.title);
    print(note.content);

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () async {
          print("list Tile Clicked");
          navigateToNotePage(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 25),
                    ),
                    Text(subtitle()),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (value) {
                  if (value == "delete") {
                    NoteDatabase.instance.delete(note.id);
                    refresh();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: "delete",
                      child: Text("delete"),
                    )
                  ];
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
