import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _getPermissions();
    _checkToken();
    //Isolate.spawn(_checkToken(), "message");
  }

  _getPermissions() async {
    await Future.delayed(Duration(seconds: 2));
    await PermissionHandler().requestPermissions([
      PermissionGroup.storage,
      PermissionGroup.microphone,
      PermissionGroup.location,
      PermissionGroup.camera
    ]);
  }

  _checkToken() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("token")) {
      print('Token -> ${prefs.get("token")}');
      Navigator.pushNamed(context, '/home');
    } else {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green[700], Colors.green[300], Colors.green[100]],
              tileMode: TileMode.mirror)),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/logo.png',
            height: 170.0,
            width: 170.0,
          ),
          CircularProgressIndicator(),
        ],
      )),
    ));
  }
}
