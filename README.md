**Recipe App**

A simple Recipe App built using Flutter that allows users to search for recipes from a public API, view detailed recipes, and see a list of ingredients for each recipe.

**Features**

🌤️ Dark/Light mode toggle using ValueNotifier

🔍 Search functionality with debounce

🍽️ Recipe list fetched from TheMealDB API

📋 Detailed recipe view with image, ingredients, and instructions

⭐ "Recipe of the Day" featured in the center of the home screen

▶️ "Watch on YouTube" button in the detail screen

**Tech Stack**

**Frontend:**

Flutter: A UI toolkit to build natively compiled applications for mobile, web, and desktop from a single codebase.

**Backend:**

TheMealDB API: A free API to fetch recipes and their details.

State Management: The app uses basic state management with setState to handle the UI updates.

**Installation**

Prerequisites
Make sure you have the following installed:

Flutter

Android Studio or VS Code for code editing

Dart (comes with Flutter installation)

Steps to Install
Clone the repository:

bash
Copy
Edit
git clone https://github.com/your-username/recipe-app.git
cd recipe-app
Install dependencies:

Run the following command to get all the dependencies:

bash
Copy
Edit
flutter pub get
Run the app:

To run the app, execute the following command:

bash
Copy
Edit
flutter run
This will launch the app on an emulator or a connected device.

API Usage
This app fetches recipe data from TheMealDB API. Specifically, it uses the search endpoint to get recipes based on the query entered by the user.

Search Endpoint: https://www.themealdb.com/api/json/v1/1/search.php?s=<query>

Data: It retrieves information such as the recipe title, image, and ingredients.

State Management
The app uses the simple setState method of Flutter to manage the state, which updates the UI whenever data is fetched or the search query changes.

**Code Explanation**

main.dart:

The entry point of the app that initializes the RecipeListScreen.

recipe_list_screen.dart:

Contains the list of recipes and the search bar functionality.

Fetches recipes from the API based on the user's search query.

recipe_detail_screen.dart:

Displays detailed information about a selected recipe, including the ingredients and a recipe image.
