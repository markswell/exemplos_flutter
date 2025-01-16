import 'package:flutter/material.dart';

import './questao.dart';
import './resposta.dart';

class Questionario extends StatelessWidget {
  final List<Map<String, Object>> perguntas;
  final int perguntaSelecionada;
  final void Function(int pontuacao) responder;
  final bool continua;
  const Questionario(
      {super.key,
      required this.perguntas,
      required this.perguntaSelecionada,
      required this.responder,
      required this.continua});

  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>> respostas =
        continua ? perguntas[perguntaSelecionada].cast()['resposta'] : [];

    return Column(
      children: [
        Questao(perguntas[perguntaSelecionada]['pergunta'].toString()),
        ...respostas.map((resp) => Resposta(resp['texto'].toString(),
            () => responder(int.parse(resp['pontuacao'].toString()))))
      ],
    );
  }
}
