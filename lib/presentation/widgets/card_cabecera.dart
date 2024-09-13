import 'package:flutter/material.dart';

class CardCabecera extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final Icon icono;

  CardCabecera({@required this.titulo, @required this.subtitulo, @required this.icono});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: this.icono,
            title: Text(this.titulo, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
          ),
          Text(this.subtitulo, style: TextStyle(fontSize: 18)),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
