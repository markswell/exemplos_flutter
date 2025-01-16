import 'package:flutter/material.dart';

import '../utils/PointsUtils.dart';

class Horizontalpoints extends StatefulWidget {
  final String title;
  final String empty;
  final String filled;

  const Horizontalpoints({
    super.key,
    required this.title,
    required this.empty,
    required this.filled,
  });

  @override
  State<Horizontalpoints> createState() => _Horizontalpoints();
}

class _Horizontalpoints extends State<Horizontalpoints> {
  int current = 0;
  int max = 10;

  void _setWildpower(int current) {
    setState(() {
      if (current == 1 && this.current == 1) {
        this.current = 0;
      } else {
        this.current = current;
      }
    });
  }

  void _addWildpower() {
    setState(() {
      max++;
    });
  }

  void _lassWildpower() {
    setState(() {
      max--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 30),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _lassWildpower,
                      icon: Icon(
                        Icons.remove,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: _addWildpower,
                      icon: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Wrap(
            children: PointsUtils.points(
              context,
              max,
              current,
              widget.empty,
              widget.filled,
              _setWildpower,
            ),
          ),
        ],
      ),
    );
  }
}
