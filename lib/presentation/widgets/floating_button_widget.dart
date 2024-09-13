import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quickglossary/domain/entities/word.dart';

class FloatingButtonWidget extends StatelessWidget {
  final Color iconColor;
  final Color backgroundColor;
  final IconData icon;
  final Word word;
  final String title;
  BuildContext contextParent;
  Function(BuildContext context, Word word) onClickAction;

  FloatingButtonWidget(
      {@required this.iconColor,
      @required this.backgroundColor,
      @required this.icon,
      this.word,
      this.contextParent,
      this.onClickAction,
      this.title});

  @override
  Widget build(BuildContext context) {
    this.contextParent = (this.contextParent == null) ? context : this.contextParent;

    return FloatingActionButton(
        tooltip: (this.title == null) ? "" : this.title,
        onPressed: () => {this.onClickAction(this.contextParent, this.word)},
        child: Icon(
          icon,
          color: this.iconColor,
        ),
        backgroundColor: this.backgroundColor);
  }
}
