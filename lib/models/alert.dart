import 'models.dart';
class Alert {
	bool lu;
	int id;
	bool delete;
	int user;
	Data alerte;

	Alert({this.lu, this.id, this.delete, this.user, this.alerte});

	Alert.fromJson(Map<String, dynamic> json) {
		lu = json['lu'];
		id = json['id'];
		delete = json['delete'];
		user = json['user'];
		alerte = json['alerte'] != null ? new Data.fromJson(json['alerte']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['lu'] = this.lu;
		data['id'] = this.id;
		data['delete'] = this.delete;
		data['user'] = this.user;
		if (this.alerte != null) {
      data['alerte'] = this.alerte.toJson();
    }
		return data;
	}
}

class Data {
	dynamic geometry;
	int id;
	String type;
	Properties properties;

	Data({this.geometry, this.id, this.type, this.properties});

	Data.fromJson(Map<String, dynamic> json) {
		geometry = json['geometry'];
		id = json['id'];
		type = json['type'];
		properties = json['properties'] != null ? new Properties.fromJson(json['properties']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['geometry'] = this.geometry;
		data['id'] = this.id;
		data['type'] = this.type;
		if (this.properties != null) {
      data['properties'] = this.properties.toJson();
    }
		return data;
	}
}

class Properties {
	String dateAlerte;
	List<Piece> pieceJoinAlerte;
	bool asPoly;
	Category categorie;
	int surface;
	String titre;
	String latitude;
	Employee creerPar;
	List<Employee> destinataires;
	String contenu;
	String dateDeCreation;
	String longitude;

	Properties({this.dateAlerte, this.pieceJoinAlerte, this.asPoly, this.categorie, this.surface, this.titre, this.latitude, this.creerPar, this.destinataires, this.contenu, this.dateDeCreation, this.longitude});

	Properties.fromJson(Map<String, dynamic> json) {
		dateAlerte = json['date_alerte'];
		if (json['piece_join_alerte'] != null) {
			pieceJoinAlerte = new List<Piece>();(json['piece_join_alerte'] as List).forEach((v) { pieceJoinAlerte.add(new Piece.fromJson(v)); });
		}
		asPoly = json['as_poly'];
		categorie = json['categorie'] != null ? new Category.fromJson(json['categorie']) : null;
		surface = json['surface'];
		titre = json['titre'];
		latitude = json['latitude'];
		creerPar = json['creer_par'] != null ? new Employee.fromJson(json['creer_par']) : null;
		if (json['destinataires'] != null) {
			destinataires = new List<Employee>();(json['destinataires'] as List).forEach((v) { destinataires.add(new Employee.fromJson(v)); });
		}
		contenu = json['contenu'];
		dateDeCreation = json['date_de_creation'];
		longitude = json['longitude'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['date_alerte'] = this.dateAlerte;
		if (this.pieceJoinAlerte != null) {
      data['piece_join_alerte'] =  this.pieceJoinAlerte.map((v) => v.toJson()).toList();
    }
		data['as_poly'] = this.asPoly;
		if (this.categorie != null) {
      data['categorie'] = this.categorie.toJson();
    }
		data['surface'] = this.surface;
		data['titre'] = this.titre;
		data['latitude'] = this.latitude;
		if (this.creerPar != null) {
      data['creer_par'] = this.creerPar.toJson();
    }
		if (this.destinataires != null) {
      data['destinataires'] =  this.destinataires.map((v) => v.toJson()).toList();
    }
		data['contenu'] = this.contenu;
		data['date_de_creation'] = this.dateDeCreation;
		data['longitude'] = this.longitude;
		return data;
	}
}





