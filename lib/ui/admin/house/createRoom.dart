import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/admin/roomModel.dart';
import 'package:guest_house_pust/network/admin/guestHouseApi.dart';
import 'package:guest_house_pust/ui/admin/adminHome.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class CreateRoom extends StatefulWidget {
  final int? guestHouseId;
  final String? title;
  final RoomModel? room;
  const CreateRoom({super.key, this.guestHouseId, this.title, this.room});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final _form_key = GlobalKey<FormState>();
  final _numberController = TextEditingController();

  int selected_room_type = 0;

  Future<RoomList?>? room_list;
  bool is_room_list_show = false;
  int? selected_room_id;
  String? selected_room_number;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.room != null) {
      _numberController.text = '${widget.room!.number}';
      if (widget.room!.room_type == 'AC') {
        selected_room_type = 1;
      } else {
        selected_room_type = 2;
      }
      selected_room_id = widget.room!.parent_id;
    }

    loadAllParentRoom(widget.guestHouseId ?? 0);
  }

  void handleRoomTypeValueChange(int? value) {
    setState(() {
      selected_room_type = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: appTitle),
      body: Stack(
        children: [
          // Background
          Container(
            // height: MediaQuery.of(context).size.height*0.5,
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset('images/home_illustrator.png'),
            ),
          ),
          // Lgin UI
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                topText(
                    (widget.room == null) ? 'Create New Room' : 'Update Room'),
                topText('On'),
                topText('${widget.title}'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _form_key,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: _numberController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Room Number',
                                  hintText: 'Write Room Number'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Room number is required.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // drop down

                            SizedBox(
                              height: 10,
                            ),
                            // room type
                            Row(
                              children: [
                                Text(
                                  'Room Type',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: 1,
                                        groupValue: selected_room_type,
                                        onChanged: handleRoomTypeValueChange,
                                      ),
                                      Text('AC.'),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Radio(
                                        value: 2,
                                        groupValue: selected_room_type,
                                        onChanged: handleRoomTypeValueChange,
                                      ),
                                      Text('Non AC.'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            is_room_list_show
                                ? FutureBuilder(
                                    future: room_list,
                                    builder: (context,
                                        AsyncSnapshot<RoomList?> snapshot) {
                                      if (snapshot.hasData) {
                                        // return Container();
                                        return createRoomsPage(
                                            snapshot.data!.rooms, context);
                                      } else {
                                        return Container(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                      }
                                    },
                                  )
                                : Container(),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color?>(
                                            primary)),
                                onPressed: () {
                                  setState(() {
                                    is_room_list_show = !is_room_list_show;
                                  });
                                },
                                child: Text(is_room_list_show
                                    ? 'Hide Room List'
                                    : 'Show Rooms')),
                            (selected_room_number == null)
                                ? Container()
                                : Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          'Selected Room Number : ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text('$selected_room_number'),
                                      ],
                                    ),
                                  ),
                            SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryDeep),
                              onPressed: () {
                                print('create Room clicked.');
                                if (selected_room_type == 0) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text('Room type is not selected Yeat'),
                                    backgroundColor: dangerColor,
                                  ));
                                } else if (_form_key.currentState!.validate()) {
                                  // userLogin(context, _emailController.text,
                                  //     _passwordController.text);
                                  if(widget.room == null){
                                    sendRoomDate(
                                      context,
                                      RoomModel(
                                        number: _numberController.text,
                                        guest_house_id:
                                            '${widget.guestHouseId}',
                                        room_type: type_of_room_list[
                                            selected_room_type],
                                      ));
                                  }else{
                                    updateRoomDate(
                                      context,
                                      RoomModel(
                                        id: widget.room!.id,
                                        number: _numberController.text,
                                        guest_house_id:
                                            '${widget.guestHouseId}',
                                        room_type: type_of_room_list[
                                            selected_room_type],
                                      ));
                                  }

                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(SnackBar(
                                  //   content: Text(
                                  //       'Data send success. Wait for server response.'),
                                  //   backgroundColor: acceptColor,
                                  // ));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text((widget.room==null)?'Create':'Update'),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget topText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  void sendRoomDate(BuildContext context, RoomModel roomModel) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for server response');

    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/rooms/create');
    Map<String, dynamic> data =
        await api.createRoom(roomModel, selected_room_id);

    pd.close();

    if (data['status'] == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message']),
        backgroundColor: dangerColor,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message']),
        backgroundColor: acceptColor,
      ));
      Navigator.popUntil(context, (route) => false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminHome()),
      );
    }
  }

  Widget createRoomsPage(List<RoomModel>? rooms, BuildContext context) {
    return Column(
      children: rooms!.map((e) => roomItemBuilder(e)).toList(),
    );
  }

  Widget roomItemBuilder(RoomModel e) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1, color: primary)),
      child: ListTile(
        onTap: () {
          if (selected_room_id == e.id) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  '${e.id} ${e.number} room is rmoved from the selection.'),
              backgroundColor: dangerColor,
            ));
            setState(() {
              selected_room_id = null;
              selected_room_number = null;
            });
          } else {
            setState(() {
              selected_room_id = e.id;
              selected_room_number = e.number;
            });
          }
        },
        tileColor: primaryExtraLight,
        title: Text('Room Number : ${e.number}'),
        trailing: Text('Room Type : ${e.room_type}'),
      ),
    );
  }

  void loadAllParentRoom(int id) async {
    GuestHouseApi api =
        GuestHouseApi(url: '/api/v1/admin/guest-houses/base-rooms');
    room_list = api.loadParentRoom(id);
    if (widget.room != null && widget.room!.parent_id != null) {
      room_list!.then((value) {
        for (RoomModel room in value!.rooms!) {
          if (room.id == widget.room!.parent_id) {
            setState(() {
              selected_room_number = room.number;
            });
            break;
          }
        }
      });
    }
  }
  
  void updateRoomDate(BuildContext context, RoomModel roomModel) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for server response');

    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/rooms/update');
    Map<String, dynamic> data =
        await api.updateRoom(roomModel, selected_room_id);

    pd.close();

    if (data['status'] == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message']),
        backgroundColor: dangerColor,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message']),
        backgroundColor: acceptColor,
      ));
      Navigator.popUntil(context, (route) => false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminHome()),
      );
    }
  }
}
