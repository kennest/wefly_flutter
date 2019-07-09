import 'models.dart';

class Employee {
  String reference;
  int entreprise;
  int role;
  int superieur;
  UserFonction fonction;
  int adresse;
  String photo;
  String telephone;
  int id;
  String createAt;
  User user;
  bool delete;

  Employee(
      {this.reference,
      this.entreprise,
      this.role,
      this.superieur,
      this.fonction,
      this.adresse,
      this.photo,
      this.telephone,
      this.id,
      this.createAt,
      this.user,
      this.delete});

  Employee.fromJson(Map<String, dynamic> json) {
    reference = json['reference'];
    entreprise = json['entreprise'];
    role = json['role'];
    superieur = json['superieur'];
    fonction = json['fonction'] != null
        ? new UserFonction.fromJson(json['fonction'])
        : null;
    adresse = json['adresse'];
    photo = json['photo'];
    telephone = json['telephone'];
    id = json['id'];
    createAt = json['create_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    delete = json['delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reference'] = this.reference;
    data['entreprise'] = this.entreprise;
    data['role'] = this.role;
    data['superieur'] = this.superieur;
    if (this.fonction != null) {
      data['fonction'] = this.fonction.toJson();
    }
    data['adresse'] = this.adresse;
    data['photo'] = this.photo;
    data['telephone'] = this.telephone;
    data['id'] = this.id;
    data['create_at'] = this.createAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['delete'] = this.delete;
    return data;
  }
}

class UserFonction {
  int owner;
  int entreprise;
  int id;
  String createAt;
  String nom;
  bool delete;

  UserFonction(
      {this.owner,
      this.entreprise,
      this.id,
      this.createAt,
      this.nom,
      this.delete});

  UserFonction.fromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    entreprise = json['entreprise'];
    id = json['id'];
    createAt = json['create_at'];
    nom = json['nom'];
    delete = json['delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner'] = this.owner;
    data['entreprise'] = this.entreprise;
    data['id'] = this.id;
    data['create_at'] = this.createAt;
    data['nom'] = this.nom;
    data['delete'] = this.delete;
    return data;
  }
}
