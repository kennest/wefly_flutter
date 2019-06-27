import 'package:flutter/material.dart';
import 'package:weflyapps/pages/pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     routes: {
       '/': (context) => SplashPage(),
       '/home': (context) => HomePage(),
     },
    );
  }
}

