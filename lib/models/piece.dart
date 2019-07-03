class Piece{
  String remote_piece;
  String local_piece;
  int id;
  int email;
  int alerte;

  Piece({this.remote_piece, this.id, this.email, this.alerte});

  Piece.fromJson(Map<String, dynamic> json) {
    remote_piece = json['piece'];
    id = json['id'];
    email = json['email'];
    alerte = json['alerte'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['piece'] = this.remote_piece;
    data['id'] = this.id;
    data['email'] = this.email;
    data['alerte'] = this.alerte;
    return data;
  }
}