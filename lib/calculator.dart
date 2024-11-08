import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'history_screen.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  child: Text('1'), onPressed: () => _appendInput('1')),
              ElevatedButton(
                  child: Text('2'), onPressed: () => _appendInput('2')),
              ElevatedButton(
                  child: Text('3'), onPressed: () => _appendInput('3')),
              ElevatedButton(
                  child: Text('+'), onPressed: () => _appendInput('+')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  child: Text('4'), onPressed: () => _appendInput('4')),
              ElevatedButton(
                  child: Text('5'), onPressed: () => _appendInput('5')),
              ElevatedButton(
                  child: Text('6'), onPressed: () => _appendInput('6')),
              ElevatedButton(
                  child: Text('-'), onPressed: () => _appendInput('-')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  child: Text('7'), onPressed: () => _appendInput('7')),
              ElevatedButton(
                  child: Text('8'), onPressed: () => _appendInput('8')),
              ElevatedButton(
                  child: Text('9'), onPressed: () => _appendInput('9')),
              ElevatedButton(
                  child: Text('*'), onPressed: () => _appendInput('*')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(child: Text('C'), onPressed: _clear),
              ElevatedButton(
                  child: Text('0'), onPressed: () => _appendInput('0')),
              ElevatedButton(child: Text('='), onPressed: _calculate),
              ElevatedButton(
                  child: Text('/'), onPressed: () => _appendInput('/')),
            ],
          ),
        ],
      ),
    );
  }
}
