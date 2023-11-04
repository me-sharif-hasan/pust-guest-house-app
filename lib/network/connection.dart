import 'dart:convert';

import 'package:guest_house_pust/models/userModel.dart';
import 'package:http/http.dart';

class Network {
  final String? url;
  final String baseUrl = "10.0.2.2:8000";

  Network({this.url});

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
}