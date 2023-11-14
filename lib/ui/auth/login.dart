import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/connection.dart';
import 'package:guest_house_pust/ui/admin/adminHome.dart';
import 'package:guest_house_pust/ui/auth/emailVerification.dart';
import 'package:guest_house_pust/ui/auth/registration.dart';
import 'package:guest_house_pust/ui/auth/splashScreen.dart';
import 'package:guest_house_pust/ui/client/userHome.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form_key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: appTitle,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
            decoration: BoxDecoration(
                color: primary, borderRadius: BorderRadius.circular(4)),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(primary)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Registration()),
                );
              },
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Sign up",
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
          // Background
          Container(
            // height: MediaQuery.of(context).size.height*0.5,
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.3,
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
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 25,
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
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryDeep),
                              onPressed: () {
                                print('Login clicked.');
                                print('Email : ${_emailController.text}');
                                print('Password : ${_passwordController.text}');

                                if (_form_key.currentState!.validate()) {
                                  userLogin(context, _emailController.text,
                                      _passwordController.text);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Login data send success'),
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
                                child: Text('Login'),
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
      )),
    );
  }

  void userLogin(BuildContext context, String email, String password) async {
    Network network = Network(url: "/api/v1/login");
    Future data = network.loginUser(email, password);
    data.then((value) async {
      print("data is : $value");
      if (value['status'] == 'not-verified') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['message']),
          backgroundColor: dangerColor,
        ));
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Varification()),
        );
      } else if (value['status'] == 'error') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['message']),
          backgroundColor: dangerColor,
        ));
      } else {
        token = value['data']['token'];

        // store the token to the shared preferences
        final props = await SharedPreferences.getInstance();
        props.setString(tokenText, token!);
        // Parse to User Page
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
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
