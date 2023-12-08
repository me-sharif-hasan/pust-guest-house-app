import 'package:flutter/material.dart';
import 'package:guest_house_pust/util/variables.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appTitle),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text('About Pust Guest House App'),
          ],
        ),
      ),
    );
  }
}
