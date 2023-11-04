import 'dart:convert';

import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:http/http.dart';

class ClientNetwork {
  final String? url;
  final String baseUrl = "$hostUrl/api/v1/public";

  ClientNetwork({this.url});

  Future fetchData() async {
    print("$url");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.http(baseUrl, url!);
    final response = await get(urlg);

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
    var urlg = Uri.http(baseUrl, url!);
    
    final response = await post(urlg, body: user.getUser());

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future loginUser(String email, String password) async{
    print("$url");
    // var ur = Uri.encodeFull(url);
    var urlg = Uri.http(baseUrl, url!);
    Map<String, dynamic> credintial = {
      'email' : email,
      'password' : password
    };
    
    final response = await post(urlg, body: credintial);

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}