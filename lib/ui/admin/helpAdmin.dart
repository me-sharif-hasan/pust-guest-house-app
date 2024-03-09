import 'package:flutter/material.dart';
import 'package:guest_house_pust/util/variables.dart';

class HelpAdmin extends StatefulWidget {
  const HelpAdmin({super.key});

  @override
  State<HelpAdmin> createState() => _HelpAdminState();
}

class _HelpAdminState extends State<HelpAdmin> {
  bool is_profile_option = false;
  bool is_booking_option = true;
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
                          _head("How to Approve Booking Request?"),
                          _paragraph(
                              'When a request is pending or showing yellow color, it can be Approved. First open the request\'s by clicking over it. Then set the day count according to the Boarding and Departure Date. Then select Rooms or beds. By clicking "show Available Rooms" We can see available rooms and beds. By clicking over a room or bed it will be selected after clicking again it will be unselected. Selected rooms and beds are shown above the approve Button. After rooms have been selected then click on the approve button. It will show success message.'),
                          _head('How to Reject Booking Request?'),
                          _paragraph(
                              'When a request is pending or showing yellow color, it can be Rejected. First open the request\'s by clicking over it. Then goto bottom of the page and there will be a red \'Reject\' button. Click on the button. It opens an input text option for putting rejection reasons. After putting the rejection reason click on the \'Reject\' Button again. It will show a rejection success message.'),
                          _head('How to Update Departure Date?'),
                          _paragraph(
                              'When a request is approved, it can be update departure date. First open the approved request\'s by clicking over it. Then goto bottom of the page and there will be an orange \'Update Departure Date\' button. The departure date can only be updated by the present date. Then write an updated day count and click on \'Confirm\' Button. It will show a success message.'),
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
                              'From the home screen on the top right corner click on the three dots menu option. Click on the view Profile option, profile page will opened.'),
                          _head('How to Edit User Name?'),
                          _paragraph(
                              'On user profile page, where username is showing. Longtime press on to the user name then an update dialog will open. Change the name and click on the update button.'),
                          _head('How to Edit User designation?'),
                          _paragraph(
                              'On user profile page, where user designation is showing. Longtime press on to the user designation then an update dialog will open. Change the designation and click on the update button.'),
                          _head('How to upload profile picture?'),
                          _paragraph(
                              'On user profile page, where profile picture is showing. Click on the picture then a dialog showing two option \n    (1)Take a picture\n    (2)Select from gallery\nTo show the updated profile picture you need to refresh the app.'),
                          _head('How to Refresh the app?'),
                          _paragraph(
                              'On the home page top right corner showing three dots, click on the three dots. A menu will be opened. The sixth option will show the Refresh, click on it.'),
                          _head('How to Edit Phone Number?'),
                          _paragraph(
                              'On user profile page, where phone number is showing. Longtime press on to the phone number then an update dialog will open. Change the phone number and click on the update button.'),
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
                              'From bottom navigation click on \'Houses\' option. There will show all the guest houses. On the bottom right corner a \'+\' button is given. Click on the plus button. Then the\'Create New Guest House\' page will be opened. Put the required value and click on create button.'),
                          _head("How to Edit Guest House Information?"),
                          _paragraph(
                              'From bottom navigation click on \'Houses\' option. There will show all the guest houses. By long pressing on a house item. It will open the \'Update Guest House Information\' page. Previous information is given there. Change the value as needed. And click on the update button. A success message will show.'),
                          _head("How to view Rooms?"),
                          _paragraph('From bottom navigation click on \'Houses\' option. There will show all the guest houses. Click on any guest house then the guest house all rooms page will open. There will show all the room present on that guesthouse.'),
                          _head("How to Create Room?"),
                          _paragraph('Open guesthouse where you want to create rooms. There shows all the rooms. On that page at the bottom right corner a \'+\' button is showing. Click on plus button then it will open the \'Create New Room\' page. Input required information. If it is a bed then select a room by clicking the show rooms option. Then click on Create button.'),

                          _head("How to Edit Room?"),
                          _paragraph('Open guesthouse where you want to update room information. There will show all the rooms. Click for a long time on a room which you want to modify, then the Update Room page will be open. Input required information. Then click on Update button.'),
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


// _head(""),
//   _paragraph(
//       ''),

// _head('Rejecting a Booking Request'),
//   _paragraph(
//       'When a booking request is pending (indicated by a yellow color), it can be rejected. To reject a request, open it by clicking on it. Scroll to the bottom of the page, where you will find a red "Reject" button. Click on this button, which will prompt an input field to provide a reason for rejection. After entering the reason, click the "Reject" button again. A success message will confirm the rejection.'),

// _head('Updating Departure Date'),
//   _paragraph(
//       'Once a booking request is approved, its departure date can be updated. To initiate this process, open the approved request by clicking on it. Scroll to the bottom of the page, where you will find an orange "Update Departure Date" button. Note that the departure date can only be updated to the current date or later. Enter the updated day count and click the "Confirm" button. A success message will confirm the update.'),

// _head("Viewing Profile"),
//   _paragraph(
//       'To view your profile, navigate to the home screen and click on the three dots menu option located in the top right corner. Select the "View Profile" option to access your profile page.'),

// _head('Editing User Name'),
//   _paragraph(
//       'To edit your user name, go to your profile page and locate the user name field. Long press on your user name to open an update dialog. Enter your new name and click the update button to save the changes.'),

// _head('Editing User Designation'),
//   _paragraph(
//       'To edit your user designation, navigate to your profile page and locate the designation field. Long press on your designation to open an update dialog. Enter your new designation and click the update button to save the changes.'),

// _head('Uploading Profile Picture'),
//   _paragraph(
//       'To upload a new profile picture, go to your profile page and click on your current profile picture. A dialog will appear with options to either take a new picture or select one from the gallery. After choosing a picture, you will need to refresh the app to see the updated profile picture.'),

// _head('Refreshing the App'),
//   _paragraph(
//       'To refresh the app, go to the home page and click on the three dots menu option located in the top right corner. From the menu, select the "Refresh" option to refresh the app.'),

// _head('Editing Phone Number'),
//   _paragraph(
//       'To edit your phone number, navigate to your profile page and locate the phone number field. Long press on your phone number to open an update dialog. Enter your new phone number and click the update button to save the changes.'),

// _head('Creating a Guesthouse'),
//   _paragraph(
//       'To create a new guesthouse, navigate to the bottom navigation and select the "Houses" option. Tap the "+" button located in the bottom right corner to access the "Create New Guest House" page. Fill in the required details and click the create button to finalize.'),

// _head("Editing Guesthouse Information"),
//   _paragraph(
//       'To edit guesthouse information, navigate to the bottom navigation and select the "Houses" option. Long press on the guesthouse item to open the "Update Guest House Information" page. Modify the necessary information and click the update button to save the changes.'),

// _head("Viewing Rooms"),
//   _paragraph(
//       'To view rooms within a guesthouse, navigate to the bottom navigation and select the "Houses" option. Choose a guesthouse to view its rooms.'),

// _head("Creating a Room"),
//   _paragraph(
//       'To create a new room within a guesthouse, navigate to the guesthouse where you want to add the room. Tap the "+" button located in the bottom right corner to access the "Create New Room" page. Fill in the required details and click the create button to finalize.'),

// _head("Editing a Room"),
//   _paragraph(
//       'To edit room information within a guesthouse, navigate to the guesthouse where the room is located. Long press on the room you wish to modify to open the "Update Room" page. Update the necessary information and click the update button to save the changes.'),
