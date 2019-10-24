import 'package:calpin/Utils.dart' as utils;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'TasksModel.dart';

class TaskDBWorker {
  TaskDBWorker._();

  static final TaskDBWorker db = TaskDBWorker._();

  Database _db;

  //Rien de compliqué ici, plutot évident non ?
  Future get database async {
    if (_db == null) {
      _db = await initializeDatabase();
    }
    return _db;
  }

  Future<Database> initializeDatabase() async {
    String path = join(utils.docsDir.path, "tasks.db");

    //Création de la table et insertion de données.
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS tasks ("
          "id INTEGER PRIMARY KEY,"
          "description TEXT,"
          "dueDate TEXT,"
          "completed TEXT"
          ")");
    });

    return db;
  }

  Task noteFromMap(Map inMap) {
    Task note = Task();

    note.id = inMap["id"];
    note.description = inMap["description"];
    note.dueDate = inMap["dueDate"];
    note.completed = inMap["completed"];

    return note;
  }

  Map<String, dynamic> noteToMap(Task inTask) {
    Map<String, dynamic> map = Map<String, dynamic>();

    map["id"] = inTask.id;
    map["description"] = inTask.description;
    map["dueDate"] = inTask.dueDate;
    map["completed"] = inTask.completed;

    return map;
  }

  //Sauvegarde de la note
  Future createTask(Task inTask) async {
    Database db = await database;
    var val = await db.rawQuery("SELECT MAX(id)+1 as id FROM tasks");
    int id = val.first["id"];

    if (id == null) {
      id = 1;
    }

    return db.rawInsert(
        "INSERT INTO tasks (id,description,dueDate,completed)"
        " VALUES(?,?,?,?)",
        [id, inTask.description, inTask.dueDate, inTask.completed]);
  }

  Future<Task> getTask(int inID) async {
    Database db = await database;
    var rec = await db.query("tasks", where: "id = ?", whereArgs: [inID]);

    return noteFromMap(rec.first);
  }

  //Récupération de toutes les données de la table
  Future<List> getAll() async {
    Database db = await database;
    var recs = await db.query("tasks");
    var list = recs.isNotEmpty ? recs.map((m) => noteFromMap(m)).toList() : [];

    return list;
  }

  Future updateTask(Task inTask) async {
    Database db = await database;
    return await db.update("tasks", noteToMap(inTask),
        where: "id = ?", whereArgs: [inTask.id]);
  }

  Future deleteTask(int inID) async {
    Database db = await database;
    return await db.delete("tasks", where: "id = ?", whereArgs: [inID]);
  }
//Fin
}
