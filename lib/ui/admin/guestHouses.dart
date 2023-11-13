import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/admin/GuestHouseModel.dart';
import 'package:guest_house_pust/network/admin/guestHouseApi.dart';
import 'package:guest_house_pust/ui/admin/house/createHouse.dart';
import 'package:guest_house_pust/ui/admin/house/roomsPage.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';

class Houses extends StatefulWidget {
  const Houses({super.key});

  @override
  State<Houses> createState() => _HousesState();
}

class _HousesState extends State<Houses> {
  Future<GuestHouseList?>? house_list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadGuestHouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateHouse()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: house_list,
            builder: (context, AsyncSnapshot<GuestHouseList?> snapshot) {
              if (snapshot.hasData) {
                // return Container();
                return createHousesPage(snapshot.data!.houses, context);
              } else {
                return Container(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void loadGuestHouses() async {
    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/guest-houses');
    house_list = api.loadHouses();
    house_list!.then((value) {
      print("house list size ${value!.houses!.length}");
    });
  }

  Widget createHousesPage(List<GuestHouseModel>? houses, BuildContext context) {
    return Column(
        children: houses!.map((e) {
      return houseItemBuilder(e);
    }).toList());
  }

  Widget houseItemBuilder(GuestHouseModel house) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: primary),
          borderRadius: BorderRadius.circular(6),
          color: primaryExtraLight),
      child: ListTile(
        leading: CircleAvatar(child: Text('${house.id}')),
        title: Text('${house.title}'),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('address : ${house.address}'),
          Text('Number of rooms : ${house.roomList!.rooms!.length}')
        ]),
        trailing: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RoomsPage(
                            guestHouseModel: house,
                          )));
            },
            child: Text('Details')),
      ),
    );
  }
}
