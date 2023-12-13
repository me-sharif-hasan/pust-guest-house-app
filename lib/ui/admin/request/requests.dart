import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/network/client/bookingApiHandel.dart';
import 'package:guest_house_pust/ui/admin/request/adminRequestDetails.dart';
import 'package:guest_house_pust/util/components.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RequestsPageAdmin extends StatefulWidget {
  final String? status;
  const RequestsPageAdmin({super.key, this.status});

  @override
  State<RequestsPageAdmin> createState() => _RequestsPageAdminState();
}

class _RequestsPageAdminState extends State<RequestsPageAdmin> {
  Future<AllocationList?>? allocationData;
  bool isDataLoaded = false;
  String limit = '100';
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BookingNetwork bookingNetwork =
        BookingNetwork(url: '/api/v1/admin/allocation');
    allocationData = bookingNetwork.loadAllocationsWithStatus(
        status: widget.status, limit: limit, page: '1');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: allocationData, builder: _createAllocationPage);
  }

  Widget _createAllocationPage(
      BuildContext context, AsyncSnapshot<AllocationList?> allocationList) {
    if (!allocationList.hasData) {
      return Center(child: CircularProgressIndicator());
    } else if (allocationList.data!.allocations!.length == 0) {
      return Center(
        child: Text("Empty"),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Column(
              children: allocationList.data!.allocations!.map(
            (e) {
              return allocationItemBuilder(e);
            },
          ).toList()),
          // Next Prev Container
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (page != 1)
                    ? ElevatedButton(
                        onPressed: () {
                          getData('${page - 1}');
                          setState(() {
                            page--;
                          });
                        },
                        child: Text('<-Prev'))
                    : Container(),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '$page',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                (page < total_page_with_status[widget.status]!)
                    ? ElevatedButton(
                        onPressed: () {
                          getData('${page + 1}');
                          setState(() {
                            page++;
                          });
                        },
                        child: Text('Next->'),
                      )
                    : Container(),
              ],
            ),
          ),
          Text(
            'Total Page : ${total_page_with_status[widget.status]}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget allocationItemBuilder(Allocation allocation) {
    return GestureDetector(
        onTap: () {
          print('${allocation.id} id clicked.');
          print('Seen status : ${allocation.is_admin_seen}');
          if (allocation.is_admin_seen == 0) {
            _updateSeenStatus(allocation.id ?? -1);
            setState(() {
              allocation.is_admin_seen = 1;
            });
          }
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AdminRequestDetails(allocation: allocation)),
          );
        },
        child: getAllocationItemAdmin(allocation, true));
  }

  _updateSeenStatus(int id) {
    BookingNetwork bookingNetwork =
        BookingNetwork(url: '/api/v1/admin/allocation/update');
    bookingNetwork.update(id, 'is_admin_seen', '1');
  }

  getData(String page) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for server response');

    BookingNetwork bookingNetwork =
        BookingNetwork(url: '/api/v1/admin/allocation');
    allocationData = bookingNetwork.loadAllocationsWithStatus(
        status: widget.status, limit: limit, page: page);
    allocationData!.then((value) {
      return pd.close();
    });
  }
}
