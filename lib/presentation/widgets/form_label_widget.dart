import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FormLabelWidget extends StatelessWidget {
  final String label;

  FormLabelWidget({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: Text(
        label,
        style: TextStyle(color: Colors.grey, fontSize: 16.0),
      ),
    );
  }
}
