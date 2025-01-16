import 'package:flutter/material.dart';

class VerticalPoints extends StatefulWidget {
  final String title;

  const VerticalPoints({super.key, required this.title});

  @override
  State<VerticalPoints> createState() => _VerticalPointsState();
}

class _VerticalPointsState extends State<VerticalPoints> {
  int _position = 0;

  final List<String> icons = [
    'lib/assets/ponto_volatil_branco.png',
    'lib/assets/ponto_volatil_marcado_um.png',
    'lib/assets/ponto_volatil_marcado_dois.png',
    'lib/assets/ponto_volatil_marcado_tres.png',
    'lib/assets/ponto_volatil_cheio.png',
  ];

  String _getIcon() {
    return icons[_position];
  }

  void changePosition() {
    int position = 0;
    if (_position == 0) {
      position = 1;
    } else if (_position == 1) {
      position = 2;
    } else if (_position == 2) {
      position = 3;
    } else if (_position == 3) {
      position = 4;
    } else if (_position == 4) {
      position = 0;
    }
    setState(() {
      _position = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          InkWell(
            onTap: changePosition,
            child: Image(image: AssetImage(_getIcon())),
          ),
        ],
      ),
    );
  }
}
