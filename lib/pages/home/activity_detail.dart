import 'package:flutter/material.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/repositories/user_repository.dart';
import 'package:provider/provider.dart';
class ActivityDetailPage extends StatefulWidget {


  const ActivityDetailPage({Key key}) : super(key: key);
  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  @override
  Widget build(BuildContext context) {
   Activite activite= ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Wefly"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Provider.of<UserRepository>(context).doLogout();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50.0),
              child: Center(
                child: Text("${activite.titre}"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
