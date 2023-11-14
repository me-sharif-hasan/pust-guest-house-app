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
          child: Center(
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
                          tileColor: primaryExtraLight,
                          title: Text('Room Number : ${e.number}'),
                          subtitle: Text('Room Type : ${e.room_type}'),
                        ),
                      ))
                  .toList(),
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
