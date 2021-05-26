import 'dart:convert';

import 'package:flutter_app/model/route_model.dart';

class EmployeeRideModel {
  String rideCode;
  String departureTime;
  String arrivalTime;

  EmployeeRideModel({this.rideCode, this.departureTime, this.arrivalTime});

  factory EmployeeRideModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return EmployeeRideModel(
      rideCode: json['ride_code'],
      departureTime: json['departure_time'],
      arrivalTime: json['arrival_time'],
    );
  }
}
