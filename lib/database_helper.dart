import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Calculation {
  final int? id;
  final String expression;
  final String result;

  Calculation({this.id, required this.expression, required this.result});

  // Перетворення об'єкта у Map для зберігання в базі даних
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
    };
  }

  // Метод для створення об'єкта з Map
  factory Calculation.fromMap(Map<String, dynamic> map) {
    return Calculation(
      id: map['id'],
      expression: map['expression'],
      result: map['result'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  // Отримання бази даних з ініціалізацією, якщо вона ще не створена
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Ініціалізація бази даних
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'calculations.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE calculations(id INTEGER PRIMARY KEY AUTOINCREMENT, expression TEXT, result TEXT)',
        );
      },
    );
  }

  // Метод для вставки обчислення у базу даних
  Future<void> insertCalculation(String expression, String result) async {
    final db = await database;
    await db.insert(
      'calculations',
      Calculation(expression: expression, result: result).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Метод для отримання історії обчислень
  Future<List<Calculation>> getCalculations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('calculations');

    // Перетворення списку Map у список об'єктів Calculation
    return List.generate(maps.length, (i) {
      return Calculation.fromMap(maps[i]);
    });
  }

  // Метод для очищення історії обчислень
  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('calculations');
  }
}
