import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/network/client/bookingApiHandel.dart';
import 'package:guest_house_pust/ui/client/userHome.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/components.dart';
import 'package:guest_house_pust/util/myInt.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AllocationRequest extends StatefulWidget {
  const AllocationRequest({super.key});

  @override
  State<AllocationRequest> createState() => _AllocationRequestState();
}

class _AllocationRequestState extends State<AllocationRequest> {
  final _form_key = GlobalKey<FormState>();
  final _guestController = TextEditingController();
  final _guestNameRelationController = TextEditingController();

  bool _isFromDateSelected = false;
  bool _isToDateSelected = false;

  int selected_guest_house =
      0; // Initialize the selected radio to the first option.
  MyInt selected_booking_type = MyInt(0);
  MyInt selected_room_type = MyInt(0);
  MyInt selected_stay = MyInt(0);
  MyInt selected_guest_type = MyInt(0);
  MyInt selected_booking_for = MyInt(0);

  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  // TimeOfDay _selectedTime = TimeOfDay.now();
  // int _dayDifference = 0;
  // int _totalCharge = 0;

  void handleGuestHouseTypeValueChange(int? value) {
    setState(() {
      selected_guest_house = value!;
    });
  }

  // void handleBookingTypeValueChange(int? value) {
  //   // int totalCharge = 0;
  //   // try {
  //   //   totalCharge = _dayDifference *
  //   //       price_according_to_roomtype[type_of_booking_list[value!]]![
  //   //           type_of_room_list[selected_room_type]]! *
  //   //       int.parse(_guestController.text);
  //   //   print('totl charge : $totalCharge');
  //   // } catch (e) {
  //   //   totalCharge = 0;
  //   //   print('totl ee charge : $e');
  //   // }
  //   setState(() {
  //     selected_booking_type = value!;
  //     // print("radio : $selected_booking_type");
  //     // _totalCharge = totalCharge;
  //   });
  // }

  // void handleRoomTypeValueChange(int? value) {
  //   // int totalCharge = 0;
  //   // try {
  //   //   totalCharge = _dayDifference *
  //   //       price_according_to_roomtype[type_of_booking_list[
  //   //           selected_booking_type]]![type_of_room_list[value!]]! *
  //   //       int.parse(_guestController.text);
  //   //   print('totl charge : $totalCharge');
  //   // } catch (e) {
  //   //   totalCharge = 0;
  //   //   print('totl ee charge : $e');
  //   // }
  //   setState(() {
  //     selected_room_type = value!;
  //     // print("radio : $selected_room_type");
  //     // _totalCharge = totalCharge;
  //   });
  // }

  Future<void> _selectFormDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    // int dayDiff = 0;
    // int totalCharge = 0;

