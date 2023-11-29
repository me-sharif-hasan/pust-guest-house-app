import 'package:flutter/material.dart';
import 'package:guest_house_pust/network/connection.dart';
import 'package:guest_house_pust/ui/auth/login.dart';
import 'package:guest_house_pust/ui/auth/splashScreen.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class Varification extends StatefulWidget {
  const Varification({super.key});

  @override
  State<Varification> createState() => _VarificationState();
}

class _VarificationState extends State<Varification> {
  final _form_key = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: appTitle,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
            decoration: BoxDecoration(),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(primary)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Sign in",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
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
                  'Varify Your Email',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
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
                              controller: _codeController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Varification Code',
                                  hintText: 'Write your varification code.'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Varification code is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print('Resend varification code.');
                                    resendVarificationCode(context);
                                  },
                                  child: Text(
                                    'Resend varification code.',
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
                                print('varification clicked.');

                                if (_form_key.currentState!.validate()) {
                                  varifyEmail(context, _codeController.text);
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(SnackBar(
                                  //   content: Text('Code send success'),
                                  //   backgroundColor: acceptColor,
                                  // ));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Varify',
                                  style: TextStyle(color: Colors.white),
                                ),
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

  void varifyEmail(BuildContext context, String code) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for server response');

    Network network = Network(url: "/api/v1/verify");
    Future data = network.varifyUser(code);
    data.then((value) async {
      print("data is : $value");
      pd.close();
      if (value['status'] == 'error') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['message']),
          backgroundColor: dangerColor,
        ));
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
      }
    });
  }

  void resendVarificationCode(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Wait for server response');

    Network network = Network(url: "/api/v1/resend");
    Map<String, dynamic> data = await network.resendVarificationCode();
    pd.close();
    print("data is : $data");

    if (data['status'] == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message']),
        backgroundColor: dangerColor,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Varification Code resended. Use updated code.'),
        backgroundColor: acceptColor,
      ));
      // Navigator.pop(context);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const SplashScreen()),
      // );
    }
  }
}
