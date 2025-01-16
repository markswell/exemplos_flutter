import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../components/meal_item.dart';

class FavoriteScrean extends StatelessWidget {
  final List<Meal> favoriteMeals;
  const FavoriteScrean({super.key, required this.favoriteMeals});

  @override
  Widget build(BuildContext context) {
    return favoriteMeals.isEmpty
        ? Center(
            child: Text('Nenhuma comida foi favoritada!'),
          )
        : ListView.builder(
            itemCount: favoriteMeals.length,
            itemBuilder: (ctx, index) => MealItem(meal: favoriteMeals[index]),
          );
  }
}