    if (picked != null) {
      // if (_selectedToDate == null) {
      //   // do nothing
      // } else {
      //   // set diffrence and
      //   // print("cmp : ${picked.compareTo(_selectedToDate!)}");
      //   // if (picked.compareTo(_selectedToDate!) >= 0) {
      //   //   // Date can not select show an error message
      //   //   print('Date is not valid');
      //   //   setState(() {
      //   //     _selectedFromDate = null;
      //   //     _isFormDateSelected = false;
      //   //     // _dayDifference = 0;
      //   //     // _totalCharge = 0;
      //   //   });
      //   //   return;
      //   // } else {
      //   //   // dayDiff = _selectedToDate!.difference(picked).inDays + 1;
      //   //   // print('diffrence is : $dayDiff');
      //   // }
      // }
      // try {
      //   totalCharge = dayDiff *
      //       price_according_to_roomtype[
      //               type_of_booking_list[selected_booking_type]]![
      //           type_of_room_list[selected_room_type]]! *
      //       int.parse(_guestController.text);
      //   print('totl charge : $totalCharge');
      // } catch (e) {
      //   totalCharge = 0;
      //   print('totl ee charge : $e');
      // }

      final TimeOfDay? pickedTime = await _selectTime(context);
      String sHoure = '00:00';
      String sMinute = '00:00';
      if (pickedTime != null) {
        print(pickedTime.toString());
        sHoure = pickedTime.hour.toString();
        sMinute = pickedTime.minute.toString();
        if (sHoure.length == 1) {
          sHoure = '0$sHoure';
        }
        if (sMinute.length == 1) {
          sMinute = '0$sMinute';
        }
      }
      print(
          '${picked.toString().substring(0, 10)} ${pickedTime!.hour}:${pickedTime.minute}:00.000');

      _selectedFromDate = DateTime.parse(
          '${picked.toString().substring(0, 10)} $sHoure:$sMinute:00.000');
      if (_selectedToDate != null &&
          _selectedToDate!.compareTo(_selectedFromDate!) <= 0) {
        // Date can not select show an error message
        showToast(context, 'Selected data is not valid.', dangerColor);
        setState(() {
          _selectedFromDate = null;
          _isFromDateSelected = false;
        });
        return;
      }
      setState(() {
        _isFromDateSelected = true;
        // _dayDifference = dayDiff;
        // _totalCharge = totalCharge;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedToDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    // int dayDiff = 0;
    // int totalCharge = 0;

    if (picked != null) {
      // if (_selectedFromDate == null) {
      //   // do nothing
      // } else {
      //   // set diffrence and
      //   // print("cmp : ${picked.compareTo(_selectedFromDate!)}");
      //   // if (picked.compareTo(_selectedFromDate!) <= 0) {
      //   //   // Date can not select show an error message
      //   //   print('Date is not valid');
      //   //   setState(() {
      //   //     _selectedToDate = null;
      //   //     _isToDateSelected = false;
      //   //     // _dayDifference = dayDiff;
      //   //     // _totalCharge = totalCharge;
      //   //   });
      //   //   return;
      //   // } else {
      //   //   // dayDiff = picked.difference(_selectedFromDate!).inDays + 1;
      //   //   // print('diffrence is : $dayDiff');
      //   // }
      // }
      // try {
      //   totalCharge = dayDiff *
      //       price_according_to_roomtype[
      //               type_of_booking_list[selected_booking_type]]![
      //           type_of_room_list[selected_room_type]]! *
      //       int.parse(_guestController.text);
      //   print('totl charge : $totalCharge');
      // } catch (e) {
      //   totalCharge = 0;
      //   print('totl ee charge : $e');
      // }
      final TimeOfDay? pickedTime = await _selectTime(context);
      String sHoure = '00:00';
      String sMinute = '00:00';
      if (pickedTime != null) {
        print('To Picked time : ${pickedTime.toString()}');
        sHoure = pickedTime.hour.toString();
        sMinute = pickedTime.minute.toString();
        if (sHoure.length == 1) {
          sHoure = '0$sHoure';
        }
        if (sMinute.length == 1) {
          sMinute = '0$sMinute';
        }
      }
      // print(
      //     '${picked.toString().substring(0, 10)} ${pickedTime!.hour}:${pickedTime.minute}:00.000');
      _selectedToDate = DateTime.parse(
          '${picked.toString().substring(0, 10)} $sHoure:$sMinute:00.000');

      // print('to : $_selectedToDate From : $_selectedFromDate');
      // print(
      //     'Date valid : ${_selectedToDate!.compareTo(_selectedFromDate!)} ::: ${_selectedToDate!.isAtSameMomentAs(_selectedFromDate!)}');

      if (_selectedFromDate != null &&
          _selectedToDate!.compareTo(_selectedFromDate!) <= 0) {
        // Date can not select show an error message
        print('Date is not valid : ${picked.compareTo(_selectedFromDate!)}');
        showToast(context, 'Selected data is not valid.', dangerColor);
        setState(() {
          _selectedToDate = null;
          _isToDateSelected = false;
        });
        return;
      }
      setState(() {
        _isToDateSelected = true;
      });
      // setState(() {
      //   _selectedToDate = picked;
      //   _isToDateSelected = true;
      //   // _dayDifference = dayDiff;
      //   // _totalCharge = totalCharge;
      // });
    }
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: appTitle,
      ),
      body: Container(
        child: Stack(
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
            // Date Field
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    'Booking Form',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
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
                              headingText("For"),
                              Column(
                                children: type_of_guest_house_list.entries
                                    .map((e) => Row(
                                          children: [
                                            Radio(
                                              value: e.key,
                                              groupValue: selected_guest_house,
                                              onChanged:
                                                  handleGuestHouseTypeValueChange,
                                            ),
                                            Text('${e.value}'),
                                          ],
                                        ))
                                    .toList(),
                              ),
                              // Row(
                              //   children: [
                              //     Radio(
                              //       value: 1,
                              //       groupValue: selected_guest_house,
                              //       onChanged: handleGuestHouseTypeValueChange,
                              //     ),
                              //     Text(type_of_guest_house_list[1]),
                              //   ],
                              // ),
                              // Row(
                              //   children: [
                              //     Radio(
                              //       value: 2,
                              //       groupValue: selected_guest_house,
                              //       onChanged: handleGuestHouseTypeValueChange,
                              //     ),
                              //     Text(type_of_guest_house_list[2]),
                              //   ],
                              // ),
                              SizedBox(
                                height: 15,
                              ),
                              headingText("Type of booking"),
                              getRadioRow(selected_booking_type, {
                                1: 'For Personal Use.',
                                2: 'For Official Use.'
                              }),
                              // Row(
                              //   children: [
                              //     SingleChildScrollView(
                              //       scrollDirection: Axis.horizontal,
                              //       child: Row(
                              //         children: [
                              //           Radio(
                              //             value: 1,
                              //             groupValue: selected_booking_type,
                              //             onChanged:
                              //                 handleBookingTypeValueChange,
                              //           ),
                              //           Text('For Personal Use.'),
                              //           SizedBox(
                              //             width: 15,
                              //           ),
                              //           Radio(
                              //             value: 2,
                              //             groupValue: selected_booking_type,
                              //             onChanged:
                              //                 handleBookingTypeValueChange,
                              //           ),
                              //           Text('For Official Use.'),
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 15,
                              ),
                              headingText("Type of Room"),
                              getRadioRow(
                                  selected_room_type, {1: 'AC', 2: 'Non AC'}),
                              // Row(
                              //   children: [
                              //     SingleChildScrollView(
                              //       scrollDirection: Axis.horizontal,
                              //       child: Row(
                              //         children: [
                              //           Radio(
                              //             value: 1,
                              //             groupValue: selected_room_type,
                              //             onChanged: handleRoomTypeValueChange,
                              //           ),
                              //           Text('AC.'),
                              //           SizedBox(
                              //             width: 15,
                              //           ),
                              //           Radio(
                              //             value: 2,
                              //             groupValue: selected_room_type,
                              //             onChanged: handleRoomTypeValueChange,
                              //           ),
                              //           Text('Non AC.'),
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 15,
                              ),
                              headingText("For night stay"),
                              getRadioRow(selected_stay, {1: 'Yes', 2: 'No'}),
                              SizedBox(
                                height: 15,
                              ),
                              headingText("Guest Type"),
                              getRadioRow(selected_guest_type,
                                  {1: 'Male', 2: 'Female', 3: 'Family'}),
                              SizedBox(
                                height: 15,
                              ),
                              headingText("Date and Time of Stay"),
                              SizedBox(
                                height: 5,
                              ),
                              // From Date Selecter
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _isFromDateSelected
                                          ? Colors.grey
                                          : Colors.red,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: ListTile(
                                  title: Text(
                                    _selectedFromDate != null
                                        ? 'From: ${_selectedFromDate!.toLocal().toString().substring(0, 16)}'
                                        : 'From ?',
                                  ),
                                  trailing: Icon(Icons.calendar_today),
                                  onTap: () {
                                    _selectFormDate(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              // To Date Selecter
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _isToDateSelected
                                          ? Colors.grey
                                          : Colors.red,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: ListTile(
                                  title: Text(
                                    _selectedToDate != null
                                        ? 'To: ${_selectedToDate!.toLocal().toString().substring(0, 16)}'
                                        : 'To ?',
                                  ),
                                  trailing: Icon(Icons.calendar_today),
                                  onTap: () {
                                    _selectToDate(context);
                                  },
                                ),
                              ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              // Container(
                              //     padding: EdgeInsets.symmetric(
                              //         vertical: 16, horizontal: 10),
                              //     decoration: BoxDecoration(
                              //         border: Border.all(
                              //           color: Colors.grey,
                              //           width: 1,
                              //         ),
                              //         borderRadius: BorderRadius.circular(5)),
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text("Total days of stay : "),
                              //         Text("$_dayDifference days"),
                              //       ],
                              //     )),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: _guestController,
                                keyboardType: TextInputType.number,
                                // onChanged: (value) {
                                //   int totalCharge = 0;
                                //   try {
                                //     totalCharge = _dayDifference *
                                //         price_according_to_roomtype[
                                //                 type_of_booking_list[
                                //                     selected_booking_type]]![
                                //             type_of_room_list[
                                //                 selected_room_type]]! *
                                //         int.parse(_guestController.text);
                                //     print('totl charge : $totalCharge');
                                //   } catch (e) {
                                //     totalCharge = 0;
                                //     print('totl ee charge : $e');
                                //   }
                                //   setState(() {
                                //     _totalCharge = totalCharge;
                                //   });
                                // },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Number of Guest',
                                    hintText: 'Write number of guest'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Number of guest required.';
                                  }
                                  return null;
                                },
                              ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              // Container(
                              //     padding: EdgeInsets.symmetric(
                              //         vertical: 16, horizontal: 4),
                              //     decoration: BoxDecoration(
                              //         border: Border.all(
                              //           color: Colors.grey,
                              //           width: 1,
                              //         ),
                              //         borderRadius: BorderRadius.circular(5)),
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         headingText("Total Charge : "),
                              //         headingText("$_totalCharge TK"),
                              //       ],
                              //     )),
                              SizedBox(
                                height: 15,
                              ),
                              headingText('Guests are : '),
                              getRadioRow(selected_booking_for, {
                                1: 'My Self',
                                2: 'On Behalf of',
                              }),

                              (selected_booking_for.value == 2)
                                  ? Container(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Please mention their names and relations, separating them by commas(,) :',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TextFormField(
                                              controller:
                                                  _guestNameRelationController,
                                              maxLines: 3,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Name & Relation',
                                                  hintText:
                                                      'Example: name 1, father\nname 2, mother\nname 3,wife'),
                                              validator: (value) {
                                                if (value!.isEmpty &&
                                                    selected_booking_for
                                                            .value ==
                                                        2) {
                                                  return 'Guest Name & Relation are required.';
                                                }
                                                return null;
                                              },
                                            )
                                          ]),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 50,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryDeep),
                                onPressed: () {
                                  print('Login clicked.');
                                  if (selected_guest_house == 0) {
                                    showMessage(
                                        context,
                                        "Guest House is not selected yet.",
                                        dangerColor);
                                    return;
                                  } else if (selected_booking_type.value == 0) {
                                    showMessage(
                                        context,
                                        "Booking type is not selected yet.",
                                        dangerColor);
                                    return;
                                  } else if (selected_room_type.value == 0) {
                                    showMessage(
                                        context,
                                        "Room type is not selected yet.",
                                        dangerColor);
                                    return;
                                  } else if (selected_stay.value == 0) {
                                    showMessage(
                                        context,
                                        "Night stay or not option is not selected yet.",
                                        dangerColor);
                                    return;
                                  } else if (selected_guest_type.value == 0) {
                                    showMessage(
                                        context,
                                        "Guest type is not selected yet.",
                                        dangerColor);
                                    return;
                                  } else if (!_isFromDateSelected) {
                                    showMessage(
                                        context,
                                        "From date is not selected yet.",
                                        dangerColor);
                                    return;
                                  } else if (!_isToDateSelected) {
                                    showMessage(
                                        context,
                                        "To date is not selected yet.",
                                        dangerColor);
                                    return;
                                  } else if (selected_booking_for.value == 0) {
                                    showMessage(
                                        context,
                                        "Mention who are guests is messing.",
                                        dangerColor);
                                    return;
                                  }

                                  if (_form_key.currentState!.validate()) {
                                    print(
                                        'type of booking : $selected_booking_type');
                                    print('type of room : $selected_room_type');
                                    print('From date : $_selectedFromDate');
                                    print('To date : $_selectedToDate');
                                    // print('day count : $_dayDifference');
                                    print(
                                        'number of guest : $_guestController');
                                    bookingRequest(
                                        context,
                                        Allocation(
                                          user_id: myUser!.id,
                                          guest_house_id: selected_guest_house,
                                          booking_type: type_of_booking_list[
                                              selected_booking_type.value],
                                          room_type: type_of_room_list[
                                              selected_room_type.value],
                                          allocation_purpose: type_of_stays[
                                              selected_stay.value],
                                          boarder_type: type_of_guest_gender[
                                              selected_guest_type.value],
                                          boarding_date:
                                              _selectedFromDate.toString(),
                                          departure_date:
                                              _selectedToDate.toString(),
                                          guest_count:
                                              int.parse(_guestController.text),
                                          behalf_of:
                                              (selected_booking_for.value == 1)
                                                  ? 'My Self'
                                                  : _guestNameRelationController
                                                      .text,
                                        ));
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => RegistrationPage()));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text('Send Request'),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
      ),
    );
  }

  Widget getRadioRow(MyInt option, Map<int, String> options) {
    return Row(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.entries.map((e) {
              return Row(
                children: [
                  Radio(
                    value: e.key,
                    groupValue: option.value,
                    onChanged: (value) {
                      setState(() {
                        option.value = value ?? 0;
                      });
                    },
                  ),
                  Text('${e.value}'),
                  SizedBox(
                    width: 15,
                  ),
                ],
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget headingText(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void showMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }

  void bookingRequest(BuildContext context, Allocation booking) {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for response');

    BookingNetwork network =
        BookingNetwork(url: "/api/v1/public/allocation/new");
    Future data = network.sendBookingRequest(booking);
    data.then((value) {
      pd.close();
      print("data is : $value");
      if (value['status'] == 'error') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['message']),
          backgroundColor: dangerColor,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['message']),
          backgroundColor: acceptColor,
        ));
        Navigator.popUntil(context, (route) => false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserHome()),
        );
      }
    });
  }
}
