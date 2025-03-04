import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// To help store user details for users table
class User {
  final int? id;
  final String username;
  final String email;
  final String password;

  User({this.id, required this.username, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'email': email, 'password': password};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }
}

// To help store data for flood reports
class FloodReport {
  final int? id;
  final String photo;
  final String description;
  final String location;

  FloodReport({this.id, required this.photo, required this.description, required this.location});

  Map<String, dynamic> toMap() {
    return {'id': id, 'photo': photo, 'description': description, 'location': location};
  }

  factory FloodReport.fromMap(Map<String, dynamic> map) {
    return FloodReport(
      id: map['id'],
      photo: map['photo'],
      description: map['description'],
      location: map['location'],
    );
  }
}

// To help store data for mood
class Mood {
  final int? id;
  final String status;
  final String imagePath;

  Mood({this.id, required this.status, required this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'imagePath': imagePath,
    };
  }

  factory Mood.fromMap(Map<String, dynamic> map) {
    return Mood(
      id: map['id'],
      status: map['status'],
       imagePath: map['imagePath'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'shiokweather.db');

    return await openDatabase(
      path,
      version: 1, 
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE floodreport (
        id INTEGER PRIMARY KEY,
        photo TEXT,
        description TEXT,
        location TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE mood (
        id INTEGER PRIMARY KEY,
        status TEXT,
        imagePath TEXT
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    Database db = await instance.db;
    return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.db;
    return await db.query('users');
  }

  Future<int> updateUser(User user) async {
    Database db = await instance.db;
    return await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await instance.db;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> initializeUsers() async {
    Database db = await instance.db;

    List<Map<String, dynamic>> existingUsers = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: ['Admin'],
    );

    if (existingUsers.isEmpty) {
      List<User> usersToAdd = [
        User(username: 'Admin', email: 'admin@gmail.com', password: 'admin123'),
      ];

      for (User user in usersToAdd) {
        await insertUser(user);
      }
    }
  }

  Future<int> insertFloodReport(FloodReport fr) async {
    Database db = await instance.db;
    return await db.insert('floodreport', fr.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllFloodReport() async {
    Database db = await instance.db;
    return await db.query('floodreport');
  }

  Future<int> updateFloodReport(FloodReport fr) async {
    Database db = await instance.db;
    return await db.update('floodreport', fr.toMap(), where: 'id = ?', whereArgs: [fr.id]);
  }

  Future<int> deleteFloodReport(int id) async {
    Database db = await instance.db;
    return await db.delete('floodreport', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertMood(Mood m) async {
    Database db = await instance.db;
    return await db.insert('mood', m.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllMood() async {
    Database db = await instance.db;
    return await db.query('mood');
  }

  Future<int> updateMood(Mood m) async {
    Database db = await instance.db;
    return await db.update('mood', m.toMap(), where: 'id = ?', whereArgs: [m.id]);
  }
}