import 'package:flutter/material.dart';
import 'package:guest_house_pust/ui/auth/splashScreen.dart';
import 'package:guest_house_pust/util/colors.dart';

void main() {
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
