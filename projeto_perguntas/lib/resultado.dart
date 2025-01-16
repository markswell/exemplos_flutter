import 'package:flutter/material.dart';

class Resultado extends StatelessWidget {
  final int _pontuacao;
  final void Function() _reiniciar;

  const Resultado(this._pontuacao, this._reiniciar, {super.key});

  get resultado {
    if (_pontuacao < 8) {
      return 'Parabens!';
    } else if (_pontuacao < 12) {
      return 'Você é bom!';
    } else if (_pontuacao < 16) {
      return 'Impressionante';
    } else {
      return 'Nível Jedi!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            resultado,
            style: TextStyle(fontSize: 30),
          ),
        ),
        TextButton(
          onPressed: _reiniciar,
          child: Container(
            margin: EdgeInsets.only(top: 100),
            child: Text(
              'Reiniciar',
              style: TextStyle(color: Colors.blue, fontSize: 25),
            ),
          ),
        )
      ],
    );
  }
}
