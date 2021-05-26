import 'package:flutter/material.dart';
import 'package:flutter_app/api/conductor_data_api.dart';
import 'package:flutter_app/model/ride_model.dart';
import 'package:flutter_app/widgets/logout_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ProgressHud.dart';
import 'home_page.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage(this.ride);
  final RideModel ride;
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool isLoggingOut;

  setLoggingOut(value) {
    isLoggingOut = value;
  }

  @override
  void initState() {
    super.initState();
    isLoggingOut = false;
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(child: schedulePage(context, widget.ride), inAsyncCall: isLoggingOut, opacity: 0.3);
  }

  Widget schedulePage(BuildContext context, RideModel ride) {
    ConductorBloc con = ConductorBloc();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0.0,
        title: Text(
          "Review",
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.all(50.0),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(17.0)),
                child: FutureBuilder(
                  future: con.getRide(ride.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    else if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text('Bus No: ${snapshot.data.bus}'),
                          Text('Time of departure: ${snapshot.data.departureTime}'),
                          Text('Time of arrival: ${snapshot.data.arrivalTime}'),
                          Text('Total booked: ${snapshot.data.booked}'),
                          Text('Total aboarded: ${snapshot.data.aboard}'),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              minimumSize: Size(100.0, 20.0),
                              backgroundColor: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                            ),
                            onPressed: () async {
                              var prefs = await SharedPreferences.getInstance();
                              await prefs.remove('ride_code');
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              'OK',
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text('Error');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
