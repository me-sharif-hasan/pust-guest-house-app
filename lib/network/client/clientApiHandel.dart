import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/components.dart';
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

    print('(-_-) (-_-) (-_-) (-_-) (-_-) (-_-)');
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }

  static Future<void> logout() async {
    print("logut");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, '/api/v1/logout');
    print('urlg : ${urlg.toString()}');

    final response =
        await get(urlg, headers: {'Authorization': 'Bearer $token'});

    print('(-_-) (-_-) (-_-) Logout Response (-_-) (-_-) (-_-)');
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.statusCode);
    }
  }

  static Future<bool> resetPasswordMethod(
      BuildContext context, String endpoint, Map<String, String> data) async {
    print("reset password");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, endpoint);
    print('urlg : ${urlg.toString()}');

    final response = await post(urlg, body: json.encode(data));

    print('(-_-) (-_-) (-_-) Reset $endpoint Response (-_-) (-_-) (-_-)');
    print(response.statusCode);
    print(response.body);
    

    if (response.statusCode == 200 && json.decode(response.body)['status'] != 'error') {
      showToast(context, '${json.decode(response.body)['message']}', acceptColor);
      print(response.body);
      return true;
    } else {
      print(response.statusCode);
      showToast(context, 'Error: ${response.body}', dangerColor);
      return false;
    }
  }
}
