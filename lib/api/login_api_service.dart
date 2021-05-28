import 'dart:io';
import 'package:flutter_app/model/employee_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/login_model.dart';
import '../utils/constants.dart';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    var url = Uri.parse('$API_URL/api/conductor/login');
    final response = await http.post(url, body: requestModel.toJson());
    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Cannot connect to server!');
    }
  }

  Future<EmployeeModel> employeeProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String token = jsonDecode(prefs.getString("login_details"))["token"];
    final response = await http
        .get(Uri.parse('$API_URL/api/conductor/employee-profile'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return EmployeeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('No Data');
    }
  }
}
