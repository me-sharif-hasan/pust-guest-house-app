import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guest_house_pust/models/admin/GuestHouseModel.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/admin/guestHouseApi.dart';
import 'package:guest_house_pust/network/client/clientApiHandel.dart';
import 'package:guest_house_pust/network/connection.dart';
import 'package:guest_house_pust/notification.dart';
import 'package:guest_house_pust/ui/admin/adminHome.dart';
import 'package:guest_house_pust/ui/auth/emailVerification.dart';
import 'package:guest_house_pust/ui/auth/login.dart';
import 'package:guest_house_pust/ui/client/userHome.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final NotificationSetUp _noti = NotificationSetUp();

  @override
  void initState() {
    // TODO: implement initState
    _noti.configurePushNotification(context);
    _noti.eventListenerCallback(context);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
    print('From init state');
    checkCredintial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.green, Colors.white, primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Image.asset('images/pust_logo.png'),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "PUST Guest House",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Pabna University of Science and Technology",
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              CircularProgressIndicator(
                color: primaryExtraDeep,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: primaryDeep,
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Text('Developed By : ',
                  style: TextStyle(
                      color: Colors.deepOrange,)),
              Text('Sharif Hassan(CSE 11)',
                  style: TextStyle(
                      color: Colors.deepOrange, fontWeight: FontWeight.bold)),
              Text('Bayazid Hossain(CSE 11)',
                  style: TextStyle(
                      color: Colors.deepOrange, fontWeight: FontWeight.bold))
            ],
          ),
        )),
      ),
    );
  }

  void checkCredintial() async {
    final profs = await SharedPreferences.getInstance();
    String? _token = profs.getString(tokenText);

    if (_token == null) {
      Future.delayed(const Duration(seconds: 3), () {
        print('three second has passed.');
        // Prints after 3 second.
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      });
    } else {
      print('saved token is : $_token');
      token = _token;
      await loadConstant();
      Future.delayed(const Duration(seconds: 1), () {
        print('one second has passed.');
        // Prints after 1 second.
        Network network = Network(url: '/api/v1/user/details');
        Future data = network.fetchUser();
        data.then((value) async {
          print("data is : $value");
          if (value['status'] == 'not-verified') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(value['message']),
              backgroundColor: dangerColor,
            ));
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Varification()),
            );
          } else if (value['status'] == 'error') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${value['message']} Varify your email first'),
              backgroundColor: dangerColor,
            ));
          } else {
            myUser = User.fromJson(value);
            // Send device key
            if (Platform.isAndroid) {
              final String? device_token =
                  await FirebaseMessaging.instance.getToken();
              _sendDeviceKey('$device_token');
              print('device token is : $device_token');
              print('---------------------------------------------');
            }
            print(myUser!.name);
            if (value['user_type'] != null && value['user_type'] == 'admin') {
              // Parse to admin Page
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminHome()),
              );
            } else {
              // Parse to User Page
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserHome()),
              );
            }
          }
        });
      });
    }
  }

  loadConstant() async {
    // type_of_guest_house_list.add('Pabna');
    // type_of_guest_house_list.add('Dhaka');

    GuestHouseApi api = GuestHouseApi(url: '/api/v1/common/guest-house-list');

    Future<GuestHouseList?> list = api.loadHouses();
    list.then((value) async {
      // print('DAta get -------${value!.houses!.length}');
      for (int i = 0; i < value!.houses!.length; i++) {
        print('-----id ${value.houses![i].id}');
        type_of_guest_house_list[value.houses![i].id ?? 0] =
            '${value.houses![i].title}';
        guest_house_address[value.houses![i].id ?? 0] =
            '${value.houses![i].address}';
        guest_house_lat[value.houses![i].id ?? 0] =
            double.parse('${value.houses![i].lat}');
        guest_house_log[value.houses![i].id ?? 0] =
            double.parse('${value.houses![i].log}');

        print('-----value ${type_of_guest_house_list[value.houses![i].id]}');
      }
    });
  }

  _sendDeviceKey(String key) async {
    ClientNetwork api = ClientNetwork(url: '/api/v1/user/update');
    Future<bool> status = api.update('device_key', key);
    status.then((value) {
      if (value) {
        // showToast('$key updated Success', acceptColor);
        print('Success -----------------');
      } else {
        print(
            'Fail device key upload fail (-_-) (-_-) (-_-) (-_-) (-_-) (-_-) (-_-) (-_-) (-_-) (-_-) (-_-) ');
      }
    });
  }
}
