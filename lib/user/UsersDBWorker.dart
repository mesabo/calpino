import 'package:calpin/Utils.dart' as utils;
import 'package:calpin/user/UsersModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDBWorker {
  UserDBWorker._();

  static final UserDBWorker db = UserDBWorker._();

  Database _db;

  //Rien de compliqué ici, plutot évident non ?
  Future get database async {
    if (_db == null) {
      _db = await initializeDatabase();
    }
    return _db;
  }

  Future<Database> initializeDatabase() async {
    String path = join(utils.docsDir.path, "users.db");

    //Création de la table et insertion de données.
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS users ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "email TEXT,"
          "phone TEXT"
          ")");
    });

    return db;
  }

  User userFromMap(Map inMap) {
    User user = User();

    user.id = inMap["id"];
    user.name = inMap["name"];
    user.email = inMap["email"];
    user.phone = inMap["phone"];

    return user;
  }

  Map<String, dynamic> userToMap(User inUser) {
    Map<String, dynamic> map = Map<String, dynamic>();

    map["id"] = inUser.id;
    map["name"] = inUser.name;
    map["email"] = inUser.email;
    map["phone"] = inUser.phone;

    return map;
  }

  //Sauvegarde de la user
  Future createUser(User inUser) async {
    Database db = await database;
    var val = await db.rawQuery("SELECT MAX(id)+1 as id FROM users");
    int id = val.first["id"];

    if (id == null) {
      id = 1;
    }

    return db.rawInsert(
        "INSERT INTO users (id,name,email,phone)"
        " VALUES(?,?,?,?)",
        [id, inUser.name, inUser.email, inUser.phone]);
  }

  Future<User> getUser(int inID) async {
    Database db = await database;
    var rec = await db.query("users", where: "id = ?", whereArgs: [inID]);

    return userFromMap(rec.first);
  }

  //Récupération de toutes les données de la table
  Future<List> getAll() async {
    Database db = await database;
    var recs = await db.query("users");
    var list = recs.isNotEmpty ? recs.map((m) => userFromMap(m)).toList() : [];

    return list;
  }

  Future updateUser(User inUser) async {
    Database db = await database;
    return await db.update("users", userToMap(inUser),
        where: "id = ?", whereArgs: [inUser.id]);
  }

  Future deleteUser(int inID) async {
    Database db = await database;
    return await db.delete("users", where: "id = ?", whereArgs: [inID]);
  }
//Fin
}
