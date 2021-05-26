import 'package:flutter/material.dart';

class DialogBox extends StatefulWidget {
  final String text;
  final String body;
  final Function action;

  DialogBox({this.text, this.body, this.action});
  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.text),
      content: Text(widget.body),
      actions: <Widget>[
        TextButton(
          onPressed: widget.action,
          child: Text('Yes'),
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'))
      ],
    );
  }
}
