import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/admin/GuestHouseModel.dart';
import 'package:guest_house_pust/models/admin/roomModel.dart';
import 'package:guest_house_pust/network/admin/guestHouseApi.dart';
import 'package:guest_house_pust/ui/admin/adminHome.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';

class CreateRoom extends StatefulWidget {
  final int? guestHouseId;
  final String? title;
  const CreateRoom({super.key, this.guestHouseId, this.title});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final _form_key = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _houseIdController = TextEditingController();
  final _roomTypeController = TextEditingController();

  int selected_room_type = 0;

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
                topText('Create New Room'),
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
                            SizedBox(
                              height: 60,
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
                                  sendRoomDate(
                                      context,
                                      RoomModel(
                                        number: _numberController.text,
                                        guest_house_id:
                                            widget.guestHouseId ?? 1,
                                        room_type: type_of_room_list[
                                            selected_room_type],
                                      ));

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Data send success. Wait for server response.'),
                                    backgroundColor: acceptColor,
                                  ));

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => RegistrationPage()));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text('Create'),
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
    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/rooms/create');
    Map<String, dynamic> data = await api.createRoom(roomModel);

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
