import 'dart:convert';
import 'package:guest_house_pust/util/variables.dart';
import 'package:http/http.dart';

class ClientNetwork {
  final String? url;
  final String baseUrl = "$hostUrl";

  ClientNetwork({this.url});

  updateProfile(String key, String value) async {
    print("$url");
    var urlg = Uri.http(baseUrl, url!);

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
}
