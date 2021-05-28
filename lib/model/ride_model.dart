import 'dart:convert';

import 'package:flutter_app/model/route_model.dart';
import 'package:intl/intl.dart';

class RideModel {
  int id;
  RouteModel route;
  String bus;
  String scheduledTime;
  String departureTime;
  String arrivalTime;
  String rideDate;
  String driverName;
  int booked;
  int aboard;
  int exists;

  RideModel(
      {this.id,
      this.bus,
      this.scheduledTime,
      this.rideDate,
      this.route,
      this.driverName,
      this.booked,
      this.aboard,
      this.exists,
      this.arrivalTime,
      this.departureTime});

  factory RideModel.fromJson(Map<String, dynamic> json) {
    print(json['ride']);

    String formatTime(DateTime date) {
      return DateFormat.jms().format(date);
    }

    return RideModel(
      id: json['ride']['ride_id'],
      bus: json['ride']['bus_no'],
      scheduledTime: json['ride']['departure_time'],
      rideDate: json['ride']['ride_date'],
      route: RouteModel.fromJson(json['ride']['route']),
      driverName: json['ride']['bus']['driver']['employee_profile']
              ['last_name'] +
          ', ' +
          json['ride']['bus']['driver']['employee_profile']['first_name'],
      booked: json['booked'] != null ? int.parse(json['booked']) : null,
      aboard: json['aboard'] != null ? int.parse(json['aboard']) : null,
      exists: json['exists'] != null ? 1 : 0,
      departureTime:
          json['exists'] != null && json['exists']['departure'] != null
              ? formatTime(
                  DateTime.parse(json['exists']['departure']['time']).toLocal())
              : null,
      arrivalTime: json['exists'] != null && json['exists']['arrival'] != null
          ? formatTime(
              DateTime.parse(json['exists']['arrival']['time']).toLocal())
          : null,
    );
  }
}
