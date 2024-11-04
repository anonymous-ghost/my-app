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
   double _evaluate(String input) {
    // Проста реалізація для обчислень. Можна додати більше функцій.
    return double.parse(input); // Заміни це на свою логіку обчислень
  }

  void _clear() {
    setState(() {
      _input = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              _input,
              style: TextStyle(fontSize: 48),
            ),
          ),