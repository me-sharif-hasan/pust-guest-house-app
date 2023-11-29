import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/admin/roomModel.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/admin/guestHouseApi.dart';
import 'package:guest_house_pust/network/admin/userApi.dart';
import 'package:guest_house_pust/ui/admin/adminHome.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/components.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminRequestDetails extends StatefulWidget {
  final Allocation? allocation;
  const AdminRequestDetails({super.key, this.allocation});

  @override
  State<AdminRequestDetails> createState() => _AdminRequestDetailsState();
}

class _AdminRequestDetailsState extends State<AdminRequestDetails> {
  Future<RoomList?>? room_list;
  List<int> selectedRoomId = [];
  List<String> selectedRoomNumber = [];
  bool is_room_list_show = false;
  Future<User?>? future_user;
  User? user;

  bool is_user_fatch = false;
  bool is_day_count = false;
  final _dayCountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    future_user = _getUserDetails(widget.allocation!.user_id);
    future_user!.then((value) {
      print("----${value!.id}");
      is_user_fatch = true;
      setState(() {
        user = value;
      });
    });
    if (widget.allocation!.status == 'pending') {
      _getAvaileableRooms(int.parse('${widget.allocation!.guest_house_id}'),
          widget.allocation!.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appTitle,
      ),
      body: is_user_fatch
          ? Container(
              margin: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${type_of_guest_house_list[widget.allocation!.guest_house_id ?? 0]}',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Pabna University of Science and Technology',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                    rowBuilder("Name : ", "${user!.name}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Designation : ", "${user!.title}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder(
                        "Department or Office : ", "${user!.department}"),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: rowBuilder("Phone : ", "${user!.phone}"),
                      trailing: GestureDetector(
                        onTap: () {
                          print('Calling');
                          _makePhoneCall('+88${user!.phone}');
                        },
                        child: Container(
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                                color: primary,
                                border: Border.all(width: 2.0, color: primary),
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(
                              Icons.call,
                              color: Colors.white,
                            )),
                      ),
                    ),
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
                    rowBuilder("Booking Type : ",
                        "${widget.allocation!.booking_type}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder(
                        "Room Type : ", "${widget.allocation!.room_type}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Boarding date : ",
                        "${widget.allocation!.boarding_date!.substring(0, 16)}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Departure date : ",
                        "${widget.allocation!.departure_date!.substring(0, 16)}"),
                    SizedBox(
                      height: 10,
                    ),
                    (widget.allocation!.status == 'pending')
                        ? Column(
                            children: [
                              rowBuilder(
                                  'Sugg. diff. : ',
                                  getDayDifference(
                                      '${widget.allocation!.boarding_date}',
                                      '${widget.allocation!.departure_date}')),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 12, bottom: 12, right: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: is_day_count
                                          ? Colors.grey
                                          : Colors.red,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Day Count :',
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
                                        child: TextFormField(
                                          onChanged: (value) {
                                            if (value != "") {
                                              setState(() {
                                                is_day_count = true;
                                              });
                                            } else {
                                              setState(() {
                                                is_day_count = false;
                                              });
                                            }
                                          },
                                          controller: _dayCountController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Day count',
                                              hintText: 'Write in number.'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(
                            child: rowBuilder("Day Count : ",
                                "${widget.allocation!.dayCount}"),
                          ),
                    // getDayDifference(widget.allocation!.boarding_date!,
                    //     widget.allocation!.departure_date!)),
                    SizedBox(
                      height: 10,
                    ),
                    // rowBuilder("Room Charge : ",
                    //     "${widget.allocation!.room_charge} taka"),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    rowBuilder(
                        "No. of Guest : ", "${widget.allocation!.guest_count}"),
                    SizedBox(
                      height: 10,
                    ),
                    (widget.allocation!.status == 'approved')
                        ? Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Approved Rooms or Beds : ',
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
                                    child: Column(
                                      children: widget
                                          .allocation!.assigned_room!.rooms!
                                          .map((e) {
                                        return Container(
                                            margin: EdgeInsets.all(5.0),
                                            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                            decoration: BoxDecoration(
                                                color: primaryExtraLight,
                                                border: Border.all(
                                                    width: 1.3,
                                                    color: primary)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Id: ${e.id}'),
                                                Text('${e.number}')
                                              ],
                                            ));
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),

                    // SizedBox(
                    //   height: 10,
                    // ),
                    // rowBuilder(
                    //     "Total Charge : ",
                    //     getTotalCharge(
                    //         widget.allocation!.boarding_date!,
                    //         widget.allocation!.departure_date!,
                    //         widget.allocation!.room_charge!,
                    //         widget.allocation!.guest_count!)),
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
                                                  child:
                                                      CircularProgressIndicator()),
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
                                rowBuilder('Selected Rooms : ',
                                    '${selectedRoomId.length}'),
                                rowBuilder("Rooms are : ",
                                    '${selectedRoomNumber.toString()}'),
                                // approved button
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color?>(
                                              acceptColor)),
                                  onPressed: () {
                                    if (_dayCountController.text == "") {
                                      showToast(
                                          context,
                                          'Day count is not set. please set day count and try again.',
                                          dangerColor);
                                    } else if (selectedRoomId.length == 0) {
                                      showToast(
                                          context,
                                          'Rooms are not selected.',
                                          dangerColor);
                                    } else {
                                      approvedRequest(
                                          widget.allocation!.id!,
                                          selectedRoomId,
                                          _dayCountController.text);
                                    }
                                  },
                                  child: Text('Approve'),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color?>(
                                              dangerColor)),
                                  onPressed: () {
                                    rejectRequest(widget.allocation!.id!);
                                  },
                                  child: Text('Reject'),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 50,
                    ),
                    // pdf download button
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(backgroundColor: primary),
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
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Center(child: CircularProgressIndicator()),
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
            showToast(
                context,
                '${e.id} ${e.number} room is rmoved from the selected list.',
                dangerColor);
            setState(() {
              e.is_selected = false;
              selectedRoomId.remove(e.id);
              selectedRoomNumber.remove(e.number);
            });
          } else {
            setState(() {
              e.is_selected = true;
              selectedRoomId.add(e.id ?? 0);
              selectedRoomNumber.add('${e.number}');
            });
          }
        },
        tileColor: e.is_selected ? primaryLight : primaryExtraLight,
        title: Text('Room Number : ${e.number}'),
        subtitle: Text('Current Border : ${e.border_count}'),
        trailing: Text('Room Type : ${e.room_type}'),
      ),
    );
  }

  approvedRequest(int id, List<int> list, String dayCount) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for server response');

    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/allocation/update');
    api.updateToApproved(id, list, dayCount);
    showToast(context, 'Allocation request Approved success.', acceptColor);
    pd.close();
    Navigator.popUntil(context, (route) => false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminHome()),
    );
  }

  Future<User?> _getUserDetails(int? user_id) {
    AdminUserApi api = AdminUserApi(url: '/api/v1/admin/users/details');
    return api.getUserById(user_id!);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void rejectRequest(int id) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for server response');

    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/allocation/update');
    await api.updateToReject(id);
    showToast(context, 'Allocation request rejected success.', dangerColor);
    pd.close();
    Navigator.popUntil(context, (route) => false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminHome()),
    );
  }
}
