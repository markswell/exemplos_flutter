import 'package:flutter/material.dart';

import '../components/vertical_points.dart';

class VerticalPointsList extends StatefulWidget {
  const VerticalPointsList({super.key});

  @override
  State<VerticalPointsList> createState() => _VerticalPointsListState();
}

class _VerticalPointsListState extends State<VerticalPointsList> {
  List<String> points = [
    'Escoriado',
    'Machucado -1',
    'Ferido -1',
    'Ferido Gravemente -2',
    'Espancado -2',
    'Aleijado -5',
    'Incapacitado'
  ];

  void _lass() {
    if (points.length > 7) {
      setState(() {
        points.remove(points[0]);
      });
    }
  }

  void _add() {
    setState(() {
      points = ['Escoriado', ...points];
    });
  }

  List<VerticalPoints> getVerticalPoints() {
    return points.map((e) => VerticalPoints(title: e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Vitalidade',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _lass,
                  icon: Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: _add,
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        ...getVerticalPoints(),
      ],
    );
  }
}
