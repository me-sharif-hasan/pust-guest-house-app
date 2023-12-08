import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/client/clientApiHandel.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetails extends StatelessWidget {
  final User? user;
  const UserDetails({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appTitle,
        ),
        body: Stack(
          children: [
            // Background
            Container(
              // height: MediaQuery.of(context).size.height*0.5,
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset('images/user_page_bg.jpg'),
              ),
            ),
            // Foreground
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 15, right: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${user!.name}",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Opacity(
                                opacity: 0.6,
                                child: Text(
                                  "${user!.title}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(top: 15, bottom: 15),
                            height: MediaQuery.of(context).size.width * 0.31,
                            width: MediaQuery.of(context).size.width * 0.31,
                            decoration: BoxDecoration(
                              border: Border.all(width: 4, color: dangerColor),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: CircleAvatar(
                              backgroundImage:
                                  getBackgroundImage(user!.profile_picture),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    rowBuilder("Department : ", "${user!.department}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Phone : ", "${user!.phone}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Email : ", "${user!.email}"),
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget rowBuilder(String heading, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          width: 20,
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: SelectableText(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }

  getBackgroundImage(String? profile_picture) {
    if (profile_picture == null) {
      return AssetImage('images/man.png');
    } else {
      return NetworkImage('http://$hostUrl${profile_picture}');
    }
  }
}
