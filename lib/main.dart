import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guest_house_pust/firebase_options.dart';
import 'package:guest_house_pust/ui/auth/splashScreen.dart';
import 'package:guest_house_pust/util/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'PUST GUEST HOUSE',
    theme: ThemeData(
      primaryColor: primary,
      appBarTheme: AppBarTheme(color: primaryDeep),

      // buttonTheme: ButtonThemeData(buttonColor: primaryDeep)
    ),
    home: SplashScreen(),
  ));
}
