import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guest_house_pust/network/client/clientApiHandel.dart';
import 'package:guest_house_pust/ui/auth/forgetPassword/passwordReset.dart';
import 'package:guest_house_pust/ui/auth/splashScreen.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/components.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    // TODO: implement initState
    if (catagory_wise_allocations == null) {
      catagory_wise_allocations = {
        'all': [],
        'pending': [],
        'approved': [],
        'cancelled': [],
        'rejected': [],
        'expired': []
      };
    }
    super.initState();
  }

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
                              GestureDetector(
                                onLongPress: () {
                                  _showUpdateDialog(context, 'user name',
                                      'name', '${myUser!.name}');
                                },
                                child: Text(
                                  "${myUser!.name}",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Opacity(
                                opacity: 0.6,
                                child: GestureDetector(
                                  onLongPress: () {
                                    _showUpdateDialog(context, 'designation',
                                        'title', '${myUser!.title}');
                                  },
                                  child: Text(
                                    "${myUser!.title}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
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
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 4, color: dangerColor),
                                borderRadius: BorderRadius.circular(100),
                              ),
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
                    GestureDetector(
                        onLongPress: () {
                          _showUpdateDialog(context, 'phone number', 'phone',
                              '${myUser!.phone}');
                        },
                        child: rowBuilder("Phone : ", "${myUser!.phone}")),
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
                    rowBuilder("Cancelled : ",
                        "${catagory_wise_allocations!['cancelled']!.length}"),
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
                    Container(
                      height: 1.2,
                      margin: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(color: primary),
                    ),
                    rowBuilder("Total : ",
                        "${catagory_wise_allocations!['approved']!.length + catagory_wise_allocations!['cancelled']!.length + catagory_wise_allocations!['pending']!.length + catagory_wise_allocations!['rejected']!.length + catagory_wise_allocations!['expired']!.length}"),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(backgroundColor: primary),
                        onPressed: () async {
                          Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResetPassword()),
                    );
                        },
                        child: Text("Change Password"),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(backgroundColor: primary),
                        onPressed: () async {
                          logoutConfirmationDialog(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout),
                            SizedBox(
                              width: 6,
                            ),
                            Text("Sign Out"),
                          ],
                        ),
                      ),
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

  Future _pickImage(ImageSource imageSource) async {
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
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Profile Image is Uploading...');
    // Replace the URL with your server endpoint
    ClientNetwork network = ClientNetwork(url: '/api/v1/user/update');
    await network.updateProfile('profile_picture', base64Image);
    pd.close();
    Navigator.popUntil(context, (route) => false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  getBackgroundImage(String? profile_picture) {
    if (profile_picture == null) {
      return AssetImage('images/man.png');
    } else {
      return NetworkImage('http://$hostUrl${myUser!.profile_picture}');
    }
  }

  void _showUpdateDialog(
      BuildContext context, String key, String serverKey, String value) {
    final _newValueController = TextEditingController();
    _newValueController.text = value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update $key'),
          content: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Old: ',
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
                        child: SelectableText(
                          value,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _newValueController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New $key',
                    hintText: 'Write your new $key'),
              )
            ],
          )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pop();
                print("new value : ${_newValueController.text}");
                if (_newValueController.text == "") {
                  // show a message
                } else {
                  ProgressDialog pd = ProgressDialog(context: context);
                  pd.show(max: 100, msg: 'Wait for server response');
                  ClientNetwork api = ClientNetwork(url: '/api/v1/user/update');
                  Future<bool> status =
                      api.update(serverKey, _newValueController.text);
                  status.then((value) {
                    pd.close();

                    if (value) {
                      // showToast('$key updated Success', acceptColor);
                      print('Success');
                      Future.delayed(Duration(seconds: 2), () {
                        // Code inside this block will be executed after a delay of 2 seconds
                        print('Delayed function executed after 2 seconds');
                        // Navigator.pop(context);
                        Navigator.popUntil(context, (route) => false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SplashScreen()),
                        );
                      });
                    } else {
                      showToast('$key update fail.', dangerColor);
                      print('Fail');
                    }
                  });
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void showToast(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
    ));
  }
}
