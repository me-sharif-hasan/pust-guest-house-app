import 'package:flutter/material.dart';
import 'package:guest_house_pust/ui/admin/guestHouses.dart';
import 'package:guest_house_pust/ui/admin/monthlyStat.dart';
import 'package:guest_house_pust/ui/admin/requestsPage.dart';
import 'package:guest_house_pust/ui/admin/users.dart';
import 'package:guest_house_pust/ui/auth/login.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    MonthlyStat(),
    Users(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appTitle,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(primary)),
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
                  Icon(Icons.logout),
                ],
              ),
            ),
          )
        ],
      ),
      body: navPages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        selectedItemColor: primary,
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
            icon: Icon(Icons.calendar_month),
            label: 'Monthly',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}
