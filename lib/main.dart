import 'package:flutter/material.dart';
import 'package:weflyapps/pages/pages.dart';
import 'package:provider/provider.dart';
import 'package:weflyapps/repositories/data_repository.dart';
import 'package:weflyapps/repositories/user_repository.dart';
import 'package:weflyapps/services/auth_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:weflyapps/services/services.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<ConnectionStatus>.value(
            value: ConnectivityService().connectivityController.stream,
          ),
          ChangeNotifierProvider<UserRepository>.value(
            value: UserRepository(),
          ),
          ProxyProvider<UserRepository, DataRepository>(
            builder: (context, user, data) => DataRepository(user),
          ),
        ],
        child: MaterialApp(
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
          },
        ));
  }
}
