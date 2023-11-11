import 'dart:convert';

import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:http/http.dart';

class BookingNetwork {
  final String? url;
  final String baseUrl = "$hostUrl";

  BookingNetwork({this.url});

  Future<AllocationList?> loadAllocations(String param) async {
    print("$url");
    var urlg = Uri.http(baseUrl, url! + param);

    final response =
        await get(urlg, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return AllocationList.fromJson(
          json.decode(response.body)['data']['allocation']);
    } else {
      print(response.statusCode);
    }
  }

  Future sendBookingRequest(Allocation booking) async {
    print("$url");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.http(baseUrl, url!);

    final response = await post(urlg,
        body: json.encode(booking.get()),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future update(int id, String key, String value) async {
    print("$url");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.http(baseUrl, url!);

    final response = await post(urlg,
        body: json.encode({'id': id, key: value}),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      // return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  // Future loginUser(String email, String password) async{
  //   print("$url");
  //   // var ur = Uri.encodeFull(url);
  //   var urlg = Uri.http(baseUrl, url!);
  //   Map<String, dynamic> credintial = {
  //     'email' : email,
  //     'password' : password
  //   };

  //   final response = await post(urlg, body: json.encode(credintial));

  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return json.decode(response.body);
  //   } else {
  //     print(response.statusCode);
  //   }
  // }
}
