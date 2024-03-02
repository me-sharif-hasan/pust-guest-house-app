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
    Text(
      'PUST Guest House',
      style: TextStyle(color: Colors.white),
    ),
  ]),
);

final List<String> userTapPotions = [
  "All",
  "Pending",
  "Approved",
  "Cancelled",
  "Rejected",
  "Expired"
];

// final String hostUrl = "10.0.2.2:8000";
// final String hostUrl = "testproject.iishanto.com";
final String hostUrl = "guesthouse.pust.ac.bd";
// final String hostUrl = '127.0.0.1:8000';
final String hostImageUrl = "https://$hostUrl";

final List<String> departmentList = [
  "Chose a Department",
  "01 - Computer Science and Engineering(CSE)",
  "02 - Electrical and Electronic Engineering(EEE)",
  "03 - Mathematics(MATH)",
  "04 - Business Administration(DBA)",
  "05 - Electrical, Electronic and Communication Engineering(EECE)",
  "06 - Information and Communication Engineering(ICE)",
  "07 - Physics",
  "08 - Economics",
  "09 - Geography and Environment(GE)",
  "10 - Bangla",
  "11 - Civil Engineering",
  "12 - Architecture",
  "13 - Pharmacy",
  "14 - Chemistry",
  "15 - Social Work(SW)",
  "16 - Statistics(STAT)",
  "17 - Urban and Regional Planning(URP)",
  "18 - English",
  "19 - Public Administration",
  "20 - History(HBS)",
  "21 - Tourism and Hospitality Management(THM)",
  "Others"
];

Map<String, List<Allocation>>? catagory_wise_allocations;

Map<int, String> type_of_guest_house_list = {};
Map<int, String> guest_house_address = {};
Map<int, double> guest_house_lat = {};
Map<int, double> guest_house_log = {};

final List<String> type_of_booking_list = ["", "Personal Use", "Official Use"];
final List<String> type_of_room_list = ["", "AC", "Non AC"];
final List<String> type_of_stays = ["","Night Stay","Day Stay Only"];
final List<String> type_of_guest_gender = ["","male","female","family"];

final List<String> conditions = [
  '১। গেস্ট হাউজে প্রবেশ/অবস্থান করে এন্ট্রি বুক ও বুকিং ফরম পূরন করুন।',
  '২। গেস্ট হাউজে অবস্থাঙ্কালীন আপনি কোন বেআইনি/রাষ্ট ও বিশ্ববিদ্যালয়ের স্বার্থবিরোধী কোন কাজে লিপ্ত হতে পারবেন না।',
  '৩। ব্যাক্তিগত কাজে সর্বোচ্চ ৭ দিনের বেশি আপনি গেস্ট হাউজে অবস্থান করতে পারবেন না।',
  '৪। আপনার পরিবারের সদস্য নয় বা বিশ্ববিদ্যালয়ের সাথে সম্পৃক্ত নয় এমন কেউ গেস্ট হাউজে অবস্থান করতে পারবেন না।',
  '৫। দুপুর ১২টা ১ মিনিট থেকে পরের দিন ১১টা ৫৯ মিনিট পর্যন্ত ১ দিন গণনা করা হবে। তবে রাত্রে অবস্থান না করলে কোন চার্জ কাটা হবে না কিন্তু গেস্ট হাউজে দিনের বেলা সাময়িক অবস্থান খাতায় এন্ট্রি ও স্বাক্ষর করতে হবে।',
  // '৬। গেস্ট এর সংখ্যা, রুমের ধরন বা অবস্থানকালীন তারিখ পরিবর্তন হলে গেস্ট হাউজ প্রশাসককে অবহিত করুন।',
  '৬। কর্তব্যকালীন ছুটি হলে বুকিং ফরমের পেছনে প্রমান্য হিসেবে ফটোকপি সংযুক্ত করুন।',
  '৭। আপনার সেবায় নিয়োজিত কর্মীদের সাথে সদাচরন করুন।',
  // '৯। খাবার অর্ডার দিয়ে না খেলেও খাবারের বিল পরিশোধ করতে হবে।',
  '৮। গেস্ট হাউজে কোন ধরনের মাদকদব্য বহন ও সেবন সম্পূর্ণ নিষিদ্ধ।',
  // '১১। পাবিপ্রাবির একাডেমিক কাজের সাথে সম্পৃক্ত নয় এমন বিদেশি ব্যক্তিগত অতিথি গেস্ট হাউজে অবস্থানের ক্ষেত্রে মাননীয় উপচার্য মহদয়ের বিশেষ অনুমতি প্রয়োজন।',
  // '১২। অনুমতি নিয়ে গেস্ট হাউজে অবস্থান করে বুকিং ফরম ও এন্ট্রি বুক পূরণ না করলে বুকিং ফরম ও এন্ট্রি বুক পূরণ করার জন্য আপনাকে "লেটার অফ রিমাইন্ডার" দেওয়া হবে।',
  '৯। বিনা অনুমতিতে গেস্ট হাউজে রাত্রি যাপন (রাত ১২টা থেকে ভোর ৬টা) করলে আপনাকে বিশ্ববিদ্যালয় রাজিস্ট্রারের মাধ্যমে "কারণ দর্শানোর নোটিশ" দেওয়া হবে।',
  // '১৪। গেস্ট হাউজ ব্যবহারে পরিচ্ছন্নতা বজায় রাখুন।',
  '১০। যে কোনো অসুবিধা বা সমস্যার সমাধানের জন্য প্রশাসকের সাথে যোগাযোগ করুন।',
  // '১৬। আপনার কোন অভিযোগ থাকলে অভিযোগ বইয়ে বিস্তারিত লিখুন।'
];

String rejection_reason_text = 'Room is not available on that time schedule.';

int total_page = 2;
Map<String,int> total_page_with_status = {
  'all': 2,
  'pending': 2,
  'approved': 2,
  'cancelled': 2,
  'rejected': 2,
  'expired' : 2,
};
// final Map<String, Map<String, int>> price_according_to_roomtype = {
//   "Personal Use": {
//     "": 0,
//     "AC": 300,
//     "Non AC": 200,
//   },
//   "Official Use": {
//     "": 0,
//     "AC": 200,
//     "Non AC": 100,
//   },
//   "": {
//     "": 0,
//     "AC": 0,
//     "Non AC": 0,
//   }
// };


