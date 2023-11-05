import 'package:guest_house_pust/models/userModel.dart';

User? myUser;

String? token;
final String tokenText = '${appTitle}tokenSharedPreferencesText';

final String appTitle = 'PUST Guest House';

final List<String> userTapPotions = ["All", "Pending", "Approved", "Current", "Rejected"];

final String hostUrl = "10.0.2.2:8000";

