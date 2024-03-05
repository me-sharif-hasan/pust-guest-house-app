import 'package:flutter/material.dart';
import 'package:guest_house_pust/network/client/clientApiHandel.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/components.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();
  final _varificationCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _is_code_sended = false;
  bool _is_mail_varified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appTitle),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              'Reset Password',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: (_is_code_sended) ? acceptColor : primaryExtraDeep,
                      borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '1 Email',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: (_is_code_sended)
                          ? (_is_mail_varified)
                              ? acceptColor
                              : primaryExtraDeep
                          : primaryLight,
                      borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '2 Varification Code',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: (_is_code_sended && _is_mail_varified)
                          ? primaryExtraDeep
                          : primaryLight,
                      borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '3 New Password',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            (!_is_code_sended)
                ? Container(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Official Email',
                              hintText: 'Enter your Official Email'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (_emailController.text == "") {
                                showToast(context, 'Email field is empty.',
                                    dangerColor);
                                return;
                              }
                              ProgressDialog pd =
                                  ProgressDialog(context: context);
                              pd.show(
                                  max: 100, msg: 'Wait for response');

                              if (await ClientNetwork.resetPasswordMethod(
                                  context,
                                  '/api/v1/forget-password/code',
                                  {'email': _emailController.text})) {
                                setState(() {
                                  _is_code_sended = true;
                                });
                              }
                              pd.close();

                              // setState(() {
                              //   _is_code_sended = true;
                              // });
                            },
                            child: Text('Send Varification Code'))
                      ],
                    ),
                  )
                : (!_is_mail_varified)
                    ? Container(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _varificationCodeController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Varification Code',
                                  hintText: 'Write varification Code'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_varificationCodeController.text == "") {
                                    showToast(
                                        context,
                                        'Varification code field is empty.',
                                        dangerColor);
                                    return;
                                  }
                                  ProgressDialog pd =
                                      ProgressDialog(context: context);
                                  pd.show(
                                      max: 100,
                                      msg: 'Wait for response');

                                  if (await ClientNetwork.resetPasswordMethod(
                                      context,
                                      '/api/v1/forget-password/verify', {
                                    'email': _emailController.text,
                                    'code': _varificationCodeController.text
                                  })) {
                                    setState(() {
                                      _is_mail_varified = true;
                                    });
                                  }
                                  pd.close();
                                },
                                child: Text('Varify'))
                          ],
                        ),
                      )
                    : Container(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'New Password',
                                  hintText:
                                      'Write password at least 6 character'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Confirm new Password',
                                  hintText: 'Must be match with new password'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_passwordController.text == "" ||
                                      _confirmPasswordController.text == "") {
                                    showToast(context, 'Field is empty.',
                                        dangerColor);
                                    return;
                                  } else if (_passwordController.text !=
                                      _confirmPasswordController.text) {
                                    showToast(
                                        context,
                                        'Password and confirm password must be same. Please Check and try again.',
                                        dangerColor);
                                    return;
                                  }
                                  ProgressDialog pd =
                                      ProgressDialog(context: context);
                                  pd.show(
                                      max: 100,
                                      msg: 'Wait for response');

                                  if (await ClientNetwork.resetPasswordMethod(
                                      context,
                                      '/api/v1/forget-password/reset', {
                                    'email': _emailController.text,
                                    'code': _varificationCodeController.text,
                                    'password': _passwordController.text
                                  })) {
                                    pd.close();
                                    Navigator.pop(context);
                                    // setState(() {
                                    //   _is_mail_varified = true;
                                    // });
                                  }
                                  pd.close();
                                },
                                child: Text('Finish'))
                          ],
                        ),
                      ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            )
          ]),
        ),
      ),
    );
  }
}
