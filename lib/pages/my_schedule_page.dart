import 'package:flutter/material.dart';
import 'package:flutter_app/model/ride_model.dart';
import 'package:flutter_app/widgets/logout_button.dart';
import 'package:flutter_app/widgets/reusable_card.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_page.dart';

class MySchedulesPage extends StatefulWidget {
  MySchedulesPage(this.rides);
  List<RideModel> rides;

  @override
  _MySchedulesPageState createState() => _MySchedulesPageState();
}

class _MySchedulesPageState extends State<MySchedulesPage> {
  bool isLoggingOut;
  bool _isButtonDisabled;
  String latitude = '';
  String longitude = '';
  var lat, long;
  Map<String, dynamic> rideJson;

  setLoggingOut(value) {
    isLoggingOut = value;
  }

  @override
  void initState() {
    super.initState();
    isLoggingOut = false;
    _isButtonDisabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            )
          },
        ),
        backgroundColor: Colors.blue[900],
        elevation: 0.0,
        title: Text(
          "Schedule",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          LogoutButton(setLoggingOut),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: widget.rides.length,
            itemBuilder: (context, index) {
              return ReusableCard(
                cardChild: _container(widget.rides[index]),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _container(RideModel ride) {
    return Column(
      children: [
        Text(
          'Date: ${ride.rideDate}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('Route Name: ${ride.route.routeName}'),
        Text('Time: ${ride.scheduledTime}'),
        Text('Bus No: ${ride.bus}'),
        Text('Driver: ${ride.driverName}'),
      ],
    );
  }
}
