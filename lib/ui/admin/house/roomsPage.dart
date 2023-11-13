import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/admin/GuestHouseModel.dart';
import 'package:guest_house_pust/ui/admin/house/createRoom.dart';
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
          child: Column(
        children: [
          Text(''),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateRoom()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
