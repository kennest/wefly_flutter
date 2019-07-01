import 'models.dart';
class ReceivedEmployee {
	String reference;
	int entreprise;
	int role;
	int superieur;
	int fonction;
	int adresse;
	String photo;
	String telephone;
	int id;
	String createAt;
	User user;
	bool delete;

	ReceivedEmployee({this.reference, this.entreprise, this.role, this.superieur, this.fonction, this.adresse, this.photo, this.telephone, this.id, this.createAt, this.user, this.delete});

	ReceivedEmployee.fromJson(Map<String, dynamic> json) {
		reference = json['reference'];
		entreprise = json['entreprise'];
		role = json['role'];
		superieur = json['superieur'];
		fonction = json['fonction'];
		adresse = json['adresse'];
		photo = json['photo'];
		telephone = json['telephone'];
		id = json['id'];
		createAt = json['create_at'];
		user = json['user'] != null ? new User.fromJson(json['user']) : null;
		delete = json['delete'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['reference'] = this.reference;
		data['entreprise'] = this.entreprise;
		data['role'] = this.role;
		data['superieur'] = this.superieur;
		data['fonction'] = this.fonction;
		data['adresse'] = this.adresse;
		data['photo'] = this.photo;
		data['telephone'] = this.telephone;
		data['id'] = this.id;
		data['create_at'] = this.createAt;
		if (this.user != null) {
      data['user'] = this.user.toJson();
    }
		data['delete'] = this.delete;
		return data;
	}
}



