import 'package:flutter/material.dart';

class MsjConfirmacion extends StatelessWidget {
  final String titulo;
  final String mensaje;
  final String data;

  BuildContext contextParent;
  Function(BuildContext context, String data) onAceptar;
  Function(BuildContext context, String data) onCancelar;

  MsjConfirmacion(
      {@required this.titulo,
      @required this.mensaje,
      this.data,
      this.contextParent,
      this.onAceptar,
      this.onCancelar});

  @override
  Widget build(BuildContext context) {
    this.contextParent =
        (this.contextParent == null) ? context : this.contextParent;
    final ButtonStyle styleButton =
        ElevatedButton.styleFrom(primary: Colors.grey.shade200);

    List<Widget> widgets = [];
    widgets.add(Text(this.mensaje));
    widgets.add(SizedBox(height: 20));

    Widget btnAceptar = (this.onAceptar != null)
        ? ElevatedButton(
            style: styleButton,
            child: Text("Aceptar",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            onPressed: () => this.onAceptar(this.contextParent, this.data))
        : SizedBox(height: 0);

    Widget btnCancelar = (this.onCancelar != null)
        ? ElevatedButton(
            style: styleButton,
            child: Text("Cancelar",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            onPressed: () => this.onCancelar(this.contextParent, this.data))
        : SizedBox(height: 0);

    widgets.add(Wrap(
        spacing: 10.0,
        direction: Axis.horizontal,
        alignment: WrapAlignment.end,
        children: <Widget>[
          SizedBox(width: 30),
          btnAceptar,
          btnCancelar,
        ]));

    return AlertDialog(
      scrollable: true,
      title: Text(this.titulo),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets),
      // actions: listaActions,
    );
  }
}
