import 'package:weflyapps/models/models.dart';

class Activite {
  List<ImageFile> images;
  String titre;
  String dateDebut;
  String description;
  Sender creerPar;
  String dateFin;
  int id;
  String statutAct;
  String dateCreation;

  Activite(
      {this.images,
      this.titre,
      this.dateDebut,
      this.description,
      this.creerPar,
      this.dateFin,
      this.id,
      this.statutAct,
      this.dateCreation});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titre'] = this.titre;
    data['dateDebut'] = this.dateDebut;
    data['description'] = this.description;
    if (this.creerPar != null) {
      data['user'] = this.creerPar.toJson();
    }
    data['dateFin'] = this.dateFin;
    data['id'] = this.id;
    data['statut'] = this.statutAct;
    data['date_creation'] = this.dateCreation;
    return data;
  }
}
