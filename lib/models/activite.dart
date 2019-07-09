import 'models.dart';

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

  Activite.fromJson(Map<String, dynamic> json) {
    if (json['image'] != null) {
      images = new List<ImageFile>();
      (json['image'] as List).forEach((v) {
        images.add(new ImageFile.fromJson(v));
      });
    }
    titre = json['titre'];
    dateDebut = json['date_debut'];
    description = json['description'];
    creerPar = json['creer_par'] != null
        ? new Sender.fromJson(json['creer_par'])
        : null;
    dateFin = json['date_fin'];
    id = json['id'];
    statutAct = json['statut_act'];
    dateCreation = json['date_creation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.images != null) {
      data['image'] = this.images.map((v) => v.toJson()).toList();
    }
    data['titre'] = this.titre;
    data['date_debut'] = this.dateDebut;
    data['description'] = this.description;
    if (this.creerPar != null) {
      data['creer_par'] = this.creerPar.toJson();
    }
    data['date_fin'] = this.dateFin;
    data['id'] = this.id;
    data['statut_act'] = this.statutAct;
    data['date_creation'] = this.dateCreation;
    return data;
  }
}
