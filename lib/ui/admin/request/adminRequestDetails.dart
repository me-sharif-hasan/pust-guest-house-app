import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/admin/roomModel.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/admin/guestHouseApi.dart';
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
  final _rejectionReasonController = TextEditingController();
  bool _rejection_reason_show = false;

  int bed_count = 0;

  @override
  void initState() {
    // TODO: implement initState
    _rejectionReasonController.text = rejection_reason_text;
    future_user = getUserDetails(widget.allocation!.user_id);
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
                    rowBuilder("App. Date : ",
                        "${widget.allocation!.created_at.toString().substring(0, 10)} At : ${widget.allocation!.created_at.toString().substring(11, 16)}"),
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

                    rowBuilder("Booking for : ",
                        "${widget.allocation!.allocation_purpose}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Guest Type : ",
                        "${widget.allocation!.boarder_type!.substring(0, 1).toUpperCase()}${widget.allocation!.boarder_type!.substring(1)}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Arrival date : ",
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
                                          keyboardType: TextInputType.number,
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
                    rowBuilder(
                        "On Behalf Of : ", "${widget.allocation!.behalf_of}"),
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
                                    'Approved Beds : ',
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
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 10.0),
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
                                                Text('Number : ${e.number}'),
                                                Text('${e.room_type}'),
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
                                rowBuilder('Selected Beds : ', '$bed_count'),
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

                                _rejection_reason_show
                                    ? Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: TextFormField(
                                          controller:
                                              _rejectionReasonController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Rejection Reason',
                                              hintText:
                                                  'Write Rejection Reason.'),
                                        ),
                                      )
                                    : Container(),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color?>(
                                              dangerColor)),
                                  onPressed: () {
                                    if (_rejection_reason_show) {
                                      rejectRequest(widget.allocation!.id!,
                                          _rejectionReasonController.text);
                                    } else {
                                      setState(() {
                                        _rejection_reason_show = true;
                                      });
                                    }
                                  },
                                  child: Text('Reject'),
                                ),
                              ],
                            ),
                          )
                        : Container(),

                    (widget.allocation!.status == 'rejected')
                        ? Container(
                            child: rowBuilder('Reje. Reason :',
                                '${widget.allocation!.rejection_reason}'),
                          )
                        : Container(),
                    SizedBox(
                      height: 50,
                    ),
                    // pdf download button
                    (widget.allocation!.status == 'approved')
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primary),
                                  onPressed: () async {
                                    print('pdf download');
                                    _launchInBrowserView(
                                        widget.allocation!.report_link);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.download),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text("Download as PDF"),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange),
                                  onPressed: () async {
                                    print('update deperature date');
                                    updateDepetDateConfirm(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.upload),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text("Update Departure Date"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
        onTap: () async {
          if (e.border_count == e.total_seat) {
            showToast(context, 'Room is booked', dangerColor);
            return;
          }
          if (selectedRoomId.contains(e.id)) {
            if (e.parent_id == null) {
              final value = await room_list!;
              for (RoomModel room in value!.rooms!) {
                if (room.parent_id == e.id) {
                  room.is_selected = false;
                  selectedRoomId.remove(room.id);
                  selectedRoomNumber.remove(room.number);
                }
              }
            }
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
            if (e.parent_id == null) {
              final value = await room_list!;
              for (RoomModel room in value!.rooms!) {
                if (room.parent_id == e.id) {
                  room.is_selected = true;

                  selectedRoomId.add(room.id ?? 0);
                  selectedRoomNumber.add('${room.number}');
                }
              }
            }

            setState(() {
              e.is_selected = true;
              selectedRoomId.add(e.id ?? 0);
              selectedRoomNumber.add('${e.number}');
            });
          }
          _getBedCount();
        },
        tileColor: e.is_selected
            ? (e.border_count! >= e.total_seat!)
                ? Colors.red.shade300
                : primaryLight
            : (e.border_count! >= e.total_seat!)
                ? Colors.red.shade100
                : primaryExtraLight,
        title: Text((e.parent_id == null)
            ? 'Room Number' + ' : ${e.number}'
            : 'Bed Number' + ' : ${e.number}'),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Current Border : ${e.border_count}'),
            SizedBox(
              width: 25,
            ),
            Text('Total Beds : ${e.total_seat}'),
          ],
        ),
        trailing: Text('Type : ${e.room_type}'),
      ),
    );
  }

  approvedRequest(int id, List<int> list, String dayCount) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for response');

    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/allocation/update');
    api.updateToApproved(id, list, dayCount);
    showToast(context, 'Allocation request Approved success.', acceptColor);
    Future.delayed(const Duration(seconds: 2), () {
      pd.close();
      Navigator.popUntil(context, (route) => false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminHome()),
      );
    });
  }

  

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void rejectRequest(int id, String reason) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for response');

    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/allocation/update');
    await api.updateToReject(id, reason);
    showToast(context, 'Allocation request rejected success.', dangerColor);
    pd.close();
    Navigator.popUntil(context, (route) => false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminHome()),
    );
  }

  void _getBedCount() async {
    int bedCount = selectedRoomId.length;
    room_list!.then((value) async {
      for (RoomModel room in value!.rooms!) {
        for (int id in selectedRoomId) {
          print('${room.id} id  $id parent : ${room.parent_id}');
          if (room.id == id && room.parent_id == null) {
            bedCount--;
          }
        }
      }
      print('bed set as $bedCount');
      setState(() {
        bed_count = bedCount;
      });
    });
  }

  Future<void> _launchInBrowserView(String? surl) async {
    if (surl == null) {
      showToast(
          context, 'PDF is not availdable for that allocation.', dangerColor);
      return;
    }
    print('Report Url is : $surl');
    Uri url = Uri.parse('$surl');
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  void updateDepetDateConfirm(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Deperature Date.'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Text('Are you sure to update deperature date by current date.'),
                SizedBox(
                  height: 20.0,
                ),
                rowBuilder(
                    'Boar. Date : ', '${widget.allocation!.boarding_date}'),
                SizedBox(
                  height: 5.0,
                ),
                rowBuilder(
                    'Pre. Date : ', '${widget.allocation!.departure_date}'),
                SizedBox(
                  height: 5.0,
                ),
                rowBuilder('Cur. Date : ',
                    '${DateTime.now().toLocal().toString().substring(0, 16)}'),
                SizedBox(
                  height: 5.0,
                ),
                Column(
                  children: [
                    rowBuilder(
                        'Sugg. diff. : ',
                        getDayDifference('${widget.allocation!.boarding_date}',
                            '${DateTime.now().toLocal()}')),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: is_day_count ? Colors.grey : Colors.red,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Day Count :',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
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
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Day count',
                                  hintText: 'In number.'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            ElevatedButton(
                onPressed: () async {
                  // ProgressDialog pd = ProgressDialog(context: context);
                  // pd.show(max: 100, msg: 'Wait for server response');

                  // final props = await SharedPreferences.getInstance();
                  // props.remove(tokenText);
                  // pd.close();
                  // // Navigator.pop(context);
                  // Navigator.popUntil(context, (route) => false);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const Login()),
                  // );
                  if (_dayCountController.text == "") {
                    showToast(context, 'Updated day count is not imported.',
                        dangerColor);
                    return;
                  }
                  updateRequest(
                      widget.allocation!.id ?? 0, _dayCountController.text);
                },
                child: Text('Confirm'))
          ],
        );
      },
    );
  }

  void updateRequest(int id, String dayCount) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for response');

    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/allocation/update');
    api.updateDeperatureDate(id, dayCount);
    showToast(context, 'Allocation request update success.', acceptColor);
    Future.delayed(const Duration(seconds: 2), () {
      pd.close();
      Navigator.popUntil(context, (route) => false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminHome()),
      );
    });
  }
}
