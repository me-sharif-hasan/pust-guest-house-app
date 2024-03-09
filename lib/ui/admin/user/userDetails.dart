import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/client/bookingApiHandel.dart';
import 'package:guest_house_pust/ui/admin/request/adminRequestDetails.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/components.dart';
import 'package:guest_house_pust/util/variables.dart';

class UserDetailsPage extends StatefulWidget {
  final User? user;
  const UserDetailsPage({super.key, this.user});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  Future<AllocationList?>? allocationData;
  bool isDataLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    print('User page details ${widget.user!.id}');
    super.initState();
    _getAllocationData(context);
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
                margin: EdgeInsets.only(top: 10, left: 15, right: 10),
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
                              Text(
                                "${widget.user!.name}",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Opacity(
                                opacity: 0.6,
                                child: Text(
                                  "${widget.user!.title}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(top: 15, bottom: 15),
                            height: MediaQuery.of(context).size.width * 0.31,
                            width: MediaQuery.of(context).size.width * 0.31,
                            decoration: BoxDecoration(
                              border: Border.all(width: 4, color: dangerColor),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: CircleAvatar(
                              backgroundImage: getBackgroundImage(
                                  widget.user!.profile_picture),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    rowBuilder("Department : ", "${widget.user!.department}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Phone : ", "${widget.user!.phone}"),
                    SizedBox(
                      height: 10,
                    ),
                    rowBuilder("Email : ", "${widget.user!.email}"),
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FutureBuilder(
                      future: allocationData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: snapshot.data!.allocations!
                                .map((e) => _allocationItemBuilder(e))
                                .toList(),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                    SizedBox(
                      height: 100,
                    )
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
          width: 20,
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: SelectableText(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }

  Widget _allocationItemBuilder(Allocation allocation) {
    return GestureDetector(
      onTap: () {
        print('${allocation.id} id clicked.');
        print('Seen status : ${allocation.is_admin_seen}');

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AdminRequestDetails(allocation: allocation)),
        );
      },
      // child: Text('he'),
      child: getAllocationItemAdmin(allocation, true),
    );
  }

  getBackgroundImage(String? profile_picture) {
    if (profile_picture == null) {
      return AssetImage('images/man.png');
    } else {
      return NetworkImage('http://$hostUrl${profile_picture}');
    }
  }

  void _getAllocationData(BuildContext context) async {
    print('data try to geting');

    BookingNetwork bookingNetwork =
        BookingNetwork(url: '/api/v1/admin/allocation');
    allocationData = bookingNetwork.loadAllocationsForSpecificUser(
        limit: '100', page: '1', userId: widget.user!.id);
    allocationData!.then((value) {
      print('------___----------${value!.allocations!.length}');
      setState(() {
        isDataLoaded = true;
      });
    });
  }
}
