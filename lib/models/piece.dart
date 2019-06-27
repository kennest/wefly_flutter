class Piece{
  String piece;
  int id;
  int email;
  int alerte;

  Piece({this.piece, this.id, this.email, this.alerte});

  Piece.fromJson(Map<String, dynamic> json) {
    piece = json['piece'];
    id = json['id'];
    email = json['email'];
    alerte = json['alerte'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['piece'] = this.piece;
    data['id'] = this.id;
    data['email'] = this.email;
    data['alerte'] = this.alerte;
    return data;
  }
}