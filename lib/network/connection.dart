import 'dart:convert';

import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:http/http.dart';

class Network {
  final String? url;

  Network({this.url});

  Future fetchUser() async {
    // print("$url");

    // // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, url!);
    final response =
        await get(urlg, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future registerUser(User user) async {
    print("$url");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, url!);
    print('calling url is : ${urlg.toString()}');

    final response = await post(urlg, body: json.encode(user.getUser()));

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future loginUser(String email, String password) async {
    print("$url");
    // var ur = Uri.encodeFull(url);
    var urlg = Uri.http(hostUrl, url!);
    Map<String, dynamic> credintial = {'email': email, 'password': password};

    final response = await post(urlg, body: json.encode(credintial));

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future varifyUser(String code) async {
    print("$url");
    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, url!);
    Map<String, dynamic> credintial = {'code': code};

    final response = await post(urlg,
        body: json.encode(credintial),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }


    Future resendVarificationCode() async {
    print("$url");
    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, url!);

    final response = await get(urlg,
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  loadGuestHouses() async {
    var urlg = Uri.https(hostUrl, url!);
    final response =
        await get(urlg, headers: {'Authorization': 'Bearer $token'});

    print('Guest House data : ${response.body}');
    if (response.statusCode == 200) {
      print(response.body);
      // return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
