class User {
  String lastName;
  String firstName;
  String email;
  String username;

  User({this.lastName, this.firstName, this.email, this.username});

  User.fromJson(Map<String, dynamic> json) {
    lastName = json['last_name'];
    firstName = json['first_name'];
    email = json['email'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_name'] = this.lastName;
    data['first_name'] = this.firstName;
    data['email'] = this.email;
    data['username'] = this.username;
    return data;
  }
}