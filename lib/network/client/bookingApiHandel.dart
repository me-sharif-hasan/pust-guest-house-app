import 'dart:convert';

import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:http/http.dart';

class BookingNetwork {
  final String? url;

  BookingNetwork({this.url});

  Future<AllocationList?> loadAllocations(String param) async {
    print("$url");
    var urlg = Uri.https(hostUrl, url! + param);

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
    var urlg = Uri.https(hostUrl, url!);

    print('-----------------Sending data are____');
    print('${json.encode(booking.get())}');
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
    var urlg = Uri.https(hostUrl, url!);
    print('urlg : ${urlg.toString()}');

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

  Future<bool> cancelRequest(int id) async {
    print("$url");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, url!);

    final response = await post(urlg,
        body: json.encode({
          'id': id,
          'status': 'cancelled',
          'is_admin_seen': 0,
          'is_user_seen': 1,
        }),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return true;
      // return json.decode(response.body);
    } else {
      print(response.statusCode);
      return false;
    }
  }
}
