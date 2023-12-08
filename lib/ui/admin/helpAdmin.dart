import 'package:flutter/material.dart';
import 'package:guest_house_pust/util/variables.dart';

class HelpAdmin extends StatelessWidget {
  const HelpAdmin({super.key});

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
              _head("How to view profile?"),
              _paragraph(
                  'From the home screen on the top right cornner click on the three dots menu option. Profile page will opened.'),
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
              _paragraph('On the home page top right corner showing three dots, click on the three dots. A menu will opened. The third option will show the Refresh, click on it.'),
              _head('How to Edit Phone number?'),
              _paragraph(
                  'On user profile page, where phone number is showing. Longtime press on to the phone number then a update dialog will open. Change the phone number and click on the update button.'),
              _head('text'),
              _paragraph('text'),
              _head('text'),
              _paragraph('text'),
              _head('text'),
              _paragraph('text'),
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
