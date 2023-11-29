import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/client/bookingApiHandel.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestDetails extends StatelessWidget {
  final Allocation? allocation;
  final User? user;
  const RequestDetails({super.key, this.user, this.allocation});

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
                '${type_of_guest_house_list[allocation!.guest_house_id ?? 0]}',
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
              rowBuilder("Designation : ", "${myUser!.title}"),
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
              rowBuilder("Id : ", "${allocation!.id}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder("Booking Type : ", "${allocation!.booking_type}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder("Room Type : ", "${allocation!.room_type}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder("Boarding date : ",
                  "${allocation!.boarding_date!.substring(0, 16)}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder("Departure date : ",
                  "${allocation!.departure_date!.substring(0, 16)}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder("No. of Guest : ", "${allocation!.guest_count}"),
              (allocation!.status == 'approved')
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
                                children:
                                    allocation!.assigned_room!.rooms!.map((e) {
                                  return Container(
                                      margin: EdgeInsets.all(5.0),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10.0),
                                      decoration: BoxDecoration(
                                          color: primaryExtraLight,
                                          border: Border.all(
                                              width: 1.3, color: primary),
                                          borderRadius: BorderRadius.circular(3.0)
                                          ),
                                              
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
              SizedBox(
                height: 30,
              ),
              guestHouseInfo(allocation!.guest_house_id!),
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
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: dangerColor),
                  onPressed: () async {
                    requestCancel(allocation!.id ?? 0);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.cancel_outlined),
                      SizedBox(
                        width: 6,
                      ),
                      Text("Cancel Request."),
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

  requestCancel(int id) {
    BookingNetwork api =
        BookingNetwork(url: '/api/v1/public/allocation/update');
    api.cancelRequest(id);
  }

  Widget guestHouseInfo(int id) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: primary),
          borderRadius: BorderRadius.circular(6),
          color: primaryExtraLight),
      child: ListTile(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => RoomsPage(
          //               guestHouseModel: house,
          //             )));
        },
        leading: CircleAvatar(child: Text('${id}')),
        title: Text('${type_of_guest_house_list[id]}'),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('address : ${guest_house_address[id]}'),
        ]),
        trailing: GestureDetector(
            onTap: () {
              _launchInBrowserView(guest_house_lat[id]!, guest_house_log[id]!);
            },
            child: CircleAvatar(
              child: Icon(Icons.location_pin),
            )),
      ),
    );
  }

  Future<void> _launchInBrowserView(double lat, double long) async {
    Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${lat},${long}');
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}
