class Alert{
  int id;
  String titre;
  String contenu;
  int categoryId;
  String destinataires;
  String longitude;
  String latitude;
  String dateAlerte;

  Map<String,dynamic> toJson(){
     final Map<String, dynamic> data = new Map<String, dynamic>();
     data['titre']=this.titre;
     data['categorie']=this.categoryId;
     data['destinataires']=this.destinataires;
     data['contenu']=this.contenu;
     data['longitude']=this.longitude;
     data['latitude']=this.latitude;
     data['date_alerte']=this.dateAlerte;
     return data;
  }
}