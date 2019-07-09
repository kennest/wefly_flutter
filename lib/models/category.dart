class Category {
  int entreprise;
  String remote_icone;
  String local_icone;
  int id;
  String nom;
  String dateDeCreation;

  Category(
      {this.entreprise,
      this.remote_icone,
      this.id,
      this.nom,
      this.dateDeCreation,
      this.local_icone});

  Category.fromJson(Map<String, dynamic> json) {
    entreprise = json['entreprise'];
    if(json['local_icone']!=null){
      local_icone = json['local_icone'];
    }
    remote_icone = json['icone'];
    id = json['id'];
    nom = json['nom'];
    dateDeCreation = json['date_de_creation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entreprise'] = this.entreprise;
    data['icone'] = this.remote_icone;
    data['local_icone'] = this.local_icone;
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['date_de_creation'] = this.dateDeCreation;
    return data;
  }
}
