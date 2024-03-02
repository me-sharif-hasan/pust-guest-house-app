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
  // UserList? current_borders;
  int? parent_id;
  int? total_seat;

  RoomModel({
    this.id,
    this.number,
    this.guest_house_id,
    this.room_type,
    this.border_count,
    // this.current_borders,
    this.parent_id,
    this.total_seat,
  });

  factory RoomModel.fromJson(Map<String, dynamic> response) {
    // print("parse json is : $json");
    // UserList? userList;
    // if (response['current_borders'] != null) {
    //   userList = UserList.fromJson(response['current_borders']);
    // }
    int? total_seat = response['total_seat'];
    if (total_seat == 0) {
      total_seat = 1;
    }

    return RoomModel(
      id: response['id'],
      number: response['number'],
      guest_house_id: '${response['guest_house_id']}',
      border_count: response['border_count'],
      room_type: response['room_type'],
      // current_borders: userList,
      parent_id: (response['parent_id'] == null)
          ? null
          : int.parse('${response['parent_id']}'),
      total_seat: total_seat,
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
