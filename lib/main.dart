import 'package:flutter/material.dart';
import 'package:weflyapps/pages/pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.primaries[9],
        fontFamily: 'Arial-Rounded',
        platform: TargetPlatform.iOS,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.green[600],
          textTheme: ButtonTextTheme.primary,
          splashColor: Colors.green[800]
        ),
        appBarTheme: AppBarTheme(
          color: Colors.primaries[9]
        )
      ),
     routes: {
       '/': (context) => SplashPage(),
       '/home': (context) => HomePage(),
       '/login': (context) => LoginPage(),
       '/alert': (context) => AlertPage(),
     },
    );
  }
}

