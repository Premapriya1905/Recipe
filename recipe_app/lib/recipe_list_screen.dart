import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'recipe_detail_screen.dart';
import 'main.dart'; // 👈 Import to use themeNotifier

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Map<String, dynamic>> filteredRecipes = [];
  Map<String, dynamic>? recipeOfTheDay;
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchRecipeOfTheDay(); // 👈 Fetch the recipe of the day on load
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchRecipeOfTheDay() async {
    final url = 'https://www.themealdb.com/api/json/v1/1/random.php';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meal = data['meals'][0];

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

        setState(() {
          recipeOfTheDay = {
            'title': meal['strMeal'],
            'image': meal['strMealThumb'],
            'ingredients': ingredients,
            'instructions': meal['strInstructions'],
          };
        });
      }
    } catch (e) {
      print('Error fetching recipe of the day: $e');
    }
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
        final List<dynamic>? meals = data['meals'];

        if (meals == null) {
          setState(() {
            filteredRecipes = [];
            isLoading = false;
          });
          return;
        }

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
            'instructions': meal['strInstructions'],
          };
        }).toList();

        setState(() {
          filteredRecipes = fetchedRecipes;
          isLoading = false;
        });
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

  void filterSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (query.isNotEmpty) {
        fetchRecipes(query);
      } else {
        setState(() {
          filteredRecipes = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              themeNotifier.value =
                  themeNotifier.value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
            },
          ),
        ],
      ),
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
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        fetchRecipes(value.trim());
                      }
                    },
                    textInputAction: TextInputAction.search,
                  ),
                ),

                // 👇 Recipe of the Day
                if (recipeOfTheDay != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            recipeOfTheDay!['image'],
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          'Recipe of the Day\n${recipeOfTheDay!['title']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailScreen(recipe: recipeOfTheDay!),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                // 👇 Search Results List
                Expanded(
                  child: filteredRecipes.isEmpty
                      ? Center(child: Text('No recipes found'))
                      : ListView.builder(
                          itemCount: filteredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = filteredRecipes[index];
                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
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
