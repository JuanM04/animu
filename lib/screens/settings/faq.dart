import 'package:flutter/material.dart';

class FAQ extends StatelessWidget {
  final faqs = <QuestionAnswer>[
    QuestionAnswer(
      '¿Cómo marco un episodio como visto?',
      'Para marcar un episodio como visto, tenés que mantener apretado el episodio en la página del anime hasta sentir una vibración, yse pondrá una línea ondulada en el número (sí, no es muy intuitivo).',
    ),
    QuestionAnswer(
      '¿Qué son esas tarjetitas raras cuando selecciono un anime?',
      'La primera, negra, sirve para poner el estado de anime (si está para ver, si lo estás viendo o si lo viste). La segunda, roja, aterna estár en tu lista de favoritos.',
    ),
    QuestionAnswer(
      'Presiento que las cosas tardan en cargar.',
      'Sí, y no es mi culpa. AnimeFLV tiene un "bloqueo" para evitar que "ataquen" su sitio (cuando entrás en su web, te salta algo como "verificando su navegador"). Esto es lo mismo, solo que no se ve esa pantalla y parece que tarda más.',
    ),
    QuestionAnswer(
      'Recuerdo que AnimeFLV usa varios servidores, ¿por qué hay solo dos?',
      'Por cuestiones técnicas, se usa Natsuki/Izanagi y Fembed, los cuales están en todos los animes. De no funcionar uno, podés seleccionar el otro.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: faqs.length,
      itemBuilder: (context, i) => faqs[i],
    );
  }
}

class QuestionAnswer extends StatelessWidget {
  final String question;
  final String answer;
  const QuestionAnswer(this.question, this.answer, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(bottom: 20),
      title: Text(question),
      subtitle: Text(answer),
    );
  }
}
