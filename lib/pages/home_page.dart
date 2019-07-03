import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
  var currentIndex = 0;
  DataService dataService;

  @override
  void initState() {
    super.initState();
    dataRepository = DataRepository();
    getData();
  }

  getData() async {
    await dataRepository.fetchReceivedAlerts();
    await dataRepository.fetchActivities();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => dataRepository,
      child: Consumer(builder: (context, DataRepository data, _) {
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
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  "Bonjour Oulai Kennest.",
                  style: TextStyle(color: Colors.green[800], fontSize: 40.0),
                ),
                //Graph dernieres alertes
                Container(
                    margin: EdgeInsets.all(8.0),
                    height: 170.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/bg.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.srcATop)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Wrap(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(8.0, 15.0, 10.0, 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      CircleAvatar(
                                        child: Icon(Icons.add_alert),
                                      ),
                                      Text("Feu de Brousse",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 25.0, 20.0, 0.0),
                                  child: Text(
                                    "Description of the last alert",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.fromLTRB(45.0, 50.0, 0.0, 0.0),
                                child: FloatingActionButton(
                                  heroTag: "alt",
                                  backgroundColor: Colors.white,
                                  onPressed: () {},
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(color: Colors.green[800]),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    )),
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
                        "Alertes récentes",
                        style:
                            TextStyle(color: Colors.green[800], fontSize: 18.0),
                      ),
                      MaterialButton(
                        child: Text(
                          "Voir tout..",
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
                //Alertes recentes listview
                alertListView(data.received)
              ],
            ),
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
      }),
    );
  }


  //received alerts listview
  alertListView(List<ReceivedAlert> received) {
    print('Started Build->');
    return  received.length==0? CircularProgressIndicator():
        Container(
          height: 200.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: received.length,
            itemBuilder: (BuildContext context, int index) {
              String ext =
              p.extension(
                  received[index].alerte.properties.pieceJoinAlerte[1]
                      .piece);
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
                          image: NetworkImage(
                              received[index].alerte.properties
                                  .pieceJoinAlerte[1].piece),
                          fit: BoxFit.cover)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 130.0,
                        top:130.0,
                        child: Image.network(received[index].alerte.properties.categorie.icone,height: 60.0,),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        )
            ;
  }

  //Activities listview
  activitiesListView(DataRepository data){
    return Container(
        margin: EdgeInsets.all(5.0),
        height: 140.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white),
        child: Wrap(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      EdgeInsets.fromLTRB(8.0, 15.0, 10.0, 0.0),
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
                      padding:
                      EdgeInsets.fromLTRB(8.0, 20.0, 0.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "${data.completed.length} sur ${data.activities.length} completés",
                            style: TextStyle(color: Colors.green),
                          ),
                          FlatButton(
                            child: Text("Voir tout..."),
                            onPressed: (){},
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                    padding:
                    EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                    child: CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 5.0,
                      percent: data.percent,
                      center: new Text("${(data.percent)*100}%"),
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
