import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/network/bookingApiHandel.dart';
import 'package:guest_house_pust/ui/client/userHome.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';

class AllocationRequest extends StatefulWidget {
  const AllocationRequest({super.key});

  @override
  State<AllocationRequest> createState() => _AllocationRequestState();
}

class _AllocationRequestState extends State<AllocationRequest> {
  final _form_key = GlobalKey<FormState>();
  final _guestController = TextEditingController();

  bool _isFormDateSelected = false;
  bool _isToDateSelected = false;

  int selected_booking_type =
      0; // Initialize the selected radio to the first option.
  int selected_room_type =
      0; // Initialize the selected radio to the first option.

  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  int _dayDifference = 0;
  int _totalCharge = 0;

  final List<String> type_of_booking_list = [
    "",
    "Personal Use",
    "Official Use"
  ];
  final List<String> type_of_room_list = ["", "AC", "Non AC"];
  final Map<String, Map<String, int>> price_according_to_roomtype = {
    "Personal Use": {
      "": 0,
      "AC": 300,
      "Non AC": 200,
    },
    "Official Use": {
      "": 0,
      "AC": 200,
      "Non AC": 100,
    },
    "": {
      "": 0,
      "AC": 0,
      "Non AC": 0,
    }
  };

  void handleBookingTypeValueChange(int? value) {
    int totalCharge = 0;
    try {
      totalCharge = _dayDifference *
          price_according_to_roomtype[type_of_booking_list[value!]]![
              type_of_room_list[selected_room_type]]! *
          int.parse(_guestController.text);
      print('totl charge : $totalCharge');
    } catch (e) {
      totalCharge = 0;
      print('totl ee charge : $e');
    }
    setState(() {
      selected_booking_type = value!;
      print("radio : $selected_booking_type");
      _totalCharge = totalCharge;
    });
  }

  void handleRoomTypeValueChange(int? value) {
    int totalCharge = 0;
    try {
      totalCharge = _dayDifference *
          price_according_to_roomtype[type_of_booking_list[
              selected_booking_type]]![type_of_room_list[value!]]! *
          int.parse(_guestController.text);
      print('totl charge : $totalCharge');
    } catch (e) {
      totalCharge = 0;
      print('totl ee charge : $e');
    }
    setState(() {
      selected_room_type = value!;
      print("radio : $selected_room_type");
      _totalCharge = totalCharge;
    });
  }

  Future<void> _selectFormDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    int dayDiff = 0;
    int totalCharge = 0;

