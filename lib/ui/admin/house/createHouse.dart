import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/admin/GuestHouseModel.dart';
import 'package:guest_house_pust/network/admin/guestHouseApi.dart';
import 'package:guest_house_pust/ui/admin/adminHome.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class CreateHouse extends StatefulWidget {
  final GuestHouseModel? guestHouseModel;
  const CreateHouse({super.key, this.guestHouseModel});

  @override
  State<CreateHouse> createState() => _CreateHouseState();
}

class _CreateHouseState extends State<CreateHouse> {
  final _form_key = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _logController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.guestHouseModel != null) {
      _titleController.text = '${widget.guestHouseModel!.title}';
      _addressController.text = '${widget.guestHouseModel!.address}';
      _latController.text = '${widget.guestHouseModel!.lat}';
      _logController.text = '${widget.guestHouseModel!.log}';
    }
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
                Text(
                  (widget.guestHouseModel == null)
                      ? 'Create New Guest House'
                      : 'Update Guest House Infrmation',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
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
                              controller: _titleController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Title',
                                  hintText: 'Write Guest House Title'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Guest House title is required.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Address',
                                  hintText: 'Write Guest House Address.'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Guest House Address is required.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _latController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Latitude',
                                        hintText: 'Write Latitude'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Latitude is required.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _logController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Longitude',
                                        hintText: 'Write longitude'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Longitude is required.';
                                      }
                                      return null;
                                    },
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
                                print('create clicked.');

                                if (_form_key.currentState!.validate()) {
                                  // userLogin(context, _emailController.text,
                                  //     _passwordController.text);
                                  if (widget.guestHouseModel == null) {
                                    sendHouseDate(
                                        context,
                                        GuestHouseModel(
                                          title: _titleController.text,
                                          address: _addressController.text,
                                          lat:
                                              double.parse(_latController.text),
                                          log:
                                              double.parse(_logController.text),
                                        ));
                                  } else {
                                    updateHouseDate(
                                        context,
                                        widget.guestHouseModel!.id,
                                        GuestHouseModel(
                                          title: _titleController.text,
                                          address: _addressController.text,
                                          lat:
                                              double.parse(_latController.text),
                                          log:
                                              double.parse(_logController.text),
                                        ));
                                  }

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => RegistrationPage()));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text((widget.guestHouseModel == null)
                                    ? 'Create'
                                    : 'Update'),
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

  void sendHouseDate(
      BuildContext context, GuestHouseModel guestHouseModel) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for response');

    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/guest-houses/create');
    Map<String, dynamic> data = await api.createHouse(guestHouseModel);
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

  void updateHouseDate(
      BuildContext context, int? id, GuestHouseModel guestHouseModel) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for response');

    GuestHouseApi api = GuestHouseApi(url: '/api/v1/admin/guest-houses/update');
    Map<String, dynamic> data = await api.updateHouse(id!, guestHouseModel);
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
