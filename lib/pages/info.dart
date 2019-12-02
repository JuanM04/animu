import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset('images/Name.png'),
              ),
              SizedBox(height: 30),
              Text(
                'Animú es una aplicación para ver anime fácilmente. Funciona (de manera no oficial) con los servidores de AnimeFLV.net.\n\nPara agregar una anime a favoritos, tenés que apretar el corazón en la página del animes; y para marcar un episodio como visto, tenés que mantener apretado el episodio en la página del anime hasta sentir una vibración (se pondrá una línea ondulada en el número).',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 50),
              Text(
                'Hecho con ❤️ por JuanM04',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
