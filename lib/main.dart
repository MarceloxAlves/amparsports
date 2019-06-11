import 'package:amparsports/jogospage.dart';
import 'package:amparsports/preloginpage.dart';
import 'package:flutter/material.dart';
import 'package:amparsports/homepage.dart';
import 'package:amparsports/loginpage.dart';
import 'package:amparsports/signup.dart';

import 'home-visitante-page.dart';

void main() => runApp(FireAuth());

class FireAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "Ampar Sports",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PreLoginPage(),
      routes: <String, WidgetBuilder>{
        "/prelogin": (BuildContext context) => new PreLoginPage(),
        "/home-visitante": (BuildContext context) => new HomeVisitantePage(),
        "/userpage": (BuildContext context) => new Page(),
        "/loginpage": (BuildContext context) => new LoginPage(),
        "/signup": (BuildContext context) => new SignUpPage(),
        "/jogos": (BuildContext context) => new JogosPage()
      },
    );
  }
}
