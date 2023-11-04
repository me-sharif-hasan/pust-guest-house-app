import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/connection.dart';
import 'package:guest_house_pust/ui/auth/login.dart';
import 'package:guest_house_pust/util/colors.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  Future? data;

  final _form_key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _department = "Chose your department";
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isDepartmentChose = false;

  List<String> departmentList = [
    "Chose a department",
    "01 CSE",
    "02 EEE",
    "03 MATH",
    "04 BBA",
    "05 EECE",
    "06 ICE",
    "07 Physics",
    "08 Economics",
    "09 GE",
    "10 Bangla",
    "11 Civil",
    "12 Architecture",
    "13 Pharmacy",
    "14 Chemistry",
    "15 SW",
    "16 STAT",
    "17 URP",
    "18 Eng",
    "19 Pub. Add.",
    "20 HBS",
    "21 Thm"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _department = departmentList.first;
    _isDepartmentChose = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('PUST Guest House'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                  color: primary, borderRadius: BorderRadius.circular(4)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              )),
            ),
          )
        ],
      ),
      body: Container(
          // decoration: BoxDecoration(color: Colors.white),
          child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            // Background
            child: Opacity(
              opacity: 0.3,
              child: Image.asset('images/home_illustrator.png'),
            ),
            // Lgin UI
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                'Sign up',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Expanded(
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _form_key,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'User Name',
                                  hintText: 'Enter your full name'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'User name required.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'User Email',
                                  hintText: 'Enter your Email'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'User Email required.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'User phone number',
                                  hintText: 'Enter your phone number'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'User phone number required.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  hintText: 'Enter Password'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password required.';
                                } else if (value.length < 6) {
                                  return 'Password at least 6 character';
                                }

                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _confirmPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Confirm Password',
                                  hintText: 'Enter confirm Password'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Confirm password required.';
                                } else if (value != _passwordController.text) {
                                  print("Value $value");
                                  print("cc ${_passwordController.text}");
                                  return 'Password and Confirm Password should be same.';
                                }

                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _isDepartmentChose
                                        ? Colors.grey
                                        : Colors.red,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(2)),
                              child: DropdownButton(
                                value: _department,
                                isExpanded: true,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                items: departmentList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    _department = value!;
                                    if (value == departmentList.first) {
                                      _isDepartmentChose = false;
                                    } else {
                                      _isDepartmentChose = true;
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print('Forget Password clicked.');
                                  },
                                  child: Text(
                                    'Forget Password?',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryDeep),
                              onPressed: () {
                                print('Login clicked.');
                                print('Email : ${_emailController.text}');
                                print('Password : ${_passwordController.text}');
                                print('isdept : ${_isDepartmentChose}');
                                

                                if (_form_key.currentState!.validate()) {

                                  if (_isDepartmentChose) {
                                    registerUser(User(  
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      department: _department,
                                      phone: _phoneController.text,
                                      title: "title is now set"
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Department is not selected yeat.'),
                                      backgroundColor: danger,
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
                                child: Text('Send Request'),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
  
  void registerUser(User user) {
    Network network = Network(url: "/api/v1/registration");
    network.registerUser(user);
  }
}
