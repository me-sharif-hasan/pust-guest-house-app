import 'package:flutter/material.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';

class AllocationRequest extends StatefulWidget {
  const AllocationRequest({super.key});

  @override
  State<AllocationRequest> createState() => _AllocationRequestState();
}

class _AllocationRequestState extends State<AllocationRequest> {
  final _form_key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isFormDateSelected = false;
  bool _isToDateSelected = false;

  DateTime? _selectedDate;

  int selectedRadio = 0; // Initialize the selected radio to the first option.

  void handleRadioValueChange(int? value) {
    setState(() {
      selectedRadio = value!;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
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
                                          groupValue: selectedRadio,
                                          onChanged: handleRadioValueChange,
                                        ),
                                        Text('For Personal Use.'),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Radio(
                                          value: 2,
                                          groupValue: selectedRadio,
                                          onChanged: handleRadioValueChange,
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
                                          groupValue: selectedRadio,
                                          onChanged: handleRadioValueChange,
                                        ),
                                        Text('AC.'),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Radio(
                                          value: 2,
                                          groupValue: selectedRadio,
                                          onChanged: handleRadioValueChange,
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
                                    _selectedDate != null
                                        ? 'From: ${_selectedDate!.toLocal()}'
                                        : 'From ?',
                                  ),
                                  trailing: Icon(Icons.calendar_today),
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                ),
                              ),
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
                                    _selectedDate != null
                                        ? 'To: ${_selectedDate!.toLocal()}'
                                        : 'To ?',
                                  ),
                                  trailing: Icon(Icons.calendar_today),
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: _emailController,
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
                                      headingText("1000 TK"),
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
                                  print('Email : ${_emailController.text}');
                                  print(
                                      'Password : ${_passwordController.text}');

                                  if (_form_key.currentState!.validate()) {
                                    // userLogin(context, _emailController.text,
                                    //     _passwordController.text);

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Login successful'),
                                      backgroundColor: Colors.green,
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
}
