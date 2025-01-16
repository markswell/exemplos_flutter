import 'package:flutter/material.dart';

class PointsUtils {
  static List<InkWell> points(BuildContext context, int max, int current,
      String empty, String filled, void Function(int) function) {
    double widthScreen = MediaQuery.of(context).size.width;

    List<InkWell> points = [];
    for (int i = 1; i - 1 < max; i++) {
      if (i > current) {
        points.add(_createInkWell(empty, widthScreen, i, function));
      } else {
        points.add(_createInkWell(filled, widthScreen, i, function));
      }
    }
    return points;
  }

  static InkWell _createInkWell(String imageUrl, double widthScreen,
      int wildpower, void Function(int) function) {
    return InkWell(
      onTap: () => function(wildpower),
      child: Image(
        image: AssetImage(imageUrl),
        width: widthScreen / 10,
        height: 35,
      ),
    );
  }
}
