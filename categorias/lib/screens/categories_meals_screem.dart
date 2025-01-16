import 'package:flutter/material.dart';
import '../models/category.dart';

import '../components/meal_item.dart';
import '../components/application_app_bar.dart';
import '../models/meal.dart';

class CategoriesMealsScreen extends StatelessWidget {
  final color = Colors.white;
  final List<Meal> meals;

  const CategoriesMealsScreen({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    final Category category =
        ModalRoute.of(context)!.settings.arguments as Category;

    final categoryMeals = meals.where((meal) {
      return meal.categories.contains(category.id);
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: ApplicationAppBar.createAppBar(
        category.title,
        context,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: categoryMeals.length,
          itemBuilder: (ctx, index) {
            return MealItem(meal: categoryMeals[index]);
          },
        ),
      ),
    );
  }
}
