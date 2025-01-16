import 'package:categorias/screens/categories_screen.dart';
import 'package:categorias/screens/meal_detail.dart';
import 'package:flutter/material.dart';

import 'screens/categories_meals_screem.dart';
import './utils/app_routs.dart';
import './screens/tabs_screen.dart';
import 'screens/settings_sceen.dart';
import './models/meal.dart';
import './data/dummy_data.dart';
import './models/settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Setting settings = Setting();
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  _filterMeals(Setting settings) {
    setState(() {
      _availableMeals = DUMMY_MEALS.where((meal) {
        final filterGluten = settings.isGlutenFree && !meal.isGlutenFree;
        final filterLactose = settings.isLactoseFree && !meal.isLactoseFree;
        final filterVegan = settings.isVegan && !meal.isVegan;
        final filterVegetarian = settings.isVegetarian && !meal.isVegetarian;
        return !filterGluten &&
            !filterLactose &&
            !filterVegan &&
            !filterVegetarian;
      }).toList();
    });
  }

  _toggleFavoritMeal(Meal meal) {
    setState(() {
      _favoriteMeals.contains(meal)
          ? _favoriteMeals.remove(meal)
          : _favoriteMeals.add(meal);
    });
  }

  bool _isFavorite(Meal meal) => _favoriteMeals.contains(meal);

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData(
      fontFamily: "Raleway",
    );

    return MaterialApp(
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.pink,
          secondary: Colors.amber,
        ),
        canvasColor: Color.fromARGB(255, 254, 229, 200),
        textTheme: ThemeData.light().textTheme.copyWith(
            titleLarge: TextStyle(fontSize: 30),
            // titleMedium: TextStyle(fontSize: 20),
            // titleSmall: TextStyle(fontSize: 10),
            bodyMedium: TextStyle(
              fontSize: 15,
              color: Colors.black,
            )),
      ),
      debugShowCheckedModeBanner: false,
      // home: CategoriesScreen(),
      routes: {
        AppRoutes.HOME: (_) => TabsScreen(favoriteMeals: _favoriteMeals),
        AppRoutes.CATEGORIES_MEALS: (_) => CategoriesMealsScreen(
              meals: _availableMeals,
            ),
        AppRoutes.MEAL_DETAIL: (_) => MealDetail(
              toggleFavoriteMeal: _toggleFavoritMeal,
              isFavorite: _isFavorite,
            ),
        AppRoutes.SETTINGS: (_) => SettingsSceen(
              onSettingsChange: _filterMeals,
              setting: settings,
            ),
      },
    );
  }
}
