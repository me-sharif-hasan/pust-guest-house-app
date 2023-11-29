import 'dart:convert';

import 'package:guest_house_pust/models/admin/roomModel.dart';

class GuestHouseList {
  final List<GuestHouseModel>? houses;
  GuestHouseList({this.houses});

  factory GuestHouseList.fromJson(List<dynamic> parsedJson) {
    List<GuestHouseModel> houses = [];
    houses = parsedJson.map(
      (e) {
        return GuestHouseModel.fromJson(e);
      },
    ).toList();
    return GuestHouseList(houses: houses);
  }
}

class GuestHouseModel {
  int? id;
  String? title;
  // String? gps_location;
  String? address;
  double? lat;
  double? log;
  RoomList? roomList;

  GuestHouseModel(
      {this.id, this.title, this.address, this.lat, this.log, this.roomList});

  factory GuestHouseModel.fromJson(Map<String, dynamic> response) {
    // print("parse json is : $json");
    double? _lat = 0.0;
    double? _log = 0.0;
    if (response['gps_location'] != null) {
      Map<String, dynamic> location = json.decode(response['gps_location']);
      _lat = location['lat'];
      _log = location['log'];
    }
    RoomList? roomList;
    roomList = RoomList.fromJson(response['rooms']);

    return GuestHouseModel(
      id: response['id'],
      title: response['title'],
      address: response['address'],
      lat: _lat,
      log: _log,
      roomList: roomList,
    );
  }

  Map<String, dynamic> get() {
    return {
      'title': title,
      'address': address,
      'gps_location': json.encode({
        'lat': lat,
        'log': log,
      }).toString()
    };
  }
}