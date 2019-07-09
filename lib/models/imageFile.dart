class ImageFile {
  String remote_image;
  String local_image;
  int id;
  int statutId;
  String dateCreation;

  ImageFile({this.remote_image, this.id, this.statutId, this.dateCreation});

  ImageFile.fromJson(Map<String, dynamic> json) {
    remote_image = json['image'];
    if (json['local_image'] != null) {
      local_image = json['local_image'];
    }
    id = json['id'];
    statutId = json['statut_id'];
    dateCreation = json['date_creation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.remote_image;
    data['local_image'] = this.local_image;
    data['id'] = this.id;
    data['statut_id'] = this.statutId;
    data['date_creation'] = this.dateCreation;
    return data;
  }
}
