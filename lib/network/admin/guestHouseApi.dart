import 'dart:convert';
import 'package:guest_house_pust/models/admin/GuestHouseModel.dart';
import 'package:guest_house_pust/models/admin/roomModel.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:http/http.dart';

class GuestHouseApi {
  final String? url;

  GuestHouseApi({this.url});

  Future<GuestHouseList?> loadHouses() async {
    print("$url");
    var urlg = Uri.http(hostUrl, url!);

    final response =
        await get(urlg, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return GuestHouseList.fromJson(
          json.decode(response.body)['data']['list']);
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future createHouse(GuestHouseModel model) async {
    print("$url");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.http(hostUrl, url!);

    final response = await post(urlg,
        body: json.encode(model.get()),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future createRoom(RoomModel model) async {
    print("$url");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.http(hostUrl, url!);

    final response = await post(urlg,
        body: json.encode(model.get()),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  // Future update(int id, String key, String value) async {
  //   print("$url");

  //   // var ur = Uri.encodeFull(url);
  //   var urlg = Uri.http(hostUrl, url!);

  //   final response = await post(urlg,
  //       body: json.encode({'id': id, key: value}),
  //       headers: {'Authorization': 'Bearer $token'});

  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     // return json.decode(response.body);
  //   } else {
  //     print(response.statusCode);
  //   }
  // }
}
