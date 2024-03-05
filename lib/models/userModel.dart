class UserList {
  final List<User>? users;
  UserList({this.users});

  factory UserList.fromJson(List<dynamic> parsedJson) {
    List<User> users = [];
    users = parsedJson
        .map(
          (e) {
            return User.fromJson(e);
          },
        )
        .toList()
        .reversed
        .toList();
    return UserList(users: users);
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? password;
  String? department;
  String? phone;
  String? title;
  String? profile_picture;
  String? user_type;

  User(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.department,
      this.phone,
      this.title,
      this.profile_picture, 
      this.user_type});

  factory User.fromJson(Map<String, dynamic> json) {
    // print("parse json is : $json");
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        department: json['department'],
        phone: json['phone'],
        title: json['title'],
        profile_picture: json['profile_picture'],
        user_type: json['user_type']);
  }

  Map<String, dynamic> getUser() {
    return {
      'name' : name,
      'email' : email,
      'password' : password,
      'department' : department,
      'phone' : phone,
      'title' : title,
    };
  }
}
