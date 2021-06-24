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
      appBar: AppBar(
        title: Text('Login'),
    ),
      body: Center(
        child: Column(
          children: [
            Text("email"),
            TextField(
                onChanged: (content) => {
                  email = content
                },
            ),
            Text("password"),
            TextField(
              onChanged: (content) => {
                password = content
              },
            ),
            TextButton(onPressed: () => login(context), child: Text("Login"), ),
            Text(errorString),
          ],
        ),
      )
    );
  }
  void login(BuildContext ctx) async{
    if (password == '' || email == '')return;
    var url =
    Uri.https(HttpConfig.baseUrl, 'login');
    try {
      final response = await http.post(url,body: json.encode({
        'email': email,
        'password': password
      }));
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
