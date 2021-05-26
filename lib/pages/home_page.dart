import 'package:flutter/material.dart';
import 'package:flutter_app/ProgressHud.dart';
import 'package:flutter_app/api/conductor_data_api.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../model/ride_model.dart';
import 'package:flutter_app/widgets/reusable_card.dart';
import 'package:flutter_app/widgets/logout_button.dart';
import 'package:google_fonts/google_fonts.dart';

import 'scan_qr.dart';
import 'view_schedule.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggingOut = false;

  setLoggingOut(value) {
    isLoggingOut = value;
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(child: homePage(context), inAsyncCall: isLoggingOut, opacity: 0.3);
  }

  Widget homePage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0.0,
        title: Text(
          "Home",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Welcome!'),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ReusableCard(
                      cardChild: ScheduleTodayFutureBuilder(),
                    ),
                    // ReusableCard(
                    //   cardChild: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Text('Next Schedule'),
                    //       SizedBox(
                    //         height: 10.0,
                    //       ),
                    //       Text('Date: 2021/05/15'),
                    //       Text('Route: Dagupan - Cubao'),
                    //       Text('Time: 13:00'),
                    //       SizedBox(height: 10.0),
                    //       TextButton(
                    //         style: TextButton.styleFrom(
                    //           primary: Colors.white,
                    //           minimumSize: Size(195, 20),
                    //           backgroundColor: Theme.of(context).accentColor,
                    //           shape: StadiumBorder(),
                    //         ),
                    //         onPressed: () => {},
                    //         child: Text(
                    //           'VIEW ALL',
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    ReusableCard(
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Confirm Passenger and send Receipt'),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              minimumSize: Size(195, 20),
                              backgroundColor: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                            ),
                            onPressed: () => {
                               Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ScanPage()),
                              )
                            },
                            child: Text(
                              'SCAN QR CODE',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleTodayFutureBuilder extends StatefulWidget {
  const ScheduleTodayFutureBuilder({Key key}) : super(key: key);

  @override
  _ScheduleTodayFutureBuilderState createState() => _ScheduleTodayFutureBuilderState();
}

class _ScheduleTodayFutureBuilderState extends State<ScheduleTodayFutureBuilder> {
  ConductorBloc con = ConductorBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: con.getRideToday(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          else if (snapshot.hasData) {
            return _contain(snapshot);
          } else if (snapshot.hasError) {
            return Text('Please connect to the internet!');
          } else {
            return Text('No rides today');
          }
        });
  }

  Widget _contain(AsyncSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Schedule Today'),
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Route Name: ${snapshot.data.route.routeName}',
        ),
        Text(
          'Departure Time: ${snapshot.data.scheduledTime}',
        ),
        if (snapshot.data.exists == 1) Text('On Route'),
        SizedBox(
          height: 10.0,
        ),
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
            minimumSize: Size(195, 20),
            backgroundColor: Theme.of(context).accentColor,
            shape: StadiumBorder(),
          ),
          onPressed: () => {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => SchedulePage(snapshot.data))
            )
          },
          child: Text(
            'VIEW',
          ),
        ),
      ],
    );
  }
}
