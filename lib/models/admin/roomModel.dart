import 'package:guest_house_pust/models/userModel.dart';

class RoomList {
  final List<RoomModel>? rooms;
  RoomList({this.rooms});

  factory RoomList.fromJson(List<dynamic> parsedJson) {
    List<RoomModel> rooms = [];
    rooms = parsedJson.map(
      (e) {
        return RoomModel.fromJson(e);
      },
    ).toList();
    return RoomList(rooms: rooms);
  }
}

class RoomModel {
  int? id;
  String? number;
  String? guest_house_id;
  String? room_type;
  int? border_count;
  bool is_selected = false;
  UserList? current_borders;

  RoomModel({
    this.id,
    this.number,
    this.guest_house_id,
    this.room_type,
    this.border_count,
    this.current_borders,
  });

  factory RoomModel.fromJson(Map<String, dynamic> response) {
    // print("parse json is : $json");
    UserList userList = UserList.fromJson(response['current_borders']);
    return RoomModel(
      id: response['id'],
      number: response['number'],
      guest_house_id: response['guest_house_id'],
      border_count: response['border_count'],
      room_type: response['room_type'],
      current_borders: userList,
    );
  }

  Map<String, dynamic> get() {
    return {
      'number': number,
      'guest_house_id': guest_house_id,
      'room_type': room_type
    };
  }
}
