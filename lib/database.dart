// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Message {
  int id;
  String text;
  String image;
  String sender;
  DateTime createdAt;
  DateTime updatedAt;

  Message({
    required this.id,
    required this.text,
    required this.image,
    required this.sender,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'image': image,
      'sender': sender,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      text: map['text'],
      image: map['image'],
      sender: map['sender'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }
}

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('messages.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            image TEXT,
            sender TEXT,
            created_at INTEGER,
            updated_at INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertMessage(Message message) async {
    final db = await instance.database;
    return await db.insert('messages', message.toMap());
  }

  Future<List<Message>> getAllMessages() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('messages');
    return List.generate(maps.length, (i) {
      return Message.fromMap(maps[i]);
    });
  }

  Future<int> updateMessage(Message message) async {
    final db = await instance.database;
    return await db.update(
      'messages',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<int> deleteMessage(int id) async {
    final db = await instance.database;
    return await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isTableExists(String tableName) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
    );
    return result.isNotEmpty;
  }
}
