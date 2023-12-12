import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/components.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class BalanceCheckPage extends StatefulWidget {
  const BalanceCheckPage({super.key});

  @override
  State<BalanceCheckPage> createState() => _BalanceCheckPageState();
}

class _BalanceCheckPageState extends State<BalanceCheckPage> {
  String? balance;
  double msgRate = 0.2;
  final _perMessageRate = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _perMessageRate.text = '0.2';
    _get_balance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appTitle),
      body: (balance != null)
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  Center(
                      child: Text(
                    'Current Balance',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    '${balance} Taka',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Per Msg Rate :',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: TextFormField(
                              onChanged: (value) {
                                if (value == "") {
                                  msgRate = 1;
                                  return;
                                }
                                try {
                                  double v = double.parse(value);
                                  if (v == 0) {
                                    return;
                                  }
                                  setState(() {
                                    msgRate = double.parse(value);
                                  });
                                } catch (e) {
                                  showToast(context, e.toString(), dangerColor);
                                }
                                // if (value != "") {
                                //   setState(() {
                                //     is_day_count = true;
                                //   });
                                // } else {
                                //   setState(() {
                                //     is_day_count = false;
                                //   });
                                // }
                              },
                              controller: _perMessageRate,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Message Rate',
                                  hintText: 'Write in Double.'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text(
                    ' = ${(double.parse(balance!) / msgRate).floor()} SMS',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _loanchMoreDetails();
                      },
                      child: Text('More Details'))
                ],
              ),
            )
          : Container(child: Center(child: CircularProgressIndicator())),
    );
  }

  _get_balance() async {
    var urlg = Uri.https(hostUrl, '/api/v1/admin/sms-balance');

    final response =
        await get(urlg, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      Map<String, dynamic> res = json.decode(response.body);
      print(response.body);
      setState(() {
        balance = '${res['balance']}';
      });
    } else {
      print(response.statusCode);
    }
  }

  _loanchMoreDetails() async {
    Uri url = Uri.parse('https://bulksmsbd.net/login');
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}
