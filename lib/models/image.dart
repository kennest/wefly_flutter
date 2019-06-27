class Image {
  String image;
  int id;
  int statutId;
  String dateCreation;

  Image({this.image, this.id, this.statutId, this.dateCreation});

  Image.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    statutId = json['statut_id'];
    dateCreation = json['date_creation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['statut_id'] = this.statutId;
    data['date_creation'] = this.dateCreation;
    return data;
  }
}