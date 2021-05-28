import 'dart:async';
import 'package:flutter_app/api/get_api_response.dart';
import 'package:flutter_app/model/ride_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/constants.dart';

enum Action { Ride }

class ConductorBloc {
  Future<List<RideModel>> getAllRides() async {
    final prefs = await SharedPreferences.getInstance();
    String token = jsonDecode(prefs.getString("login_details"))["token"];
  }

  Future<RideModel> getRideToday() async {
    final prefs = await SharedPreferences.getInstance();
    String token = jsonDecode(prefs.getString("login_details"))["token"];
    String rideCode = prefs.getString('ride_code') != ''
        ? '?ride_code=${prefs.getString('ride_code')}'
        : '';
    String url = '$API_URL/api/conductor/today-sched/' + rideCode;
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body['ride']);
      if (body['error'] != null) {
        return null;
      } else {
        return RideModel.fromJson(jsonDecode(response.body));
      }
    } else {
      throw Exception('No Data');
    }
  }

  Future<RideModel> getRide(int rideId) async {
    final prefs = await SharedPreferences.getInstance();
    String token = jsonDecode(prefs.getString("login_details"))["token"];
    String rideCode = prefs.getString('ride_code') != ''
        ? '?ride_code=${prefs.getString('ride_code')}'
        : '';
    String url = '$API_URL/api/conductor/get-ride/$rideId/' + rideCode;
    return RideModel.fromJson(await API.getResponse(uri: url, token: token));
  }

  Future<void> rideDeparture(dynamic ride) async {
    final prefs = await SharedPreferences.getInstance();
    String token = jsonDecode(prefs.getString("login_details"))["token"];
    String url = '$API_URL/api/conductor/depart';
    final response =
        await API.postRequest(uri: url, token: token, requestModel: ride);
    prefs.setString('ride_code', response['ride_code'].toString());
  }

  Future<RideModel> rideArrival() async {
    final prefs = await SharedPreferences.getInstance();
    var json = jsonDecode(prefs.getString("login_details"));
    String token = json['token'];
    String url = '$API_URL/api/conductor/arrive';

    Map<String, dynamic> body = {
      'ride_code': prefs.getString('ride_code'),
    };

    await API.postRequest(uri: url, token: token, requestModel: body);

    return await getRideToday();
  }

  Future issueTicket(String bookingCode) async {
    var json = await getToken();
    String token = json['token'];

    String url = '$API_URL/api/conductor/issue-receipt/$bookingCode';
    final response = await API.getResponse(uri: url, token: token);
    return response;
  }

  Future getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('login_details'));
  }

  // Stream<RideModel> getRide() =>
  //     Stream.periodic(Duration(seconds: 5)).asyncMap((_) => getRideToday());
}
