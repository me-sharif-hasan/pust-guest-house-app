class AllocationListCatagory {
  final AllocationList? allocationList;
  AllocationListCatagory({this.allocationList});

  Map<String, List<Allocation>> build() {
    Map<String, List<Allocation>> catagory = {
      'pending': [],
      'approved': [],
      'current': [],
      'rejected': [],
      'expired': []
    };
    print("bild method ...............${allocationList!.allocations!.length}");
    for (int i = 0; i < allocationList!.allocations!.length; i += 1) {
      print("looping $i");
      catagory[allocationList!.allocations![i].status]!
          .add(allocationList!.allocations![i]);
      print(
          "update length is : ${catagory[allocationList!.allocations![i].status]!.length}");
    }
    // catagory['pending']!.add(Allocation());

    return catagory;
  }
}

class AllocationList {
  final List<Allocation>? allocations;
  AllocationList({this.allocations});

  factory AllocationList.fromJson(List<dynamic> parsedJson) {
    List<Allocation> allocations = [];
    allocations = parsedJson.map(
      (e) {
        return Allocation.fromJson(e);
      },
    ).toList();
    return AllocationList(allocations: allocations);
  }
}

class Allocation {
  int? id;
  int? user_id;
  int? guest_house_id;
  int? room_id;
  String? bed_number;
  int? guest_count;
  String? room_type;
  String? booking_type;
  String? status;
  String? boarding_date;
  String? departure_date;
  String? extension_request_date;
  int? is_admin_seen;
  int? is_user_seen;
  String? created_at;
  String? updated_at;

  Allocation({
    this.id,
    this.user_id,
    this.guest_house_id,
    this.room_id,
    this.bed_number,
    this.guest_count,
    this.room_type,
    this.booking_type,
    this.status,
    this.boarding_date,
    this.departure_date,
    this.extension_request_date,
    this.is_admin_seen,
    this.is_user_seen,
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
      bed_number: json['bed_number'],
      guest_count: json['guest_count'],
      room_type: json['room_type'],
      booking_type: json['booking_type'],
      status: json['status'],
      boarding_date: json['boarding_date'],
      departure_date: json['departure_date'],
      extension_request_date: json['extension_request_date'],
      is_admin_seen: json['is_admin_seen'],
      is_user_seen: json['is_user_seen'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> get() {
    return {
      'user_id': user_id,
      'guest_house_id': guest_house_id,
      'boarding_date': boarding_date,
      'departure_date': departure_date,
      'room_type': room_type,
      'booking_type': booking_type,
      'guest_count': guest_count,
      'created_at': created_at,
      'updated_at': updated_at
    };
  }
}
