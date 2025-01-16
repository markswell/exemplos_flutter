import 'package:categorias/models/meal.dart';
import 'package:flutter/material.dart';

class MealDetail extends StatelessWidget {
  final Function(Meal) toggleFavoriteMeal;
  final bool Function(Meal) isFavorite;

  const MealDetail(
      {super.key, required this.toggleFavoriteMeal, required this.isFavorite});

  Widget _createSectionTitle(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _createSectionContainer(Widget child) {
    return Container(
      width: 350,
      height: 250,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final meal = ModalRoute.of(context)!.settings.arguments as Meal;

    double height = MediaQuery.of(context).size.height / 4;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          meal.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height,
              width: double.infinity,
              child: Image.network(meal.imageUrl, fit: BoxFit.cover),
            ),
            _createSectionTitle(context, 'Ingredientes'),
            _createSectionContainer(
              ListView.builder(
                itemCount: meal.ingredients.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Text(
                      meal.ingredients[index],
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            _createSectionTitle(context, 'Passos'),
            _createSectionContainer(ListView.builder(
              itemCount: meal.steps.length,
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(meal.steps[index]),
                    ),
                    Divider(),
                  ],
                );
              },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: isFavorite(meal)
            ? Theme.of(context).colorScheme.secondary
            : Colors.blueGrey,
        onPressed: () {
          toggleFavoriteMeal(meal);
          // Navigator.of(context).pop(meal.title);
        },
        child: Icon(
          Icons.star,
          color: Color.fromARGB(255, 119, 92, 11),
        ),
      ),
    );
  }
}
