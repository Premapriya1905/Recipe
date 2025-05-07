import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeDetailScreen({required this.recipe});

  void _launchYouTube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final youtubeUrl = recipe['youtube'];

    return Scaffold(
      appBar: AppBar(title: Text(recipe['title'])),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Image.network('${recipe['image']}'),
            SizedBox(height: 16),

            // Ingredients Title
            Text(
              'Ingredients',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Ingredients List
            ...recipe['ingredients'].map<Widget>((ingredient) {
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.check, color: Colors.green),
                title: Text(ingredient),
              );
            }).toList(),

            SizedBox(height: 20),

            // Instructions Title
            Text(
              'Instructions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Instructions Text
            Text(
              recipe['instructions'] ?? 'No instructions available.',
              style: TextStyle(fontSize: 16),
            ),

            // YouTube Button (conditionally shown)
            if (youtubeUrl != null && youtubeUrl.toString().trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.video_library),
                  label: Text('Watch on YouTube'),
                  onPressed: () => _launchYouTube(youtubeUrl),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
