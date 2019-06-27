import 'package:weflyapps/models/models.dart';

class PieceResponse {
	String next;
	dynamic previous;
	int count;
	List<Piece> results;

	PieceResponse({this.next, this.previous, this.count, this.results});

	PieceResponse.fromJson(Map<String, dynamic> json) {
		next = json['next'];
		previous = json['previous'];
		count = json['count'];
		if (json['results'] != null) {
			results = new List<Piece>();(json['results'] as List).forEach((v) { results.add(new Piece.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['next'] = this.next;
		data['previous'] = this.previous;
		data['count'] = this.count;
		if (this.results != null) {
      data['results'] =  this.results.map((v) => v.toJson()).toList();
    }
		return data;
	}
}


