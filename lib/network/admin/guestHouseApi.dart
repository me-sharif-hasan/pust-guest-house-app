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
    var urlg = Uri.https(hostUrl, url!);

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
    var urlg = Uri.https(hostUrl, url!);

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
  Future updateHouse(int id, GuestHouseModel model) async {
    print("$url");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, url!);

    Map<String,dynamic> bodyMap = model.get();
    bodyMap['id']=id;

    final response = await post(urlg,
        body: json.encode(bodyMap),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future updateToApproved(int id, List<int> list, String dayCount) async {
    print("$url");

    Map<String, dynamic> data = {
      'id': id,
      'room_id': list,
      'status': 'approved',
      'is_admin_seen': 1,
      'is_user_seen': 0,
      'days_count': dayCount,
    };

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, url!);

    final response = await post(urlg,
        body: json.encode(data), headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future updateToReject(int id,String reason) async {
    print("$url");

    Map<String, dynamic> data = {
      'id': id,
      'status': 'rejected',
      'is_admin_seen': 1,
      'is_user_seen': 0,
      'rejection_reason': reason,
    };

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, url!);

    final response = await post(urlg,
        body: json.encode(data), headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future<RoomList?> loadAvailebaleRoom(
      int guest_house_id, int allocation_id) async {
    print("$url");
    var urlg = Uri.https(hostUrl, url!);
    Map<String, dynamic> data = {
      'guest_house_id': guest_house_id,
      'allocation_id': allocation_id,
    };
    final response = await post(
      urlg,
      body: json.encode(data),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print(response.body);
      return RoomList.fromJson(json.decode(response.body)['data']['rooms']);
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<RoomList?> loadParentRoom(int guest_house_id) async {
    print("$url");
    var urlg = Uri.https(hostUrl, url!);
    Map<String, dynamic> data = {'guest_house_id': guest_house_id};
    final response = await post(
      urlg,
      body: json.encode(data),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print(response.body);
      return RoomList.fromJson(json.decode(response.body)['data']);
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future createRoom(RoomModel model, int? parent_id) async {
    print("$url");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, url!);

    Map<String, dynamic> data = model.get();
    data.putIfAbsent('parent_id', () => parent_id);

    final response = await post(urlg,
        body: json.encode(data), headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }
  Future updateRoom(RoomModel model, int? parent_id) async {
    print("$url");

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, url!);

    Map<String, dynamic> data = model.get();
    data.putIfAbsent('id', () => model.id);
    data.putIfAbsent('parent_id', () => parent_id);

    final response = await post(urlg,
        body: json.encode(data), headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  void updateDeperatureDate(int id, String dayCount) async {
    print("$url");

    Map<String, dynamic> data = {
      'id': id,
      'status': 'approved',
      'is_admin_seen': 1,
      'is_user_seen': 0,
      'departure_date': '${DateTime.now().toLocal()}',
      'days_count': dayCount,
    };

    // var ur = Uri.encodeFull(url);
    var urlg = Uri.https(hostUrl, url!);

    final response = await post(urlg,
        body: json.encode(data), headers: {'Authorization': 'Bearer $token'});

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
