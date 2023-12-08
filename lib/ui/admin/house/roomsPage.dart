import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/admin/GuestHouseModel.dart';
import 'package:guest_house_pust/ui/admin/house/createRoom.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';

class RoomsPage extends StatefulWidget {
  final GuestHouseModel? guestHouseModel;

  const RoomsPage({super.key, this.guestHouseModel});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appTitle),
      body: Container(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Text(
              '${widget.guestHouseModel!.title}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Column(
              children: widget.guestHouseModel!.roomList!.rooms!
                  .map((e) => Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 6.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1, color: primary)),
                        child: ListTile(
                          onLongPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateRoom(
                                          guestHouseId:
                                              widget.guestHouseModel!.id,
                                          title: widget.guestHouseModel!.title,
                                          room: e,
                                        )));
                          },
                          tileColor: primaryExtraLight,
                          title: Text((e.parent_id == null)
                              ? 'Room Number' + ' : ${e.number}'
                              : 'Bed Number' + ' : ${e.number}'),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  'Current Border : ${(e.border_count == null) ? 0 : e.border_count}'),
                              SizedBox(
                                width: 25,
                              ),
                              Text(
                                  'Total Beds : ${(e.parent_id == null) ? e.total_seat : 1}'),
                            ],
                          ),
                          trailing: Text('Type : ${e.room_type}'),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateRoom(
                        guestHouseId: widget.guestHouseModel!.id,
                        title: widget.guestHouseModel!.title,
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
