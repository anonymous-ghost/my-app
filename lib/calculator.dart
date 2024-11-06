import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'history_screen.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _dbHelper = DatabaseHelper();
  String _input = '';
  String _result = '';

  void _onButtonPressed(String value) {
    setState(() {
      _input += value;
    });
  }

  void _calculateResult() {
    try {
      final result = double.parse(_input).toString();
      setState(() {
        _result = result;
      });
      _dbHelper.insertCalculation(_input, _result); // Зберегти в базу
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _clearInput() {
    setState(() {
      _input = '';
      _result = '';
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
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_input, style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                Text(_result, style: TextStyle(fontSize: 32)),
              ],
            ),
          ),
          _buildButtonRow(['7', '8', '9', '+']),
          _buildButtonRow(['4', '5', '6', '-']),
          _buildButtonRow(['1', '2', '3', '*']),
          _buildButtonRow(['0', '.', '=', '/']),
          _buildButtonRow(['C']),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        return ElevatedButton(
          onPressed: () {
            if (button == '=') {
              _calculateResult();
            } else if (button == 'C') {
              _clearInput();
            } else {
              _onButtonPressed(button);
            }
          },
          child: Text(button, style: TextStyle(fontSize: 24)),
        );
      }).toList(),
    );
  }
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
    return double.parse(input);
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
