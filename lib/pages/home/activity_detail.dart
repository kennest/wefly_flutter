import 'dart:io';
import 'package:weflyapps/models/send/activite.dart' as toSend;
import 'package:flutter/material.dart';
import 'package:weflyapps/models/models.dart';
import 'package:weflyapps/repositories/data_repository.dart';
import 'package:weflyapps/repositories/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ActivityDetailPage extends StatefulWidget {
  const ActivityDetailPage({Key key}) : super(key: key);

  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  File _image;
  List<File> _listImages = [];
  Activite activite;
  Activite _activite;

  @override
  void initState() {
    super.initState();
    activite = Activite();
    _activite = Activite();
  }

  @override
  Widget build(BuildContext context) {
    activite = ModalRoute.of(context).settings.arguments;
    _activite = activite;
    print("Act ${activite.id} image size ->${activite.images.length}");
    return Scaffold(
      appBar: AppBar(
        title: Text("${activite.titre}"),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            height: 200.0,
            child: Container(
              child: activite.images.length > 0
                  ? ListView.builder(
                      itemCount: activite.images.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 200.0,
                          width: 200.0,
                          margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      File(activite.images[index].local_image)
                                              .existsSync()
                                          ? FileImage(File(activite
                                              .images[index].local_image))
                                          : NetworkImage(activite
                                              .images[index].remote_image))),
                        );
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Center(
                          child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.note,
                            size: 50.0,
                            color: Colors.green[400],
                          ),
                          Text("No Pictures")
                        ],
                      )),
                    ),
            ),
          ),
          Divider(),
          Container(
            child: ListTile(
              leading: Icon(
                Icons.supervisor_account,
                size: 35.0,
              ),
              title: Text("${activite.creerPar.lastName}"),
              subtitle: Text("${activite.creerPar.username}"),
            ),
          ),
          Divider(),
          Container(
            child: ListTile(
              leading: Icon(
                Icons.timer,
                size: 35.0,
              ),
              title: Text("Du ${activite.dateDebut}"),
              subtitle: Text("Au ${activite.dateFin}"),
            ),
          ),
          Divider(),
          Container(
            child: ListTile(
              leading: Icon(
                Icons.description,
                size: 35.0,
              ),
              title: Text("${activite.description}"),
            ),
          ),
          Divider(),
          Container(
            child: ListTile(
              leading: Icon(
                Icons.flag,
                size: 35.0,
              ),
              title: Text("${activite.statutAct}"),
            ),
          ),
          Divider(),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        heroTag: "status",
        child: activite.statutAct == "Achevé"
            ? Icon(Icons.check)
            : Icon(Icons.sync),
        onPressed: () {
          if (activite.statutAct == "En cours" ||
              activite.statutAct == "Création") {
            getImage();
          } else {
            sendData();
          }
        },
      ),
    );
  }

  //Si le statut es acheve alors on prend une image pr l'attester
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });

    if (_image != null) {
      if (_image.existsSync()) {
        ImageFile imageFile = ImageFile();
        imageFile.local_image = _image.path;
        _listImages.add(_image);
        activite.images.add(imageFile);
        _activite.images.clear();
        _activite.images.add(imageFile);
      }
    }

    if (_listImages.length > 0) {
      sendData();
    }
  }

  sendData() async {
    setState(() {
      toggleStatus();
    });

    toSend.Activite send = toSend.Activite(
        id: _activite.id,
        images: _activite.images,
        dateDebut: _activite.dateDebut,
        creerPar: _activite.creerPar,
        dateCreation: _activite.dateCreation,
        dateFin: _activite.dateFin,
        description: _activite.description,
        statutAct: _activite.statutAct,
        titre: _activite.titre);

    bool updated =
        await Provider.of<DataRepository>(context).updateActivite(send);
    if (updated) {
      Provider.of<DataRepository>(context).uncompleted.map((n) {
        if (n.id == activite.id) {
          n.statutAct = activite.statutAct;
        }
      });
    }
  }

  toggleStatus() {
    if (activite.statutAct == "En cours" || activite.statutAct == "Création") {
      activite.statutAct = "Achevé";
      _activite.statutAct = "Achevé";
    } else {
      activite.statutAct = "En cours";
      _activite.statutAct = "En cours";
    }
  }
}
