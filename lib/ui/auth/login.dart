import 'package:flutter/material.dart';
import 'package:guest_house_pust/ui/auth/registration.dart';
import 'package:guest_house_pust/util/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form_key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                MaterialPageRoute(builder: (context) => const Registration()),
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
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              Text(
                'Login',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _form_key,
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
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                hintText: 'Enter Password'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password required.';
                              } else if (value.length < 4) {
                                return 'Password at least 4 character';
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
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryDeep),
                            onPressed: () {
                              print('Login clicked.');
                              print('Email : ${_emailController.text}');
                              print('Password : ${_passwordController.text}');

                              if (_form_key.currentState!.validate()) {
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
                              child: Text('Login'),
                            ),
                          ),
                        ],
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
}
