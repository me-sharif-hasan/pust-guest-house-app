import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/connection.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('From init state');
    checkCredintial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: primaryLight),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: primaryExtraDeep,
            ),
            Text("Splash Screen"),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: primaryDeep, borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: Icon(Icons.login),
              ),
            ),
          ],
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
      Future.delayed(const Duration(seconds: 1), () {
        print('one second has passed.');
        // Prints after 1 second.
        Network network = Network(url: '/api/v1/user/details');
        Future data = network.fetchUser();
        data.then((value) async {
          print("data is : $value");
          if (value['status'] == 'error') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(value['message']),
              backgroundColor: dangerColor,
            ));
          } else {
            myUser = User.fromJson(value);

            print(myUser!.name);
            if (value['user_type'] != null && value['user_type'] == 'admin') {
              // Parse to admin Page
            } else {
              // Parse to User Page
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserHome()),
              );
            }

            // Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const Login()),
            // );
          }
        });
        // Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Login()),
        // );
      });
    }
  }
}
