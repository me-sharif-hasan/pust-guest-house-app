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
  int? guest_house_id;
  String? room_type;

  RoomModel({this.id, this.number, this.guest_house_id, this.room_type});

  factory RoomModel.fromJson(Map<String, dynamic> response) {
    // print("parse json is : $json");
    return RoomModel(
        id: response['id'],
        number: response['number'],
        guest_house_id: response['guest_house_id'],
        room_type: response['room_type']);
  }

  Map<String, dynamic> get() {
    return {
      'number': number,
      'guest_house_id': guest_house_id,
      'room_type': room_type
    };
  }
}
