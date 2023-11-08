import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/models/userModel.dart';

User? myUser;

String? token;
final String tokenText = '${appTitle}tokenSharedPreferencesText';

final String appTitle = 'PUST Guest House';

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
  "01 CSE",
  "02 EEE",
  "03 MATH",
  "04 BBA",
  "05 EECE",
  "06 ICE",
  "07 Physics",
  "08 Economics",
  "09 GE",
  "10 Bangla",
  "11 Civil",
  "12 Architecture",
  "13 Pharmacy",
  "14 Chemistry",
  "15 SW",
  "16 STAT",
  "17 URP",
  "18 Eng",
  "19 Pub. Add.",
  "20 HBS",
  "21 Thm",
  "Others"
];

Map<String, List<Allocation>>? catagory_wise_allocations;