import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api/login_api_service.dart';
import '../model/login_model.dart';
import '../ProgressHud.dart';
import '../shared_service_login.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  LoginRequestModel loginRequestModel;
  bool isApiCallProcess;

  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
    isApiCallProcess = false;
  }

  Widget build(BuildContext context) {
    return ProgressHud(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  child: Form(
                    key: globalFormKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "BMIS Conductor",
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue[900],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          initialValue: loginRequestModel.email,
                          onSaved: (input) => loginRequestModel.email = input,
                          validator: (input) => !input.contains("@")
                              ? "Please enter email address"
                              : null,
                          decoration: new InputDecoration(
                              hintText: "Email Address",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.2),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).accentColor,
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        new TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue: loginRequestModel.password,
                          onSaved: (input) =>
                              loginRequestModel.password = input,
                          validator: (input) => input.length < 7
                              ? "Password must have more than 7 characters"
                              : null,
                          obscureText: hidePassword,
                          decoration: new InputDecoration(
                              hintText: "Password",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.2),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).accentColor,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.4),
                                icon: Icon(hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              )),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            minimumSize: Size(195, 40),
                            backgroundColor: Theme.of(context).accentColor,
                            shape: StadiumBorder(),
                          ),
                          onPressed: () {
                            if (validateAndSave()) {
                              setState(() {
                                isApiCallProcess = true;
                              });
                              APIService apiService = new APIService();
                              apiService
                                  .login(loginRequestModel)
                                  .catchError((e) {
                                showDialog(
                                    context: context,
                                    builder: (value) {
                                      return AlertDialog(
                                        title: Text('Error!'),
                                        content: Text('$e'),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () => {
                                                    Navigator.pop(context),
                                                  },
                                              child: Text('Ok')),
                                        ],
                                      );
                                    });
                              }).then((value) {
                                setState(() {
                                  isApiCallProcess = false;
                                });
                                if (value.token.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Login Successful")));

                                  SharedService.setLoginDetails(value);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (Route<dynamic> route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Login Failed! Please Check Your Credentials")));
                                }
                              });
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
