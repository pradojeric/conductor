import 'package:flutter/material.dart';
import '../shared_service_login.dart';

class LogoutDialog extends StatefulWidget {
  LogoutDialog(this.callback);
  final Function(bool) callback;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logout'),
      content: Text('Do you want to logout?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              widget.callback(true);
              SharedService.logout().then(
                (_) => Navigator.of(context).pushReplacementNamed('/login'),
              );
            });
          },
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
