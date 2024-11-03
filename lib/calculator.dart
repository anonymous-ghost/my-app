import 'package:flutter/material.dart';
import 'database_helper.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _appendInput(String value) {
    setState(() {
      _input += value;
    });
  }

  void _calculate() async {
    if (_input.isEmpty) return;
    try {
      final result = _evaluate(_input);
      await _dbHelper.insertCalculation(_input, result.toString());
      setState(() {
        _input = result.toString();
      });
    } catch (e) {
      setState(() {
        _input = 'Error';
      });
    }
  }