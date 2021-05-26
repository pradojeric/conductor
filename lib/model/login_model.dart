import 'package:flutter_app/model/employee_model.dart';

class LoginResponseModel {
  final String token;
  final String error;

  EmployeeModel profile;

  LoginResponseModel({this.token, this.error, this.profile});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"] != null ? json["token"] : "",
      error: json["error"] != null ? json["error"] : "",
      profile: EmployeeModel.fromJson(
        json['profile'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'token': token.trim(), 'error': error.trim()};
    return map;
  }
}

class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.trim(),
      'password': password.trim(),
    };

    return map;
  }
}
