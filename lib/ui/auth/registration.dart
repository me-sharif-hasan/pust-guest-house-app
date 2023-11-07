import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/connection.dart';
import 'package:guest_house_pust/ui/auth/login.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  Future? data;

  final _form_key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _emailController = TextEditingController();
  String _department = "Chose your department";
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _officeController = TextEditingController();

  bool _isDepartmentChose = false;
  bool _isOther = false;

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _department = departmentList.first;
    _isDepartmentChose = false;
    _isOther = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(appTitle),
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
                              controller: _titleController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'User title',
                                  hintText: 'Write your title'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'User title required.';
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
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: _togglePasswordVisibility,
                                  ),
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
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: _togglePasswordVisibility,
                                  ),
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
                                        : dangerColor,
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
                                      _isOther = false;
                                    } else if (value == departmentList.last) {
                                      _isDepartmentChose = true;
                                      _isOther = true;
                                    } else {
                                      _isDepartmentChose = true;
                                      _isOther = false;
                                    }
                                  });
                                },
                              ),
                            ),
                            _isOther
                                ? TextFormField(
                                    controller: _officeController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Office',
                                        hintText: 'Enter your office Position'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Office Position Requrired.';
                                      }
                                      return null;
                                    },
                                  )
                                : Container(),
                            SizedBox(
                              height: 10,
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
                                    if (_isOther) {
                                      _department = _officeController.text;
                                    }
                                    registerUser(
                                        context,
                                        User(
                                            name: _nameController.text,
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            department: _department,
                                            phone: _phoneController.text,
                                            title: _titleController.text));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Registration data send success.'),
                                      backgroundColor: acceptColor,
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Department is not selected yeat.'),
                                      backgroundColor: dangerColor,
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
                              height: MediaQuery.of(context).size.height * 0.3,
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

  void registerUser(BuildContext context, User user) {
    Network network = Network(url: "/api/v1/registration");
    Future data = network.registerUser(user);
    data.then((value) {
      print("data is : $value");
      if (value['status'] == 'error') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['message']),
          backgroundColor: dangerColor,
        ));
      } else {
        myUser = User.fromJson(value['data']['user']);
        print(myUser!.name);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
        // Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Login()),
        // );
      }
    });
  }
}
