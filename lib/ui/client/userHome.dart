import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/network/client/bookingApiHandel.dart';
import 'package:guest_house_pust/ui/auth/splashScreen.dart';
import 'package:guest_house_pust/ui/client/about.dart';
import 'package:guest_house_pust/ui/client/allocationRequest.dart';
import 'package:guest_house_pust/ui/client/helpUser.dart';
import 'package:guest_house_pust/ui/client/userProfile.dart';
import 'package:guest_house_pust/ui/client/requestDetails.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/components.dart';
import 'package:guest_house_pust/util/variables.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  Future<AllocationList?>? allocationData;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    BookingNetwork bookingNetwork =
        BookingNetwork(url: '/api/v1/public/allocation');
    allocationData = bookingNetwork.loadAllocations('/all','100','1');
    allocationData!.then((value) async {
      print("DATA get success...");
      AllocationListCatagory allocationListCatagory =
          await AllocationListCatagory(allocationList: value);
      catagory_wise_allocations = await allocationListCatagory.build();
      setState(() {
        isDataLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: userTapPotions.length,
      child: Scaffold(
          appBar: AppBar(
            title: appTitle,
            actions: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    color: acceptColor,
                    borderRadius: BorderRadius.circular(100)),
                padding: EdgeInsets.all(2.0),
                child: GestureDetector(
                  onTap: () {
                    print('User clicked');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserProfile()),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage:
                        getBackgroundImage(myUser!.profile_picture),
                  ),
                ),
              ),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HelpUser()),
                        );
                      },
                      child: Text('Help'),
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
            bottom: TabBar(
              isScrollable: true,
              labelStyle: TextStyle(color: primary),
              tabs: userTapPotions.map((e) {
                return Tab(
                  text: e,
                );
              }).toList(),
              labelColor: Colors.white,
              indicator: BoxDecoration(
                  // Customize the indicator
                  color: primary,
                  borderRadius: BorderRadius.circular(4.0),
                  gradient: LinearGradient(colors: [
                    primaryDeep,
                    primaryLight
                  ]) // Set the color of the selected tab
                  ),
            ),
          ),
          body: TabBarView(
            children: userTapPotions.map((e) {
              // if (e == 'All') {
              //   return Container(
              //     child: FutureBuilder(
              //       future: allocationData,
              //       builder:
              //           (context, AsyncSnapshot<AllocationList?> snapshot) {
              //         if (snapshot.hasData) {
              //           // return Container();
              //           return createAllocationPage(
              //               snapshot.data!.allocations, context);
              //         } else {
              //           return Container(
              //             child: Center(child: CircularProgressIndicator()),
              //           );
              //         }
              //       },
              //     ),
              //   );
              // }

              return Container(
                child: isDataLoaded
                    ? createAllocationPage(
                        catagory_wise_allocations![e.toLowerCase()], context)
                    : Container(
                        child: Center(child: CircularProgressIndicator()),
                      ),
              );
            }).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showDialog(context);
            },
            child: Icon(Icons.add),
          )),
    );
  }

  getBackgroundImage(String? profile_picture) {
    if (profile_picture == null) {
      return AssetImage('images/man.png');
    } else {
      return NetworkImage('$hostImageUrl${myUser!.profile_picture}');
    }
  }

  Widget createAllocationPage(
      List<Allocation>? allocations, BuildContext context) {
    if (allocations!.length == 0) {
      return Center(
        child: Text("Empty"),
      );
    }
    return SingleChildScrollView(
      
      scrollDirection: Axis.vertical,
      child: Column(
        
          children: allocations.map(
        (e) {
          return allocationItemBuilder(e);
        },
      ).toList()),
    );
  }

  Widget allocationItemBuilder(Allocation allocation) {
    return GestureDetector(
      onTap: () {
        print('${allocation.id} id clicked.');
        if (allocation.is_user_seen == 0) {
          updateSeenStatus(allocation.id ?? -1);
          setState(() {
            allocation.is_user_seen = 1;
          });
        }
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RequestDetails(user: myUser, allocation: allocation)),
        );
      },
      child: getAllocationItem(allocation, false),
    );
  }

  updateSeenStatus(int id) {
    BookingNetwork bookingNetwork =
        BookingNetwork(url: '/api/v1/public/allocation/update');
    bookingNetwork.update(id, 'is_user_seen', '1');
  }

  void _showDialog(BuildContext context) {
    final _scrollController = ScrollController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conditions'),
          content: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Column(
                  children: conditions.map((e) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        title: Text('$e'),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(''),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllocationRequest()),
                      );
                    },
                    child: Text('Accept')),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 2000),
                  curve: Curves.easeInOut,
                );
              },
              child: Text('Please make Scroll'),
            ),
          ],
        );
      },
    );
  }
}
