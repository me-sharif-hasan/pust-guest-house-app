import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/admin/roomModel.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/admin/guestHouseApi.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';

class AdminRequestDetails extends StatefulWidget {
  final Allocation? allocation;
  final User? user;
  const AdminRequestDetails({super.key, this.user, this.allocation});

  @override
  State<AdminRequestDetails> createState() => _AdminRequestDetailsState();
}

class _AdminRequestDetailsState extends State<AdminRequestDetails> {
  Future<RoomList?>? room_list;
  List<int> selectedRoomId = [];
  List<String> selectedRoomNumber = [];
  bool is_room_list_show = false;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.allocation!.status == 'pending') {
      _getAvaileableRooms(
          widget.allocation!.guest_house_id, widget.allocation!.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appTitle,
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                '${type_of_guest_house_list[widget.allocation!.guest_house_id ?? 0]}',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Pabna University of Science and Technology',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Booking Information'),
              SizedBox(
                height: 40,
              ),
              headingText('Personal Information'),
              SizedBox(
                height: 10,
              ),
              rowBuilder("Name : ", "${myUser!.name}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder("Title : ", "${myUser!.title}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder("Department or Office : ", "${myUser!.department}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder("Phone : ", "${myUser!.phone}"),
              SizedBox(
                height: 30,
              ),
              headingText('Booking Information'),
              SizedBox(
                height: 10,
              ),
              rowBuilder("ID : ", "${widget.allocation!.id}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder(
                  "Booking Type : ", "${widget.allocation!.booking_type}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder("Room Type : ", "${widget.allocation!.room_type}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder("Day of Stay : ",
                  "${widget.allocation!.boarding_date!.substring(0, 10)} to ${widget.allocation!.departure_date!.substring(0, 10)}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder(
                  "Total : ",
                  getDayDifference(widget.allocation!.boarding_date!,
                      widget.allocation!.departure_date!)),
              SizedBox(
                height: 10,
              ),
              rowBuilder(
                  "Room Charge : ", "${widget.allocation!.room_charge} taka"),
              SizedBox(
                height: 10,
              ),
              rowBuilder(
                  "No. of Guest : ", "${widget.allocation!.guest_count}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder(
                  "Total Charge : ",
                  getTotalCharge(
                      widget.allocation!.boarding_date!,
                      widget.allocation!.departure_date!,
                      widget.allocation!.room_charge!,
                      widget.allocation!.guest_count!)),
              (widget.allocation!.status == 'pending')
                  ? Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          is_room_list_show
                              ? FutureBuilder(
                                  future: room_list,
                                  builder: (context,
                                      AsyncSnapshot<RoomList?> snapshot) {
                                    if (snapshot.hasData) {
                                      // return Container();
                                      return createRoomsPage(
                                          snapshot.data!.rooms, context);
                                    } else {
                                      return Container(
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    }
                                  },
                                )
                              : Container(),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color?>(
                                          primary)),
                              onPressed: () {
                                setState(() {
                                  is_room_list_show = !is_room_list_show;
                                });
                              },
                              child: Text(is_room_list_show
                                  ? 'Hide Room List'
                                  : 'Show Available Rooms')),
                          rowBuilder(
                              'Selected Rooms : ', '${selectedRoomId.length}'),
                          rowBuilder("Rooms are : ",
                              '${selectedRoomNumber.toString()}'),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color?>(
                                          acceptColor)),
                              onPressed: () {
                                approvedRequest(
                                    widget.allocation!.id!, selectedRoomId);
                              },
                              child: Text('Approve')),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 50,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primary),
                  onPressed: () async {},
                  child: Row(
                    children: [
                      Icon(Icons.download),
                      SizedBox(
                        width: 6,
                      ),
                      Text("Download as PDF"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  headingText(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget rowBuilder(String heading, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            heading,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          flex: 2,
          child: Container(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }

  getDayDifference(String from, String to) {
    DateTime fromDate = DateTime.parse(from);
    DateTime toDate = DateTime.parse(to);

    return '${toDate.difference(fromDate).inDays} days';
  }

  getTotalCharge(String from, String to, int charge, int guest) {
    DateTime fromDate = DateTime.parse(from);
    DateTime toDate = DateTime.parse(to);

    int day = toDate.difference(fromDate).inDays;
    int total = day * charge * guest;

    return '$total taka';
  }

  void _getAvaileableRooms(int? guest_house_id, int? id) async {
    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/guest-houses/rooms');
    room_list = api.loadAvailebaleRoom(guest_house_id ?? 0, id ?? 0);
    room_list!.then((value) {
      print('data get with size : ${value!.rooms!.length}');
    });
  }

  Widget createRoomsPage(List<RoomModel>? rooms, BuildContext context) {
    return Column(
      children: rooms!.map((e) => roomItemBuilder(e)).toList(),
    );
  }

  Widget roomItemBuilder(RoomModel e) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1, color: primary)),
      child: ListTile(
        onTap: () {
          if (selectedRoomId.contains(e.id)) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  '${e.id} ${e.number} room is rmoved from the selected list.'),
              backgroundColor: dangerColor,
            ));
            setState(() {
              selectedRoomId.remove(e.id);
              selectedRoomNumber.remove(e.number);
            });
          } else {
            setState(() {
              selectedRoomId.add(e.id ?? 0);
              selectedRoomNumber.add('${e.number}');
            });
          }
        },
        tileColor: primaryExtraLight,
        title: Text('Room Number : ${e.number}'),
        trailing: Text('Room Type : ${e.room_type}'),
      ),
    );
  }

  approvedRequest(int id, List<int> list) {
    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/allocation/update');
    api.updateToApproved(id, list);
  }
}
