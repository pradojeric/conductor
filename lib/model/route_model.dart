import 'package:flutter_app/model/terminal_model.dart';

class RouteModel {
  final String routeName;
  final List<TerminalModel> terminals;

  RouteModel({this.routeName, this.terminals});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    List<TerminalModel> terminals = [];
    if (json['terminals'] != null) {
      for (int i = 0; i < json['terminals'].length; i++) {
        TerminalModel terminal = TerminalModel.fromJson(json['terminals'][i]);
        terminals.add(terminal);
      }
    }

    return RouteModel(routeName: json['route_name'], terminals: terminals);
  }
}
