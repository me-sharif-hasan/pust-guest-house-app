import 'dart:convert';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:http/http.dart';

class AdminUserApi {
  final String? url;

  AdminUserApi({this.url});

  Future<UserList?> loadUsers() async {
    print("$url");
    var urlg = Uri.https(hostUrl, url!);

    final response =
        await get(urlg, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return UserList.fromJson(json.decode(response.body)['data']['user']);
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<User?> getUserById(int id) async {
    print("$url");
    var urlg = Uri.https(hostUrl, url!);

    final response = await post(urlg,
        body: json.encode({'id': id}),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return User.fromJson(json.decode(response.body)['data']['user']);
    } else {
      print(response.statusCode);
      return null;
    }
  }
}
