import 'package:google_fonts/google_fonts.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'package:flutter/material.dart';
import 'shared_service_login.dart';

Widget _defaultHome = LoginPage();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool _isLoggedIn = await SharedService.isLoggedIn();

  if (_isLoggedIn) {
    _defaultHome = new HomePage();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        accentColor: Colors.blue[900],
      ),
      home: _defaultHome,
      // routes: <String, WidgetBuilder>{
      //   '/home': (BuildContext context) => HomePage(),
      //   '/login': (BuildContext context) => LoginPage(),
      //   '/schedule': (BuildContext context) => SchedulePage(),
      //   '/review': (BuildContext context) => ReviewPage(),
      //   '/scan': (BuildContext context) => ScanPage(),
      // },
    );
  }
}
