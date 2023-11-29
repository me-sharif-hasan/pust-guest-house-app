import 'dart:convert';
import 'package:guest_house_pust/util/variables.dart';
import 'package:http/http.dart';

class ClientNetwork {
  final String? url;
  final String baseUrl = "$hostUrl";

  ClientNetwork({this.url});

  updateProfile(String key, String value) async {
    print("$url");
    var urlg = Uri.https(baseUrl, url!);

    final response = await post(urlg,
        body: json.encode({key: value}),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      // return AllocationList.fromJson(
      // json.decode(response.body)['data']['allocation']);
    } else {
      print(response.statusCode);
    }
  }

  Future<bool> update(String key, String value) async {
    print("$url");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, url!);
    print('urlg : ${urlg.toString()}');

    final response = await post(urlg,
        body: json.encode({key: value}),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }
}
