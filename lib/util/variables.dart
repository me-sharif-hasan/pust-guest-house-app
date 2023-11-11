import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/models/userModel.dart';

User? myUser;

String? token;
final String tokenText = '${appTitle}tokenSharedPreferencesText';

final Widget appTitle = SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(children: [
    Container(
        height: 40, width: 40, child: Image.asset('images/pust_logo.png')),
    Text('PUST Guest House'),
  ]),
);

final List<String> userTapPotions = [
  "All",
  "Pending",
  "Approved",
  "Current",
  "Rejected",
  "Expired"
];

final String hostUrl = "10.0.2.2:8000";

final List<String> departmentList = [
  "Chose a department",
  "01 Computer Science and Engineering(CSE)",
  "02 Electrical and Electronic Engineering(EEE)",
  "03 Mathematics(MATH)",
  "04 Business Administration(BBA)",
  "05 Electrical, Electronic and Communication Engineering(EECE)",
  "06 Information and Communication Engineering(ICE)",
  "07 Physics",
  "08 Economics",
  "09 Geography and Environment(GE)",
  "10 Bangla",
  "11 Civil Engineering",
  "12 Architecture",
  "13 Pharmacy",
  "14 Chemistry",
  "15 Social Work(SW)",
  "16 Statistics(STAT)",
  "17 Urban and Regional Planning(URP)",
  "18 English",
  "19 Public Administration",
  "20 History(HBS)",
  "21 Tourism and Hospitality Management(THM)",
  "Others"
];

Map<String, List<Allocation>>? catagory_wise_allocations;

final List<String> type_of_guest_house_list = [
  "",
  "Dhaka Guest House",
  "Pabna Guest House"
];

final List<String> type_of_booking_list = ["", "Personal Use", "Official Use"];
final List<String> type_of_room_list = ["", "AC", "Non AC"];
final Map<String, Map<String, int>> price_according_to_roomtype = {
  "Personal Use": {
    "": 0,
    "AC": 300,
    "Non AC": 200,
  },
  "Official Use": {
    "": 0,
    "AC": 200,
    "Non AC": 100,
  },
  "": {
    "": 0,
    "AC": 0,
    "Non AC": 0,
  }
};


