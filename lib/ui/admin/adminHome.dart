import 'package:flutter/material.dart';
import 'package:guest_house_pust/ui/admin/guestHouses.dart';
import 'package:guest_house_pust/ui/admin/helpAdmin.dart';
import 'package:guest_house_pust/ui/admin/requestsPage.dart';
import 'package:guest_house_pust/ui/admin/users.dart';
import 'package:guest_house_pust/ui/auth/splashScreen.dart';
import 'package:guest_house_pust/ui/client/userProfile.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/components.dart';
import 'package:guest_house_pust/util/variables.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int pageIndex = 0;
  List<Widget> navPages = [
    Requests(),
    Houses(),
    // MonthlyStat(),
    Users(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appTitle,
        actions: [
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          //   child: ElevatedButton(
          //     style: ButtonStyle(
          //         backgroundColor: MaterialStateProperty.all<Color>(primary)),
          //     onPressed: () async {},
          //     child: Row(
          //       children: [
          //         Text("Sign Out"),
          //         SizedBox(
          //           width: 6,
          //         ),
          //         Icon(Icons.logout),
          //       ],
          //     ),
          //   ),
          // ),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              // Define the items in the menu
              return [
                PopupMenuItem(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserProfile()),
                    );
                  },
                  child: Text('View Profile'),
                ),
                PopupMenuItem(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpAdmin()),
                    );
                  },
                  child: Text('Help'),
                ),
                PopupMenuItem(
                  onTap: () {
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SplashScreen()),
                    );
                  },
                  child: Text('Refresh'),
                ),
                PopupMenuItem(
                  onTap: () async {
                    logoutConfirmationDialog(context);
                    // final props = await SharedPreferences.getInstance();
                    // props.remove(tokenText);
                    // // Navigator.pop(context);
                    // Navigator.popUntil(context, (route) => false);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const Login()),
                    // );
                  },
                  child: Text('Sign Out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: navPages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        selectedItemColor: primary,
        backgroundColor: primaryExtraLight,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.request_quote),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_card),
            label: 'Houses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
    );
  }

  getBackgroundImage(String? profile_picture) {
    if (profile_picture == null) {
      return AssetImage('images/man.png');
    } else {
      return NetworkImage('$hostImageUrl${myUser!.profile_picture}');
    }
  }
}
