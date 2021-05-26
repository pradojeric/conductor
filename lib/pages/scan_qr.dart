import 'package:flutter/material.dart';
import 'package:flutter_app/api/conductor_data_api.dart';
import 'package:flutter_app/widgets/logout_button.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ProgressHud.dart';
import 'home_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
        backgroundColor: Colors.blue[900],
        elevation: 0.0,
        title: Text(
          "Give Ticket",
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: Size(195, 20),
                    backgroundColor: Theme.of(context).accentColor,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () => scanQrCode(),
                  child: Text(
                    'SCAN QR CODE',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> scanQrCode() async {
    final qrCode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.QR,
    );

    if (!mounted) return;
    if(qrCode != '-1'){
      ConductorBloc().issueTicket(qrCode).then((value){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Ticket issued!"),
            ),
          );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
      });
    }
    
    print(qrCode);
    return;
  }
}