import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Calculation {
  final int? id;
  final String expression;
  final String result;

  Calculation({this.id, required this.expression, required this.result});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
    };
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'calculations.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE calculations(id INTEGER PRIMARY KEY AUTOINCREMENT, expression TEXT, result TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertCalculation(String expression, String result) async {
    final db = await database;
    await db.insert(
      'calculations',
      Calculation(expression: expression, result: result).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Calculation>> getCalculations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('calculations');

    return List.generate(maps.length, (i) {
      return Calculation(
        id: maps[i]['id'],
        expression: maps[i]['expression'],
        result: maps[i]['result'],
      );
    });
  }
}
