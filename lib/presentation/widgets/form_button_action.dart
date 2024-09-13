import 'package:flutter/material.dart';

class FormButtonAction extends StatelessWidget {
  
  final String descripcion;
  final Icon icono;
  final Object data;
  BuildContext contextParent;
  Function(BuildContext context, String data) onTapAccion;

  FormButtonAction({@required this.contextParent, @required this.descripcion, @required this.icono, @required this.onTapAccion, this.data});

  @override
  Widget build(BuildContext context) {

    this.contextParent = (this.contextParent == null) ? context: this.contextParent;
    final ButtonStyle styleButton = ElevatedButton.styleFrom(primary: Colors.grey.shade200);

    return ElevatedButton(
      style: styleButton,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:[
          this.icono,
          Text(this.descripcion, style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
        ]
      ),
      onPressed: () {
          this.onTapAccion(this.contextParent, this.data);
      },
    );

  }
}
