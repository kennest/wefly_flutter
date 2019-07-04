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
  UserRepository userRepository;
  File _image;
  List<File> _listImages = [];
  Activite _activite;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    _activite = Activite();
  }

  @override
  Widget build(BuildContext context) {
    Activite activite = ModalRoute.of(context).settings.arguments;
    _activite = activite;
    print("Act ${activite.id} image size ->${_activite.images.length}");
    return Scaffold(
      appBar: AppBar(
        title: Text("${_activite.titre}"),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            height: 200.0,
            child: Container(
              child: _activite.images.length > 0
                  ? ListView.builder(
                      itemCount: _activite.images.length,
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
                                          ? FileImage(File(_activite
                                              .images[index].local_image))
                                          : NetworkImage(_activite
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
              title: Text("${_activite.creerPar.lastName}"),
              subtitle: Text("${_activite.creerPar.username}"),
            ),
          ),
          Divider(),
          Container(
            child: ListTile(
              leading: Icon(
                Icons.timer,
                size: 35.0,
              ),
              title: Text("Du ${_activite.dateDebut}"),
              subtitle: Text("Au ${_activite.dateFin}"),
            ),
          ),
          Divider(),
          Container(
            child: ListTile(
              leading: Icon(
                Icons.description,
                size: 35.0,
              ),
              title: Text("${_activite.description}"),
            ),
          ),
          Divider(),
          Container(
            child: ListTile(
              leading: Icon(
                Icons.flag,
                size: 35.0,
              ),
              title: Text("${_activite.statutAct}"),
            ),
          ),
          Divider(),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        heroTag: "status",
        child: _activite.statutAct == "Achevé"
            ? Icon(Icons.check)
            : Icon(Icons.sync),
        onPressed: () {
          if (_activite.statutAct == "En cours" ||
              _activite.statutAct == "Création") {
            getImage();
          } else {
            setState(() {
              toggleStatus(_activite);
            });
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
        _activite.images.add(imageFile);
      }
    }

    if (_listImages.length > 0) {
      setState(() {
        toggleStatus(_activite);
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
      Provider.of<DataRepository>(context).updateActivite(send);
    }
  }

  toggleStatus(Activite a) {
    if (a.statutAct == "En cours" || a.statutAct == "Création") {
      a.statutAct = "Achevé";
    } else {
      a.statutAct = "En cours";
    }
  }
}
