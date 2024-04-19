import 'package:sa3/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  final String usersTable = 'users';
  final String tasksTable = 'tasks';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'sa3.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $usersTable(id INTEGER PRIMARY KEY, username TEXT UNIQUE, password TEXT)",
        );
        return db.execute(
          "CREATE TABLE $tasksTable(id INTEGER PRIMARY KEY, title TEXT, username TEXT, isCompleted INTEGER DEFAULT 0, FOREIGN KEY(username) REFERENCES $usersTable(username))",
        );
      },
    );
  }

  Future<bool> isValidUser(String username, String password) async {
    final db = await database;
    var result = await db.query(usersTable,
        where: 'username = ? AND password = ?', whereArgs: [username, password]);
    return result.isNotEmpty;
  }

  Future<int> insertUser(String username, String password) async {
    final db = await database;
    return await db.insert(usersTable, {'username': username, 'password': password});
  }

  Future<List<Task>> getTasks(String username) async {
    final db = await database;
    var result = await db.query(tasksTable, where: 'username = ?', whereArgs: [username]);
    return result.map((taskMap) => Task.fromMap(taskMap)).toList();
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(tasksTable, task.toMap());
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      tasksTable,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(tasksTable, where: 'id = ?', whereArgs: [id]);
  }
}
