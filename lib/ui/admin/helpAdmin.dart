import 'package:flutter/material.dart';
import 'package:guest_house_pust/util/variables.dart';

class HelpAdmin extends StatefulWidget {
  const HelpAdmin({super.key});

  @override
  State<HelpAdmin> createState() => _HelpAdminState();
}

class _HelpAdminState extends State<HelpAdmin> {
  bool is_profile_option = false;
  bool is_booking_option = false;
  bool is_house_option = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appTitle),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.015,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: Text(
                  'Get Help',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    is_booking_option = !is_booking_option;
                    is_house_option = false;
                    is_profile_option = false;
                  });
                },
                child: _head1('Booking Related'),
              ),
              (is_booking_option)
                  ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _head("How to Approve Booking?"),
                          _paragraph(
                              'When a request is in pending or showing yellow color, it can be Approved. First open the request\'s by clicking over it. Then set the day count according to the Boarding and Departure Date. Then select Rooms or beds. By clicking "show Available Rooms" We can see availeable rooms and beds. By clicking over room or bed it will selected after clicking again it will disselected. Selected rooms and beds are shown above the approve Button. After room selected click on approve button. It will show success message.'),
                          _head('How to Reject Booking Request?'),
                          _paragraph(
                              'When a request is in pending or showing yellow color, it can be Rejected. First open the request\'s by clicking over it. Then goto bottom of the page and there will a red \'Reject\' button. Click on the button. It open a input text option for putting rejection reasen. After putting rejection reason click on \'Reject\' Button. It will show a success message.'),
                          _head('How to Update Deperature Date?'),
                          _paragraph(
                              'When a request is in approved, it can be update departure date. First open the approved request\'s by clicking over it. Then goto bottom of the page and there will a orange \'Update Departure Date\' button. The departure date only can update by present date. Then write updated day count and click on \'Confirm\' Button. It will show a success message.'),
                        ],
                      ),
                    )
                  : Container(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    is_booking_option = false;
                    is_house_option = false;
                    is_profile_option = !is_profile_option;
                  });
                },
                child: _head1('User Profile Related'),
              ),
              (is_profile_option)
                  ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _head("How to view profile?"),
                          _paragraph(
                              'From the home screen on the top right cornner click on the three dots menu option. Click on the view Profile option, profile page will opened.'),
                          _head('How to Edit User Name?'),
                          _paragraph(
                              'On user profile page, where user name is showing. Longtime press on to the user name then a update dialog will open. Change the name and click on the update button.'),
                          _head('How to Edit User designation?'),
                          _paragraph(
                              'On user profile page, where user designation is showing. Longtime press on to the user designation then a update dialog will open. Change the designation and click on the update button.'),
                          _head('How to upload profile picture?'),
                          _paragraph(
                              'On user profile page, where profile picture is showing. Click on the picture then a dialog showing two option \n    (1)Take a picture\n    (2)Select from gallery\nTo show the updated profile picture you need to refresh the app.'),
                          _head('How to Refresh the app?'),
                          _paragraph(
                              'On the home page top right corner showing three dots, click on the three dots. A menu will opened. The third option will show the Refresh, click on it.'),
                          _head('How to Edit Phone number?'),
                          _paragraph(
                              'On user profile page, where phone number is showing. Longtime press on to the phone number then a update dialog will open. Change the phone number and click on the update button.'),
                        ],
                      ),
                    )
                  : Container(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    is_booking_option = false;
                    is_house_option = !is_house_option;
                    is_profile_option = false;
                  });
                },
                child: _head1("Guest House Related"),
              ),
              (is_house_option)
                  ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _head("How to Create Guesthouse?"),
                          _paragraph(
                              'From bottom navigation click on \'Houses\' option. There will show all the guest houses. By long time pressing on house item. It will open \'Update Guest House Information\' Page. On the bottom right cornner a \'+\' button given. Click on the plus button. Then \'Create New Guest House\' page will opened. Put the required value and click on create button.'),
                          _head("How to Edit Guesthouse Information?"),
                          _paragraph(
                              'From bottom navigation click on \'Houses\' option. There will show all the guest houses. By long time pressing on house item. It will open \'Update Guest House Information\' Page. Previous information are given there. Change the value as needed. And click on update button. A success message will show.'),
                          _head("How to view Rooms?"),
                          _paragraph('From bottom navigation click on \'Houses\' option. There will show all the guest houses. Click on any guesthouse then guesthouse all rooms page will open. There will show all the room present on that guesthouse.'),
                          _head("How to Create Room?"),
                          _paragraph('Open guesthous where you want to create rooms. Here shows all the rooms. On that page at the bottom right cornner a \'+\' button is showing. Click on plus button then open \'Create New Room\' page. Input required information. If it is a bed then select a room by clicking show rooms option. Then click on Create button.'),

                          _head("How to Edit Room?"),
                          _paragraph('Open guesthous where you want to create rooms. Here shows all the rooms. Click long time on a room which you want to modify, then Update Room page will opened. Input required information. Then click on Update button.'),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _head(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Widget _head1(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _paragraph(String text) {
    return Container(
      margin: EdgeInsets.only(left: 15, bottom: 30),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
