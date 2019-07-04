import 'dart:io';
import 'dart:ui' as prefix1;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/repositories/data_repository.dart';
import 'package:weflyapps/repositories/data_repository.dart' as prefix0;
import 'package:weflyapps/repositories/user_repository.dart';
import 'package:weflyapps/services/data_service.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:path/path.dart' as p;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  DataRepository dataRepository;
  UserRepository userRepository;
  var currentIndex = 0;
  DataService dataService;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    dataRepository = DataRepository();
    getData();
  }

  getData() async {
      await dataRepository.fetchReceivedAlerts();
      await dataRepository.fetchActivities();
  }

  @override
  Widget build(BuildContext context) {
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
      drawer: Drawer(
          elevation: 5.0,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: Text("Profile"),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text("Parametres"),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text("Quitter"),
                      onTap: () {
                        SystemNavigator.pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          )),
      body: ChangeNotifierProvider<DataRepository>.value(
        value: dataRepository,
        child: Consumer(builder: (context, DataRepository data, child) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                  child: Text(
                    "Bonjour Oulai Kennest.",
                    style: TextStyle(color: Colors.green[800], fontSize: 30.0),
                  ),
                ),
                //Graph dernieres activites
                lastActivity(data.uncompleted),
                SizedBox(
                  height: 8.0,
                ),
                //Graph activites accomplis
                activitiesListView(data),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Vos alertes récentes",
                        style:
                            TextStyle(color: Colors.green[800], fontSize: 18.0),
                      ),
                      MaterialButton(
                        child: Text(
                          "Voir tout..",
                        ),
                        onPressed: () {

                        },
                      )
                    ],
                  ),
                ),
                //Alertes recentes listview
                alertListView(data.received)
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          IconButton(
            color: Colors.green[800],
            icon: Icon(Icons.home),
            onPressed: () {},
          ),
          IconButton(
            color: Colors.green[500],
            icon: Icon(Icons.send),
            onPressed: () {},
          ),
          IconButton(
            color: Colors.green[500],
            icon: Icon(Icons.receipt),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "new",
        backgroundColor: Colors.green[800],
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  //Print last activity details
  lastActivity(List<Activite> data) {
      return data.length > 0? Container(
          margin: EdgeInsets.all(8.0),
          height: 170.0,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/work.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.srcATop)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: InkWell(
              highlightColor: Colors.green,
              splashColor: Colors.green[800],
              onTap: () {},
              child: Wrap(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 15.0, 35.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    data.last.titre.length>11?"${data.last.titre.substring(0, 12)}":"${data.last.titre}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 25.0, 65.0, 0.0),
                            child: Text(
                              "${data.last.description.substring(0, 12)}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 0.0),
                            child: Text(
                              "Du ${data.last.dateDebut} au ${data.last.dateFin}",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(45.0, 50.0, 0.0, 0.0),
                          child: FloatingActionButton(
                            heroTag: "alt",
                            backgroundColor: Colors.white,
                            onPressed: () {
                              Navigator.pushNamed(context, '/activity-detail',
                                  arguments: data.last);
                            },
                            child: Icon(
                              Icons.build,
                              color: Colors.green[800],
                            ),
                          ))
                    ],
                  ),
                ],
              ))):
     CircularProgressIndicator();
  }

  //received alerts listview
  alertListView(List<ReceivedAlert> received) {
    return received.length == 0
        ? CircularProgressIndicator()
        : Container(
            height: 200.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: received.length,
              itemBuilder: (BuildContext context, int index) {
                String ext = p.extension(received[index]
                    .alerte
                    .properties
                    .pieceJoinAlerte[1]
                    .remote_piece);
                print('Ext 0-> $ext');
                if (ext == ".jpg" || ext == ".png" || ext == ".jpeg") {
                  print('Ext 1-> $ext');

                  return Container(
                    margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                            image: File(received[index]
                                        .alerte
                                        .properties
                                        .pieceJoinAlerte[1]
                                        .local_piece)
                                    .existsSync()
                                ? FileImage(File(received[index]
                                    .alerte
                                    .properties
                                    .pieceJoinAlerte[1]
                                    .local_piece))
                                : NetworkImage(received[index]
                                    .alerte
                                    .properties
                                    .pieceJoinAlerte[1]
                                    .remote_piece),
                            fit: BoxFit.cover)),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 20.0,
                          top: 150.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "${received[index].alerte.properties.categorie.nom}",
                                style: TextStyle(color: Colors.white),
                              ),
                              File(received[index]
                                          .alerte
                                          .properties
                                          .categorie
                                          .local_icone)
                                      .existsSync()
                                  ? Image.file(
                                      File(received[index]
                                          .alerte
                                          .properties
                                          .categorie
                                          .local_icone),
                                      height: 35.0,
                                    )
                                  : Image.network(
                                      received[index]
                                          .alerte
                                          .properties
                                          .categorie
                                          .remote_icone,
                                      height: 35.0,
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
  }

  //Activities listview
  activitiesListView(DataRepository data) {
    return Container(
        margin: EdgeInsets.all(5.0),
        height: 140.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: Colors.green.withAlpha(1)),
        child: Wrap(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 15.0, 10.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          Text("Vos activites de la journée",
                              style: TextStyle(
                                  color: Colors.green[800],
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 20.0, 0.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "${data.completed.length} sur ${data.activities.length} completés",
                            style: TextStyle(color: Colors.green),
                          ),
                          FlatButton(
                            child: Text("Voir tout..."),
                            onPressed: () {
                              Navigator.pushNamed(context, '/activity-page',arguments: data.activities);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                    child: CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 5.0,
                      percent: data.percent,
                      center: new Text("${(data.percent) * 100}%"),
                      progressColor: Colors.green,
                    ))
              ],
            ),
          ],
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //Provider.of<DataRepository>(context).dispose();
  }
}
