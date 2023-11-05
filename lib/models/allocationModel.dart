class AllocationList {
  final List<Allocation>? allocations;
  AllocationList({this.allocations});

  factory AllocationList.fromJson(List<dynamic> parsedJson){
    List<Allocation> allocations = [];
    allocations = parsedJson.map((e) {
      return Allocation.fromJson(e);
    },).toList();
    return AllocationList(allocations: allocations);
  }
}

class Allocation {
  int? id;
  int? user_id;
  int? guest_house_id;
  int? room_id;
  String? status;
  String? boarding_date;
  String? departure_date;
  String? extension_request_date;
  String? created_at;
  String? updated_at;

  Allocation({
    this.id,
    this.user_id,
    this.guest_house_id,
    this.room_id,
    this.status,
    this.boarding_date,
    this.departure_date,
    this.extension_request_date,
    this.created_at,
    this.updated_at,
  });

  factory Allocation.fromJson(Map<String, dynamic> json) {
    // print("parse json is : $json");
    return Allocation(
        id: json['id'],
        user_id: json['user_id'],
        guest_house_id: json['guest_house_id'],
        room_id: json['room_id'],
        status: json['status'],
        boarding_date: json['boarding_date'],
        departure_date: json['departure_date'],
        extension_request_date: json['extension_request_date'],
        created_at: json['created_at'],
        updated_at: json['updated_at']);
  }

  Map<String, dynamic> getUser() {
    return {
      'id': id,
      'user_id': user_id,
      'guest_house_id': guest_house_id,
      'room_id': room_id,
      'status': status,
      'boarding_date': boarding_date,
      'departure_date': departure_date,
      'extension_request_date': extension_request_date,
      'created_at': created_at,
      'updated_at': updated_at
    };
  }
}
