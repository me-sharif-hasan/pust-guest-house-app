import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/client/bookingApiHandel.dart';
import 'package:guest_house_pust/ui/client/userHome.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/components.dart';
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
              rowBuilder("App. Date : ",
                  "${allocation!.created_at.toString().substring(0, 10)} At : ${allocation!.created_at.toString().substring(11, 16)}"),
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
              rowBuilder("Border Type : ",
                  "${allocation!.boarder_type!.substring(0, 1).toUpperCase()}${allocation!.boarder_type!.substring(1)}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder("Booking for : ", "${allocation!.allocation_purpose}"),
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
              (allocation!.status == 'approved') ? Container(
                margin: EdgeInsets.only(top: 10),
                child: rowBuilder('Day Count : ', '${allocation!.dayCount}'),
              ) : Container(),
              SizedBox(
                height: 10,
              ),
              rowBuilder("No. of Guest : ", "${allocation!.guest_count}"),
              SizedBox(
                height: 10,
              ),
              rowBuilder("Behalf Of : ", "${allocation!.behalf_of}"),
              // Approved beds
              (allocation!.status == 'approved')
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
                                          borderRadius:
                                              BorderRadius.circular(3.0)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
              (allocation!.status == 'rejected')
                  ? Container(
                      child: rowBuilder(
                          'Reje. Reason :', '${allocation!.rejection_reason}'),
                    )
                  : Container(),
              SizedBox(
                height: 30,
              ),
              guestHouseInfo(allocation!.guest_house_id!),
              SizedBox(
                height: 50,
              ),
              // download pdf button
              (allocation!.status == 'approved')
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(backgroundColor: primary),
                        onPressed: () async {
                          print('pdf download');
                          _launchInBrowserViewPDF(
                              context, allocation!.report_link);
                        },
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
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              // Cancel Request btn
              (allocation!.status == 'approved' ||
                      allocation!.status == 'pending')
                  ? Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: dangerColor),
                            onPressed: () async {
                              requestCancel(context, allocation!.id ?? 0);
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
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Text(
                            'This cancel is not change your deperature date. To update deperature date you need to talk with admin.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : Container(),
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

  requestCancel(BuildContext context, int id) {
    BookingNetwork api =
        BookingNetwork(url: '/api/v1/public/allocation/update');
    final response = api.cancelRequest(id);
    response.then((value) {
      if (value) {
        showToast(context, 'Cancel success', dangerColor);
        Navigator.popUntil(context, (route) => false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserHome()),
        );
      } else {
        showToast(context, 'Cancel denied', dangerColor);
      }
    });
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
          _launchInBrowserView(guest_house_lat[id]!, guest_house_log[id]!);
        },
        leading: CircleAvatar(child: Text('${id}')),
        title: Text('${type_of_guest_house_list[id]}'),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('address : ${guest_house_address[id]}'),
        ]),
        trailing: CircleAvatar(
          child: Icon(
            Icons.location_pin,
            color: Colors.red,
          ),
        ),
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

  Future<void> _launchInBrowserViewPDF(
      BuildContext context, String? surl) async {
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
}
