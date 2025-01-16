import 'package:flutter/material.dart';

import '../models/meal.dart';
import 'categories_screen.dart';
import 'favorite_screan.dart';
import '../components/application_app_bar.dart';
import '../components/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal> favoriteMeals;

  const TabsScreen({super.key, required this.favoriteMeals});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedScreenIndex = 0;

  late List<Map<String, Object>> screens;

  @override
  void initState() {
    screens = [
      {
        'title': 'Lista de categorias',
        'screen': CategoriesScreen(),
      },
      {
        'title': 'Meus favoritos',
        'screen': FavoriteScrean(favoriteMeals: widget.favoriteMeals),
      },
    ];
  }

  _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: ApplicationAppBar.createAppBar(
        screens[_selectedScreenIndex]['title'].toString(),
        context,
      ),
      drawer: MainDrawer(),
      body: screens[_selectedScreenIndex]['screen'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _selectScreen,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedScreenIndex,
        // type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            // backgroundColor: Theme.of(context).colorScheme.primary,
            icon: Icon(
              Icons.category,
              // color: Colors.white,
            ),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
              // color: Colors.white,
            ),
            label: 'Preferidas',
          ),
        ],
      ),
    );
  }
}
