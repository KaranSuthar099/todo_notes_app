import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_notes_app/models/note.dart';

class NoteDatabase {
  // we have to make a singelton class here
  static final NoteDatabase instance = NoteDatabase._internal();
  NoteDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String databasePath = join(await getDatabasesPath(), "notes_database.db");

    Database database = await openDatabase(
      databasePath,
      version: 2,
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE NOTES (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, CONTENT TEXT)");
      },
    );

    return database;
  }

  Future<void> insertData(String title, String content) async {
    final db = await database;

    db.insert(
      "NOTES",
      {"TITLE": title, "CONTENT": content},
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<List<Note>> getAll() async {
    final db = await database;
    List<Map<String, dynamic>> data = await db.query("NOTES");
    print(data);
    List<Note> noteList = [];
    for (Map<String, dynamic> map in data) {
      noteList.add(
        Note(
          title: map["TITLE"],
          content: map["CONTENT"],
          id: map["ID"],
        ),
      );
    }

    return noteList;
  }

  void delete(int index) async {
    final db = await database;
    db.delete("NOTES", where: "id = ?", whereArgs: [index]);
    print("data deleted");
  }

  void updateData(Note note, String title, String content) async {
    final db = await database;
    db.update("NOTES", {"TITLE": title, "CONTENT": content},
        where: "id = ?", whereArgs: [note.id]);

    print("data updated");
  }
}
