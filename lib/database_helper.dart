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