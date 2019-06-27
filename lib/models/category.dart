class Category {
	int entreprise;
	String icone;
	int id;
	String nom;
	String dateDeCreation;

	Category({this.entreprise, this.icone, this.id, this.nom, this.dateDeCreation});

	Category.fromJson(Map<String, dynamic> json) {
		entreprise = json['entreprise'];
		icone = json['icone'];
		id = json['id'];
		nom = json['nom'];
		dateDeCreation = json['date_de_creation'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['entreprise'] = this.entreprise;
		data['icone'] = this.icone;
		data['id'] = this.id;
		data['nom'] = this.nom;
		data['date_de_creation'] = this.dateDeCreation;
		return data;
	}
}
