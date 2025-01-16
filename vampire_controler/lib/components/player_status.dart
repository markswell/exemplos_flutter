import 'package:flutter/material.dart';

import 'horizontalPoints.dart';
import 'vertical_points.dart';
import 'vertical_points_list.dart';

class PlayerStatus extends StatefulWidget {
  const PlayerStatus({super.key});

  @override
  State<PlayerStatus> createState() => _PlayerStatusState();
}

class _PlayerStatusState extends State<PlayerStatus> {
  int blood = 0;
  int vitality = 0;

  int bloodMax = 10;
  int vitalityExtra = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Vampiro: A Mascara',
            style: TextStyle(fontSize: 35),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Horizontalpoints(
                title: 'Força de vontade',
                empty: 'lib/assets/ponto_permanente_branco.png',
                filled: 'lib/assets/ponto_permanente_preenchido.png',
              ),
              Horizontalpoints(
                title: 'Sangue',
                empty: 'lib/assets/ponto_volatil_branco.png',
                filled: 'lib/assets/ponto_volatil_cheio.png',
              ),
              VerticalPointsList(),
            ],
          ),
        ),
      ),
    );
  }
}
