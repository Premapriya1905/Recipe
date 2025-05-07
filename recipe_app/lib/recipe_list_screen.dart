import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Map<String, dynamic>> filteredRecipes = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchRecipes(String query) async {
  final url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$query';

  setState(() {
    isLoading = true;
  });

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> meals = data['meals'];

      // If meals is null or empty, set the state accordingly
      if (meals == null || meals.isEmpty) {
        setState(() {
          filteredRecipes = [];
          isLoading = false;
        });
      } else {
        // Proceed to map the meals if data is present
        final List<Map<String, dynamic>> fetchedRecipes = meals.map((meal) {
          List<String> ingredients = [];
          for (int i = 1; i <= 20; i++) {
            final ingredient = meal['strIngredient$i'];
            final measure = meal['strMeasure$i'];
            if (ingredient != null &&
                ingredient.toString().trim().isNotEmpty &&
                ingredient.toString().toLowerCase() != 'null') {
              ingredients.add('$ingredient - ${measure?.toString().trim() ?? ''}');
            }
          }

          return {
            'title': meal['strMeal'],
            'image': meal['strMealThumb'],
            'ingredients': ingredients,
          };
        }).toList();

        setState(() {
          filteredRecipes = fetchedRecipes;
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load recipes');
    }
  } catch (e) {
    print("Error fetching recipes: $e");
    setState(() {
      isLoading = false;
    });
  }
}


  // Filter search as user types
  void filterSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredRecipes = [];
      });
    } else {
      fetchRecipes(query); // Fetch data based on the search query
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipes')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a recipe...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: filterSearch,
                  ),
                ),
                Expanded(
                  child: filteredRecipes.isEmpty
                      ? Center(child: Text('No recipes found'))
                      : ListView.builder(
                          itemCount: filteredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = filteredRecipes[index];
                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(10),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    '${recipe['image']}',
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(recipe['title']),
                                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecipeDetailScreen(recipe: recipe),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
