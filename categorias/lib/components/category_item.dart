import 'package:flutter/material.dart';

import '../models/category.dart';
import '../utils/app_routs.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem(
    this.category,
  );

  void _selectCategory(BuildContext context) {
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (_) {
    //     return CategoriesMealsScreen();
    //   },
    // ));
    Navigator.of(context).pushNamed(
      AppRoutes.CATEGORIES_MEALS,
      arguments: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectCategory(context),
      borderRadius: BorderRadius.circular(15),
      splashColor: Theme.of(context).colorScheme.primary,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                category.color.withValues(alpha: 0.5),
                category.color,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        child: Text(category.title),
      ),
    );
  }
}
