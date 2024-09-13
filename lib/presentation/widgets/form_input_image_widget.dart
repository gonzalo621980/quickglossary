import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FormInputImageWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final IconData icon;
  final String initValue;
  final String hint;
  final bool isEnabled;
  final bool isPassword;
  final bool multiline;
  final Color colorFont;
  Function(String) onChanged;

  FormInputImageWidget(
      {@required this.icon,
      this.initValue = '',
      this.hint = '',
      this.isEnabled = true,
      this.isPassword = false,
      this.multiline = false,
      this.colorFont = Colors.black,
      this.onChanged});

  void setValue(String newValue) {}

  @override
  Widget build(BuildContext context) {
    if (this.initValue != null) {
      _controller.text = this.initValue;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              this.icon,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: this.colorFont, fontSize: 21.0),
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: this.hint, hintStyle: TextStyle(color: Colors.grey)),
              enabled: this.isEnabled,
              obscureText: this.isPassword,
              enableSuggestions: !this.isPassword,
              autocorrect: !this.isPassword,
              maxLines: (!this.multiline) ? 1 : 2,
              onChanged: (value) {
                this.onChanged(value.toLowerCase());
              },
            ),
          )
        ],
      ),
    );
  }
}
