import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe['title'])),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network('${recipe['image']}'),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ingredients',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            ...recipe['ingredients'].map<Widget>((ingredient) {
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.check, color: Colors.green),
                title: Text(ingredient),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
