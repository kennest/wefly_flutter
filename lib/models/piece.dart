class Piece {
  String remote_piece;
  String local_piece;
  int id;
  int email;
  int alerte;

  Piece(
      {this.remote_piece, this.id, this.email, this.alerte, this.local_piece});

  Piece.fromJson(Map<String, dynamic> json) {
    remote_piece = json['piece'];
    if (json['local_piece'] != null) {
      local_piece = json['local_piece'];
    }
    id = json['id'];
    email = json['email'];
    alerte = json['alerte'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['piece'] = this.remote_piece;
    data['local_piece'] = this.local_piece;
    data['id'] = this.id;
    data['email'] = this.email;
    data['alerte'] = this.alerte;
    return data;
  }
}
