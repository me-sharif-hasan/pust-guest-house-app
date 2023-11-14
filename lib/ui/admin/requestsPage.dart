import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/network/client/bookingApiHandel.dart';
import 'package:guest_house_pust/ui/admin/request/adminRequestDetails.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  Future<AllocationList?>? allocationData;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    BookingNetwork bookingNetwork =
        BookingNetwork(url: '/api/v1/admin/allocation');
    allocationData = bookingNetwork.loadAllocations('/all');
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
        body: TabBarView(
          children: userTapPotions.map((e) {
            if (e == 'All') {
              return Container(
                child: FutureBuilder(
                  future: allocationData,
                  builder: (context, AsyncSnapshot<AllocationList?> snapshot) {
                    if (snapshot.hasData) {
                      // return Container();
                      return createAllocationPage(
                          snapshot.data!.allocations, context);
                    } else {
                      return Container(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              );
            }

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
      ),
    );
  }

  getBackgroundImage(String? profile_picture) {
    if (profile_picture == null) {
      return AssetImage('images/man.png');
    } else {
      return NetworkImage('http://$hostUrl${myUser!.profile_picture}');
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
          children: allocations!.map(
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
        if (allocation.is_admin_seen == 0) {
          updateSeenStatus(allocation.id ?? -1);
          setState(() {
            allocation.is_admin_seen = 1;
          });
        }
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AdminRequestDetails(user: myUser, allocation: allocation)),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        decoration: BoxDecoration(
          color: (allocation.is_admin_seen == 0)
              ? primaryLight
              : primaryExtraLight,
          border: Border.all(width: 1.0, color: primaryDeep),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Text('${allocation.id}'),
          ),
          title: Text(
              "${type_of_guest_house_list[allocation.guest_house_id ?? 0]}"),
          subtitle: Text(
              "${allocation.boarding_date!.substring(0, 10)} to ${allocation.departure_date!.substring(0, 10)}"),
          trailing: Text('${allocation.status}'),
        ),
      ),
    );
  }

  updateSeenStatus(int id) {
    BookingNetwork bookingNetwork =
        BookingNetwork(url: '/api/v1/admin/allocation/update');
    bookingNetwork.update(id, 'is_admin_seen', '1');
  }
}
