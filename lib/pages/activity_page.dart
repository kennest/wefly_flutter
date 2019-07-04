import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/repositories/data_repository.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<Activite> activities;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activities = List();
  }

  @override
  Widget build(BuildContext context) {
    activities = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Vous avez ${activities.length} Activités"),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: activities.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Image.file(
                        File(activities[index].images[0].local_image)),
                    title: Text("${activities[index].titre}"),
                    subtitle: Text("${activities[index].description}"),
                    onTap: () {
                      Navigator.pushNamed(context, '/activity-detail',
                          arguments: activities[index]);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
