import 'package:flutter/material.dart';
import 'package:weflyapps/pages/home/activity_detail.dart';
import 'package:weflyapps/pages/pages.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.primaries[9],
          fontFamily: 'Arial-Rounded',
          platform: TargetPlatform.android,
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.green[600],
              textTheme: ButtonTextTheme.primary,
              splashColor: Colors.green[800]),
          appBarTheme: AppBarTheme(
              color: Colors.white,
              textTheme: TextTheme(
                  title: TextStyle(color: Colors.green[800]),
                  body1: TextStyle(color: Colors.green[800])),
              actionsIconTheme: IconThemeData(color: Colors.green[800]),
              iconTheme: IconThemeData(color: Colors.green[800]))),
      routes: {
        '/': (context) => SplashPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/alert': (context) => AlertPage(),
        '/activity-detail': (context) => ActivityDetailPage(),
        '/activity-page': (context) => ActivityPage(),
        '/new-alert': (context) => NewAlertPage(),
      },
    );
  }
}
