import 'dart:convert';

import 'package:http/http.dart' as http;

class API {
  static Future getResponse({String uri, String token}) async {
    var url = Uri.parse(uri);
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Cannot connect to server!');
    }
  }

  static Future postRequest({String uri, String token, dynamic requestModel}) async {
    try {
      var url = Uri.parse(uri);
      final response = await http.post(url, body: jsonEncode(requestModel), headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 500) {
        print(response.body);
      } else {
        throw Exception('Cannot connect to server!');
      }
    } on Exception catch ($e) {
      print($e);
    }
  }
}
