import 'package:flutter/material.dart';
import 'package:guest_house_pust/util/variables.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appTitle),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.015,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: Text(
                  'About',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                'Welcome to PUST Guesthouse Application, the ultimate solution for seamless guesthouse management. \nStreamline your guesthouse operations with our intuitive mobile application designed to simplify request handling, enhance communication, and provide a delightful experience for both guests and guesthouse administrator. \n\n\nThis application is developed by \nSharif Hasan (CSE 11 bath) \nand \nBayazid Hossain (CSE 11 batch) \nunder the supervision of \nDr. Abdur Rahim \nDepartment of Computer Science and Engineering \nPabna University of Science and Technology.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