    if (picked != null && picked != _selectedFromDate) {
      if (_selectedToDate == null) {
        // do nothing
      } else {
        // set diffrence and
        print("cmp : ${picked.compareTo(_selectedToDate!)}");
        if (picked.compareTo(_selectedToDate!) > 0) {
          // Date can not select show an error message
          print('Date is not valid');
          setState(() {
            _selectedFromDate = null;
            _isFormDateSelected = false;
            _dayDifference = 0;
            _totalCharge = 0;
          });
          return;
        } else {
          dayDiff = _selectedToDate!.difference(picked).inDays + 1;
          print('diffrence is : $dayDiff');
        }
      }
      try {
        totalCharge = dayDiff *
            price_according_to_roomtype[
                    type_of_booking_list[selected_booking_type]]![
                type_of_room_list[selected_room_type]]! *
            int.parse(_guestController.text);
        print('totl charge : $totalCharge');
      } catch (e) {
        totalCharge = 0;
        print('totl ee charge : $e');
      }
      setState(() {
        _selectedFromDate = picked;
        _isFormDateSelected = true;
        _dayDifference = dayDiff;
        _totalCharge = totalCharge;
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
    int dayDiff = 0;
    int totalCharge = 0;

    if (picked != null && picked != _selectedToDate) {
      if (_selectedFromDate == null) {
        // do nothing
      } else {
        // set diffrence and
        print("cmp : ${picked.compareTo(_selectedFromDate!)}");
        if (picked.compareTo(_selectedFromDate!) < 0) {
          // Date can not select show an error message
          print('Date is not valid');
          setState(() {
            _selectedToDate = null;
            _isToDateSelected = false;
            _dayDifference = dayDiff;
            _totalCharge = totalCharge;
          });
          return;
        } else {
          dayDiff = picked.difference(_selectedFromDate!).inDays + 1;
          print('diffrence is : $dayDiff');
        }
      }
      try {
        totalCharge = dayDiff *
            price_according_to_roomtype[
                    type_of_booking_list[selected_booking_type]]![
                type_of_room_list[selected_room_type]]! *
            int.parse(_guestController.text);
        print('totl charge : $totalCharge');
      } catch (e) {
        totalCharge = 0;
        print('totl ee charge : $e');
      }
      setState(() {
        _selectedToDate = picked;
        _isToDateSelected = true;
        _dayDifference = dayDiff;
        _totalCharge = totalCharge;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: Container(
        child: Stack(
          children: [
            // Background
            Container(
              // height: MediaQuery.of(context).size.height*0.5,
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.2,
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
                              headingText("Type of booking"),
                              Row(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: selected_booking_type,
                                          onChanged:
                                              handleBookingTypeValueChange,
                                        ),
                                        Text('For Personal Use.'),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Radio(
                                          value: 2,
                                          groupValue: selected_booking_type,
                                          onChanged:
                                              handleBookingTypeValueChange,
                                        ),
                                        Text('For Official Use.'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              headingText("Type of Room"),
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
                                height: 15,
                              ),
                              headingText("Days of Stay"),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _isFormDateSelected
                                          ? Colors.grey
                                          : Colors.red,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: ListTile(
                                  title: Text(
                                    _selectedFromDate != null
                                        ? 'From: ${_selectedFromDate!.toLocal()}'
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
                                        ? 'To: ${_selectedToDate!.toLocal()}'
                                        : 'To ?',
                                  ),
                                  trailing: Icon(Icons.calendar_today),
                                  onTap: () {
                                    _selectToDate(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total days of stay : "),
                                      Text("$_dayDifference days"),
                                    ],
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: _guestController,
                                onChanged: (value) {
                                  int totalCharge = 0;
                                  try {
                                    totalCharge = _dayDifference *
                                        price_according_to_roomtype[
                                                type_of_booking_list[
                                                    selected_booking_type]]![
                                            type_of_room_list[
                                                selected_room_type]]! *
                                        int.parse(_guestController.text);
                                    print('totl charge : $totalCharge');
                                  } catch (e) {
                                    totalCharge = 0;
                                    print('totl ee charge : $e');
                                  }
                                  setState(() {
                                    _totalCharge = totalCharge;
                                  });
                                },
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
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      headingText("Total Charge : "),
                                      headingText("$_totalCharge TK"),
                                    ],
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryDeep),
                                onPressed: () {
                                  print('Login clicked.');
                                  if (selected_booking_type == 0) {
                                    showMessage(
                                        context,
                                        "Booking type is not selected yet.",
                                        dangerColor);
                                  } else if (selected_room_type == 0) {
                                    showMessage(
                                        context,
                                        "Room type is not selected yet.",
                                        dangerColor);
                                  } else if (!_isFormDateSelected) {
                                    showMessage(
                                        context,
                                        "From date is not selected yet.",
                                        dangerColor);
                                  } else if (!_isToDateSelected) {
                                    showMessage(
                                        context,
                                        "To date is not selected yet.",
                                        dangerColor);
                                  }

                                  if (_form_key.currentState!.validate()) {
                                    print(
                                        'type of booking : $selected_booking_type');
                                    print('type of room : $selected_room_type');
                                    print('From date : $_selectedFromDate');
                                    print('To date : $_selectedToDate');
                                    print('day count : $_dayDifference');
                                    print(
                                        'number of guest : $_guestController');
                                    bookingRequest(
                                        context,
                                        Allocation(
                                            user_id: myUser!.id,
                                            guest_house_id: 1,
                                            boarding_date:
                                                _selectedFromDate.toString(),
                                            departure_date:
                                                _selectedToDate.toString(),
                                            room_type: type_of_room_list[
                                                selected_room_type],
                                            booking_type: type_of_booking_list[
                                                selected_booking_type],
                                            guest_count: int.parse(
                                                _guestController.text)));
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

  headingText(String text) {
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
    BookingNetwork network =
        BookingNetwork(url: "/api/v1/public/allocation/new");
    Future data = network.sendBookingRequest(booking);
    data.then((value) {
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
