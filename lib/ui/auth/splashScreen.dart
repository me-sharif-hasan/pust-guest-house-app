import 'package:flutter/material.dart';
import 'package:guest_house_pust/ui/auth/login.dart';
import 'package:guest_house_pust/util/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: primaryLight),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: primaryExtraDeep,
            ),
            Text("Splash Screen"),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryDeep,
                borderRadius: BorderRadius.circular(10)
                ),
              child: InkWell(
                
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: Icon(Icons.login),
              ),
            ),
          ],
        )),
      ),
    );
  }

  //  gotoLogin(BuildContext context) async {
  //   await Navigator.of(context).push( MaterialPageRoute(builder: ((context) => Login())));
  // }
}
