import 'package:flutter/material.dart';
import 'package:flutter_app/ProgressHud.dart';
import 'package:flutter_app/api/conductor_data_api.dart';
import 'package:flutter_app/model/ride_model.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/widgets/label_button.dart';
import 'package:flutter_app/widgets/logout_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:background_location/background_location.dart';
import 'package:firebase_database/firebase_database.dart';

import 'review_page.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage(this.ride);
  final RideModel ride;
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
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
    rideJson = {
      'ride_id': widget.ride.id,
    };
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return ProgressHud(child: schedulePage(context, widget.ride), inAsyncCall: isLoggingOut, opacity: 0.3);
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }

  Widget schedulePage(BuildContext context, RideModel ride) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
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
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(17.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text('Bus No: ${ride.bus}'),
                            Text('Departure Time: ${ride.scheduledTime}'),
                            Text('Driver: ${ride.driverName}'),
                            Text('Booked: ${ride.booked}'),
                            Text('Aboard: ${ride.aboard}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        for (var i in ride.route.terminals)
                          Container(
                            height: 30.0,
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: 30),
                              child: Row(
                                
                                children: [
                                  Icon(Icons.location_city),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(i.terminalName),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 150,
                      child: textButton(context, ride),
                    ),
                    ride.exists == 1 ? LabelButton(
                      liteText: 'Track again',
                      pressed: () => beginTrack(),
                    ) : Text(''),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton textButton(BuildContext context, RideModel ride) {
    bool forDeparture;
    if (ride.exists == 1)
      forDeparture = false;
    else
      forDeparture = true;

    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        minimumSize: Size(50.0, 20.0),
        backgroundColor: Theme.of(context).accentColor,
        shape: StadiumBorder(),
      ),
      onPressed: () {
        if (_isButtonDisabled) return null;

        if (forDeparture) {
          departure();
        } else {
          arrival();
        }
        setState(() {
          _isButtonDisabled = true;
          print(_isButtonDisabled);
        });
      },
      child: Text(
        forDeparture ? 'DEPART' : 'ARRIVE',
      ),
    );
  }

  departure() async {

    await beginTrack();
  }

  beginTrack() async 
  {
    BackgroundLocation.getPermissions(
      onGranted: () {
        // Start location service here or do something else
        BackgroundLocation.setAndroidNotification(
          title: 'Location Running',
          message:
              'Do not stop the trip until you reach your destination',
          icon: '@mipmap/ic_launcher',
        );

        BackgroundLocation.setAndroidConfiguration(1000);

        BackgroundLocation.startLocationService(
            distanceFilter: 20);

        BackgroundLocation.getLocationUpdates((location) {
          setState(() {
            latitude = location.latitude.toString();
            longitude = location.longitude.toString();

            databaseReference
                .child('ride${widget.ride.id}')
                .set({'lat': latitude, 'long': longitude});
          });
        });
        ConductorBloc().rideDeparture(rideJson).then((_) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        ));
      },
      onDenied: () {
        print('Please grant permission');
        // Show a message asking the user to reconsider or do something else
      },
    );
  }

  arrival() async {
    BackgroundLocation.stopLocationService();
    databaseReference.child('ride${widget.ride.id}').remove();
    ConductorBloc().rideArrival().then((value) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ReviewPage(widget.ride)),
      (Route<dynamic> route) => false,
    ));
  }
}

