import 'package:flutter/material.dart';
import 'package:guest_house_pust/ui/auth/login.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';
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
    );
  }
}
