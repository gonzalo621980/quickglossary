import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FormButtonWidget extends StatelessWidget {
  final Color primaryColor;
  final Color textColor;
  final IconData icon;
  final String text;
  Function(BuildContext context) onClickAction;

  FormButtonWidget(
      {@required this.primaryColor,
      @required this.textColor,
      @required this.icon,
      @required this.text,
      this.onClickAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              splashColor: this.primaryColor,
              color: this.primaryColor,
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      this.text,
                      style: TextStyle(color: this.textColor, fontSize: 17),
                    ),
                  ),
                  new Expanded(
                    child: Container(),
                  ),
                  new Transform.translate(
                    offset: Offset(10.0, 0.0),
                    child: new Container(
                      padding: const EdgeInsets.all(3.0),
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(28.0)),
                        splashColor: Colors.amber,
                        color: Colors.white,
                        child: Icon(
                          icon,
                          color: this.primaryColor,
                        ),
                        onPressed: () => {this.onClickAction(context)},
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () => {this.onClickAction(context)},
            ),
          ),
        ],
      ),
    );
  }
}
