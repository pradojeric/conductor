import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/logout_dialog.dart';

class LogoutButton extends StatefulWidget {

  LogoutButton(this.setLoggingOut);

  final Function setLoggingOut;

  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: Icon(Icons.power_settings_new, size: 30.0),
      onPressed: () async {
        final result = await showDialog(
          context: context,
          builder: (_) => LogoutDialog(widget.setLoggingOut),
        );
        return result;
      },
    );
  }
}
