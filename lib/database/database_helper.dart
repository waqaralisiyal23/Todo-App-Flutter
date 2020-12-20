import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/models/todo.dart';

class DatabaseHelper{

  // Future<Database> database() async {
  //   return openDatabase(
  //     join(await getDatabasesPath(), 'todo.db'),
  //     onCreate: (db, version) async {
  //       await db.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
  //       await db.execute("CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");
  //
  //       return db;
  //     },
  //     version: 1,
  //   );
  // }

  static DatabaseHelper _databaseHelper;        //Singleton DatabaseHelper
  static Database _database;                    //Singleton Database

  DatabaseHelper._createInstance();   //Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper(){
    if(_databaseHelper==null)
      _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  //Getter of database
  Future<Database> get database async {
    if(_database==null)
      _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async{
    //Get the directory path for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todo.db';

    //Open/Create the database at a given path
    var todoDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return todoDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
    await db.execute("CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await this.database;
    await _db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await this.database;
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await this.database;
    await _db.rawUpdate("UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await this.database;
    await _db.insert('todo', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await this.database;
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]['id'], title: taskMap[index]['title'], description: taskMap[index]['description']);
    });
  }

  Future<List<Todo>> getTodo(int taskId) async {
    Database _db = await this.database;
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(id: todoMap[index]['id'], title: todoMap[index]['title'], taskId: todoMap[index]['taskId'], isDone: todoMap[index]['isDone']);
    });
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await this.database;
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  Future<void> deleteTask(int id) async {
    Database _db = await this.database;
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
  }

  Future<int> getCount() async {
    //database connection
    Database db = await this.database;
    var x = await db.rawQuery('SELECT COUNT (*) from tasks');
    int count = Sqflite.firstIntValue(x);
    return count;
  }
}