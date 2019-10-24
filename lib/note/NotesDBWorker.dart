import 'package:calpin/Utils.dart' as utils;
import 'package:calpin/note/NotesModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteDBWorker {
  NoteDBWorker._();

  static final NoteDBWorker db = NoteDBWorker._();

  Database _db;

  //Rien de compliqué ici, plutot évident non ?
  Future get database async {
    if (_db == null) {
      _db = await initializeDatabase();
    }
    return _db;
  }

  Future<Database> initializeDatabase() async {
    String path = join(utils.docsDir.path, "notes.db");

    //Création de la table et insertion de données.
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS notes ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "content TEXT,"
          "color TEXT"
          ")");
    });

    return db;
  }

  Note noteFromMap(Map inMap) {
    Note note = Note();

    note.id = inMap["id"];
    note.title = inMap["title"];
    note.content = inMap["content"];
    note.color = inMap["color"];

    return note;
  }

  Map<String, dynamic> noteToMap(Note inNote) {
    Map<String, dynamic> map = Map<String, dynamic>();

    map["id"] = inNote.id;
    map["title"] = inNote.title;
    map["content"] = inNote.content;
    map["color"] = inNote.color;

    return map;
  }

  //Sauvegarde de la note
  Future createNote(Note inNote) async {
    Database db = await database;
    var val = await db.rawQuery("SELECT MAX(id)+1 as id FROM notes");
    int id = val.first["id"];

    if (id == null) {
      id = 1;
    }

    return db.rawInsert(
        "INSERT INTO notes (id,title,content,color)"
        " VALUES(?,?,?,?)",
        [id, inNote.title, inNote.content, inNote.color]);
  }

  Future<Note> getNote(int inID) async {
    Database db = await database;
    var rec = await db.query("notes", where: "id = ?", whereArgs: [inID]);

    return noteFromMap(rec.first);
  }

  //Récupération de toutes les données de la table
  Future<List> getAll() async {
    Database db = await database;
    var recs = await db.query("notes");
    var list = recs.isNotEmpty ? recs.map((m) => noteFromMap(m)).toList() : [];

    return list;
  }

  Future updateNote(Note inNote) async {
    Database db = await database;
    return await db.update("notes", noteToMap(inNote),
        where: "id = ?", whereArgs: [inNote.id]);
  }

  Future deleteNote(int inID) async {
    Database db = await database;
    return await db.delete("notes", where: "id = ?", whereArgs: [inID]);
  }
//Fin
}
