import 'dart:convert';

import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:http/http.dart';

class ClientNetwork {
  final String? url;
  final String baseUrl = "$hostUrl";

  ClientNetwork({this.url});

  Future<AllocationList?> loadAllocations(String param) async {
    print("$url");
    var urlg = Uri.http(baseUrl, url!+param);

    final response =
        await get(urlg, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print(response.body);
      return AllocationList.fromJson(json.decode(response.body)['data']['allocation']);
    } else {
      print(response.statusCode);
    }
  }
}
