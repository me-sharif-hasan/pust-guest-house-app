import 'dart:convert';

import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:http/http.dart';

class BookingNetwork {
  final String? url;

  BookingNetwork({this.url});

  Future<AllocationList?> loadAllocations(
      String param, String limit, String page) async {
    print("$url");
    var urlg = Uri.https(hostUrl, url! + param, {
      'limit': limit,
      'page': page,
    });
    print('url is : ${urlg.toString()}');

    final response =
        await get(urlg, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      if (json.decode(response.body)['data']['num_page'] != null) {
        total_page = json.decode(response.body)['data']['num_page'];
      }
      return AllocationList.fromJson(
          json.decode(response.body)['data']['allocation']);
    } else {
      print(response.statusCode);
      return AllocationList();
    }
  }

  Future<AllocationList?> loadAllocationsWithStatus(
      {String? status, String? limit, String? page}) async {
    print("$url");
    var urlg;
    if (status == 'all') {
      urlg = Uri.https(hostUrl, url! + '/all', {
        'limit': limit,
        'page': page,
      });
    } else {
      urlg = Uri.https(hostUrl, url! + '/all', {
        'limit': limit,
        'page': page,
        'status': status,
      });
    }
    print('url is : ${urlg.toString()}');

    final response =
        await get(urlg, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      if (json.decode(response.body)['data']['num_page'] != null) {
        total_page_with_status[status!] =
            json.decode(response.body)['data']['num_page'];
      }
      return AllocationList.fromJson(
          json.decode(response.body)['data']['allocation']);
    } else {
      print(response.statusCode);
      return AllocationList();
    }
  }

  Future<AllocationList?> loadAllocationsForSpecificUser(
      {String? limit, String? page, int? userId}) async {
    print("$url");
    var urlg;
    urlg = Uri.https(hostUrl, url! + '/all', {
      'limit': limit,
      'page': page,
    });
    print('url is : ${urlg.toString()}');

    final response =
        await get(urlg, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      if (json.decode(response.body)['data']['num_page'] != null) {
        total_page = json.decode(response.body)['data']['num_page'];
      }
      final allocationList = AllocationList.fromJson(
          json.decode(response.body)['data']['allocation']);

      AllocationList listForSpecUser = AllocationList(allocations: []);
      for (int indx = 0; indx < allocationList.allocations!.length; indx++) {
        if (allocationList.allocations![indx].user_id == userId) {
          listForSpecUser.allocations!.add(allocationList.allocations![indx]);
        }
      }
      return listForSpecUser;
    } else {
      print(response.statusCode);
      return AllocationList();
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
