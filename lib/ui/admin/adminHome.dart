import 'package:flutter/material.dart';
import 'package:guest_house_pust/ui/admin/balance.dart';
import 'package:guest_house_pust/ui/admin/guestHouses.dart';
import 'package:guest_house_pust/ui/admin/helpAdmin.dart';
import 'package:guest_house_pust/ui/admin/requestsPage.dart';
import 'package:guest_house_pust/ui/admin/users.dart';
import 'package:guest_house_pust/ui/auth/splashScreen.dart';
import 'package:guest_house_pust/ui/client/about.dart';
import 'package:guest_house_pust/ui/client/userProfile.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/components.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:url_launcher/url_launcher.dart';

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
                          builder: (context) => const AboutPage()),
                    );
                  },
                  child: Text('About'),
                ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BalanceCheckPage()),
                    );
                  },
                  child: Text('Check Banance'),
                ),
                PopupMenuItem(
                  onTap: () {
                    _launchInBrowserView('https://guesthouse.pust.ac.bd/master');
                  },
                  child: Text('Super Admin'),
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

  Future<void> _launchInBrowserView(String? surl) async {
    if (surl == null) {
      showToast(
          context, 'PDF is not availdable for that allocation.', dangerColor);
      return;
    }
    print('Report Url is : $surl');
    Uri url = Uri.parse('$surl');
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  getBackgroundImage(String? profile_picture) {
    if (profile_picture == null) {
      return AssetImage('images/man.png');
    } else {
      return NetworkImage('$hostImageUrl${myUser!.profile_picture}');
    }
  }
}
