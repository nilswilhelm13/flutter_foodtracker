import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodtracker/config/http_config.dart';
import 'package:flutter_foodtracker/widgets/generic_error_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_foodtracker/screens/dashboard.dart';
import 'dart:convert';

import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  String errorString = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          Text(
            "Login",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          buildContainer(
              Icons.mail, "email", (value) => {email = value}, false),
          buildContainer(
              Icons.lock, "password", (value) => {password = value}, true),
          Spacer(),
          ElevatedButton(
              onPressed: () => login(context),
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  textStyle: TextStyle(fontSize: 18))),
          Text(errorString),
          Spacer(),
        ],
      ),
    ));
  }

  Container buildContainer(
      IconData iconData, String hint, Function(String) fun, bool obscureText) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(width: 1)),
      child: ListTile(
        leading: Icon(iconData),
        title: TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          onChanged: (content) => {email = content},
        ),
      ),
    );
  }

  void login(BuildContext ctx) async {
    if (password == '' || email == '') return;
    var url = Uri.https(HttpConfig.baseUrl, 'login');
    try {
      final response = await http.post(url,
          body: json.encode({'email': email, 'password': password}));
      if (response.statusCode == 200) {
        // obtain shared preferences
        final prefs = await SharedPreferences.getInstance();
        var loginData = json.decode(response.body) as Map<String, dynamic>;

        // set value
        prefs.setString('token', loginData['token']);
        prefs.setString('userId', loginData['userId']);
        Navigator.of(context).pushReplacementNamed(Dashboard.routeName);
      }
      setState(() {
        errorString = response.statusCode.toString();
      });
    } catch (error) {
      showDialog(context: context, builder: (ctx) => GenericErrorModal(error));
    }
  }
}
