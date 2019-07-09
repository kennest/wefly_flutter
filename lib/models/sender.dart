class Sender {
  String lastName;
  String firstName;
  String username;

  Sender({this.lastName, this.firstName, this.username});

  Sender.fromJson(Map<String, dynamic> json) {
    lastName = json['last_name'];
    firstName = json['first_name'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_name'] = this.lastName;
    data['first_name'] = this.firstName;
    data['username'] = this.username;
    return data;
  }
}
