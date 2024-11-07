import 'package:flutter/material.dart';
import 'database_helper.dart';

class HistoryScreen extends StatelessWidget {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation History'),
      ),
      body: FutureBuilder<List<Calculation>>(
        future: _dbHelper.getCalculations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final calculations = snapshot.data ?? [];
          return ListView.builder(
            itemCount: calculations.length,
            itemBuilder: (context, index) {
              final calculation = calculations[index];
              return ListTile(
                title:
                    Text('${calculation.expression} = ${calculation.result}'),
              );
            },
          );
        },
      ),
    );
  }
}
