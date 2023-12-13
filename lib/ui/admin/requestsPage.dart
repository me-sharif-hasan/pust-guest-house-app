import 'package:flutter/material.dart';
// import 'package:guest_house_pust/models/allocationModel.dart';
// import 'package:guest_house_pust/network/client/bookingApiHandel.dart';
// import 'package:guest_house_pust/ui/admin/request/adminRequestDetails.dart';
import 'package:guest_house_pust/ui/admin/request/requests.dart';
import 'package:guest_house_pust/util/colors.dart';
// import 'package:guest_house_pust/util/components.dart';
import 'package:guest_house_pust/util/variables.dart';
// import 'package:sn_progress_dialog/progress_dialog.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  // Future<AllocationList?>? allocationData;
  // bool isDataLoaded = false;
  // String limit = '100';
  // int page = 1;

  @override
  void initState() {
    super.initState();
    // BookingNetwork bookingNetwork =
    //     BookingNetwork(url: '/api/v1/admin/allocation');
    // allocationData = bookingNetwork.loadAllocations('/all', limit, '1');
    // allocationData!.then((value) async {
    //   print("DATA get success...");
    //   AllocationListCatagory allocationListCatagory =
    //       await AllocationListCatagory(allocationList: value);
    //   catagory_wise_allocations = await allocationListCatagory.build();
    //   setState(() {
    //     isDataLoaded = true;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: userTapPotions.length,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     getData(limit, '$page');
        //   },
        //   child: Icon(Icons.refresh),
        // ),
        body: TabBarView(
          children: userTapPotions.map((e) {
            return RequestsPageAdmin(
              status: e.toLowerCase(),
            );
            // return Container(
            //   child: isDataLoaded
            //       ? createAllocationPage(
            //           catagory_wise_allocations![e.toLowerCase()], context)
            //       : Container(
            //           child: Center(child: CircularProgressIndicator()),
            //         ),
            // );
          }).toList(),
        ),
      ),
    );
  }

  // getBackgroundImage(String? profile_picture) {
  //   if (profile_picture == null) {
  //     return AssetImage('images/man.png');
  //   } else {
  //     return NetworkImage('http://$hostUrl${myUser!.profile_picture}');
  //   }
  // }

  // Widget createAllocationPage(
  //     List<Allocation>? allocations, BuildContext context) {
  //   if (allocations!.length == 0) {
  //     return Center(
  //       child: Text("Empty"),
  //     );
  //   }
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.vertical,
  //     child: Column(
  //       children: [
  //         Column(
  //             children: allocations.map(
  //           (e) {
  //             return allocationItemBuilder(e);
  //           },
  //         ).toList()),
  //         Container(
  //           margin: EdgeInsets.symmetric(vertical: 20),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               (page != 1)
  //                   ? ElevatedButton(
  //                       onPressed: () {
  //                         getData(limit, '${page - 1}');
  //                         setState(() {
  //                           page--;
  //                         });
  //                       },
  //                       child: Text('<-Prev'))
  //                   : Container(),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Text(
  //                 '$page',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               (page < total_page)
  //                   ? ElevatedButton(
  //                       onPressed: () {
  //                         getData(limit, '${page + 1}');
  //                         setState(() {
  //                           page++;
  //                         });
  //                       },
  //                       child: Text('Next->'),
  //                     )
  //                   : Container(),
  //             ],
  //           ),
  //         ),
  //         Text(
  //           'Total Page : $total_page',
  //           style: TextStyle(fontSize: 16),
  //         ),
  //         SizedBox(
  //           height: 30,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget allocationItemBuilder(Allocation allocation) {
  //   return GestureDetector(
  //       onTap: () {
  //         print('${allocation.id} id clicked.');
  //         print('Seen status : ${allocation.is_admin_seen}');
  //         if (allocation.is_admin_seen == 0) {
  //           updateSeenStatus(allocation.id ?? -1);
  //           setState(() {
  //             allocation.is_admin_seen = 1;
  //           });
  //         }
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) =>
  //                   AdminRequestDetails(allocation: allocation)),
  //         );
  //       },
  //       child: getAllocationItemAdmin(allocation, true));
  // }

  // updateSeenStatus(int id) {
  //   BookingNetwork bookingNetwork =
  //       BookingNetwork(url: '/api/v1/admin/allocation/update');
  //   bookingNetwork.update(id, 'is_admin_seen', '1');
  // }

  // getData(String limit, String page) {
  //   ProgressDialog pd = ProgressDialog(context: context);
  //   pd.show(max: 100, msg: 'Wait for server response');

  //   BookingNetwork bookingNetwork =
  //       BookingNetwork(url: '/api/v1/admin/allocation');
  //   allocationData = bookingNetwork.loadAllocations('/all', limit, page);
  //   allocationData!.then((value) async {
  //     print("DATA get success...");
  //     AllocationListCatagory allocationListCatagory =
  //         await AllocationListCatagory(allocationList: value);
  //     catagory_wise_allocations = await allocationListCatagory.build();
  //     pd.close();
  //     setState(() {
  //       isDataLoaded = true;
  //     });
  //   });
  // }
}
