import 'dart:convert';

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
  int? room_charge;

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
    this.room_charge,
  });

  factory Allocation.fromJson(Map<String, dynamic> response) {
    // print("parse json is : $json");
    int _charge = 0;
    if (response['fee']['charge'] != null) {
      _charge = response['fee']['charge'];
    }

    return Allocation(
      id: response['id'],
      user_id: response['user_id'],
      guest_house_id: response['guest_house_id'],
      room_id: response['room_id'],
      bed_number: response['bed_number'],
      guest_count: response['guest_count'],
      room_type: response['room_type'],
      booking_type: response['booking_type'],
      status: response['status'],
      boarding_date: response['boarding_date'],
      departure_date: response['departure_date'],
      extension_request_date: response['extension_request_date'],
      is_admin_seen: response['is_admin_seen'],
      is_user_seen: response['is_user_seen'],
      created_at: response['created_at'],
      updated_at: response['updated_at'],
      room_charge: _charge,
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
