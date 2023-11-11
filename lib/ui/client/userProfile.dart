import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guest_house_pust/network/clientApiHandel.dart';
import 'package:guest_house_pust/ui/auth/login.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          actions: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primary),
                onPressed: () async {
                  final props = await SharedPreferences.getInstance();
                  props.remove(tokenText);
                  // Navigator.pop(context);
                  Navigator.popUntil(context, (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: Row(
                  children: [
                    Text("Sign Out"),
                    SizedBox(
                      width: 6,
                    ),
                    Icon(Icons.logout)
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            // Background
            Container(
              // height: MediaQuery.of(context).size.height*0.5,
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset('images/user_page_bg.jpg'),
              ),
            ),
            // Foreground
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                                "${myUser!.name}",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Opacity(
                                opacity: 0.6,
                                child: Text(
                                  "${myUser!.title}",
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
                          child: GestureDetector(
                            onTap: () {
                              print('Clicked on image');
                              _showImageUploadDialog(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 15, bottom: 15),
                              height: MediaQuery.of(context).size.width * 0.31,
                              width: MediaQuery.of(context).size.width * 0.31,
                              child: CircleAvatar(
                                backgroundImage:
                                    getBackgroundImage(myUser!.profile_picture),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    rowBuilder("Department : ", "${myUser!.department}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Phone : ", "${myUser!.phone}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Email : ", "${myUser!.email}"),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Request statistic",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    rowBuilder("Approved : ",
                        "${catagory_wise_allocations!['approved']!.length}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Current : ",
                        "${catagory_wise_allocations!['current']!.length}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Pending : ",
                        "${catagory_wise_allocations!['pending']!.length}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Rejected : ",
                        "${catagory_wise_allocations!['rejected']!.length}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Expired : ",
                        "${catagory_wise_allocations!['expired']!.length}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("All : ",
                        "${catagory_wise_allocations!['approved']!.length + catagory_wise_allocations!['current']!.length + catagory_wise_allocations!['pending']!.length + catagory_wise_allocations!['rejected']!.length + catagory_wise_allocations!['expired']!.length}"),
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
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Expanded(
          flex: 3,
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

  Future<void> _showImageUploadDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Profile Picture'),
          // backgroundColor: primary,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: primaryDeep,
                      borderRadius: BorderRadius.circular(6)),
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Take a picture',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      _pickImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                Container(
                  decoration: BoxDecoration(
                      color: primaryDeep,
                      borderRadius: BorderRadius.circular(6)),
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Select from gallery',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (result != null) {
      // final bytes = await _image.readAsBytes();
      // final base64Image = base64Encode(bytes);
      // Send the image to the server
      print("Image found");
    }
  }

  Future<String?> _pickImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: imageSource,
    );
    if (pickedFile == null) return null;
    print('\n path is : pickedFile.path');
    final bytes = await pickedFile.readAsBytes();
    await _sendToServer(base64Encode(bytes));
    // return base64Encode(bytes);
  }

  Future<void> _sendToServer(String base64Image) async {
    // Replace the URL with your server endpoint
    ClientNetwork network = ClientNetwork(url: '/api/v1/user/update');
    await network.updateProfile('profile_picture', base64Image);
  }

  getBackgroundImage(String? profile_picture) {
    if (profile_picture == null) {
      return AssetImage('images/man.png');
    } else {
      return NetworkImage('http://$hostUrl${myUser!.profile_picture}');
    }
  }
}
