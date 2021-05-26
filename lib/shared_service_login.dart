import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'utils/constants.dart';
import 'model/login_model.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details") != null ? true : false;
  }

  static Future<void> setLoginDetails(LoginResponseModel loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("login_details",
        loginResponse != null ? jsonEncode(loginResponse.toJson()) : null);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    String token = jsonDecode(prefs.getString("login_details"))["token"];
    await http.post(Uri.parse('$API_URL/api/conductor/logout'), headers: {
      'Authorization': 'Bearer $token',
    });
    await prefs.clear();
  }
}
