import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// To help store user details for users table
class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String? displayname;
  final String? status;
  final String? mood;

  User({this.id, required this.username, required this.email, required this.password,
    this.displayname, this.status, this.mood});

  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'email': email, 'password': password,
    'displayname': displayname, 'status': status, 'mood': mood};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      displayname: map['displayname'],
      status: map['status'],
      mood: map['mood']
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

// To help store data for friend list
class Friendlist {
  final int uid1;
  final int uid2;
  final String timestamp;

  Friendlist({required this.uid1, required this.uid2, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'uid1': uid1,
      'uid2': uid2,
      'timestamp': timestamp,
    };
  }

  factory Friendlist.fromMap(Map<String, dynamic> map) {
    return Friendlist(
      uid1: map['uid1'],
      uid2: map['uid2'],
      timestamp: map['timestamp'],
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

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT,
        email TEXT,
        password TEXT,
        displayname TEXT,
        status TEXT,
        mood TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE friendlist (
        uid1 INTEGER,
        uid2 INTEGER,
        timestamp TEXT,
        FOREIGN KEY (uid1) REFERENCES users(id),
        FOREIGN KEY (uid2) REFERENCES users(id)
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

  Future<List<Map<String, dynamic>>> queryOneUser(int? id) async {
    Database db = await instance.db;
    return await db.query('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    Database db = await instance.db;
    return await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> updateOneUser(String displayname, String email, String username, int? id) async {
    Database db = await instance.db;
    return await db.rawUpdate('UPDATE users SET displayname="$displayname", email="$email", username="$username" WHERE id=$id');
  }

  // Update user mood and status by user id (uid)
Future<int> updateUserMoodAndStatusById(int uid, String status, String moodImagePath) async {
  Database db = await instance.db;

  // Update status and mood based on user id
  return await db.update(
    'users',
    {'status': status, 'mood': moodImagePath},
    where: 'id = ?',
    whereArgs: [uid],
  );
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
        User(id: 1, username: 'Admin', email: 'admin@gmail.com', password: 'admin123'),
        User(id: 2, username: 'Riski', email: 'riski@gmail.com', password: 'riski123',
            displayname: 'Riski L', status: "I'm so confused today", mood: 'sunny.png'),
        User(id: 3, username: 'Bew', email: 'bew@gmail.com', password: 'bew123',
            displayname: 'Bew', status: "I'm happy right now", mood: 'happy.png'),
        User(id: 4, username: 'Nana', email: 'nana@gmail.com', password: 'nana123',
            displayname: 'Nana', status: "Hey im very sad today", mood: 'sad.png')
      ];

      for (User user in usersToAdd) {
        await insertUser(user);
      }

      ByteData b1 = await rootBundle.load('assets/images/flood1.png');
      String base641 = base64Encode(Uint8List.view(b1.buffer));
      ByteData b2 = await rootBundle.load('assets/images/flood2.png');
      String base642 = base64Encode(Uint8List.view(b2.buffer));

      List<FloodReport> floodToAdd = [
        FloodReport(photo: base641, description: 'Flood is really high here!! Be careful everyone!', location: 'Woodlands'),
        FloodReport(photo: base642, description: 'Oh my god! Be wary of high flood area at Queenstown Shopping Center!', location: 'Queenstown')
      ];

      for (FloodReport f in floodToAdd) {
        await insertFloodReport(f);
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

Future<int> insertFriend(Friendlist fl) async {
  Database db = await instance.db;

  // Check if the friend already exists in the friendlist
  var result = await db.query('friendlist',
      where: '(uid1 = ? AND uid2 = ?) OR (uid1 = ? AND uid2 = ?)',
      whereArgs: [fl.uid1, fl.uid2, fl.uid2, fl.uid1]);

  // If the result is not empty, the friendship already exists
  if (result.isNotEmpty) {
    print("Friendship already exists.");
    return 0;
  }
  return await db.insert('friendlist', fl.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}


  Future<List<Map<String, dynamic>>> queryFriendlist(int? id) async {
    Database db = await instance.db;
    return await db.rawQuery(
        'SELECT u.id, u.displayname, u.status, u.mood '
            'FROM users AS u '
        'INNER JOIN friendlist AS fl ON (u.id = fl.uid1 OR U.id = fl.uid2) '
        'WHERE (fl.uid1=$id OR fl.uid2=$id) AND u.id != $id');
  }
}