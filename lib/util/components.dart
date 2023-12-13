import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/admin/userApi.dart';
import 'package:guest_house_pust/ui/auth/login.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

void logoutConfirmationDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Logout.'),
        content: Text('Are you sure to logout.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
          ElevatedButton(
              onPressed: () async {
                ProgressDialog pd = ProgressDialog(context: context);
                pd.show(max: 100, msg: 'Wait for server response');

                final props = await SharedPreferences.getInstance();
                props.remove(tokenText);
                pd.close();
                // Navigator.pop(context);
                Navigator.popUntil(context, (route) => false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: Text('Confirm'))
        ],
      );
    },
  );
}

Widget getAllocationItemAdmin(Allocation allocation, bool is_admin) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
    decoration: BoxDecoration(
      color: _getColorByStatus(
          '${allocation.status}',
          is_admin
              ? allocation.is_admin_seen ?? 0
              : allocation.is_user_seen ?? 0),
      border: Border.all(width: 1.0, color: primaryDeep),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: ListTile(
      leading: CircleAvatar(
        backgroundImage: _getBackgroundImage(allocation.user_profile),
      ),
      title: Text('${allocation.user_name}'),
      // title: Text(
      //     "${type_of_guest_house_list[allocation.guest_house_id ?? 0].title}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.date_range),
              SizedBox(
                width: 4.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${allocation.boarding_date!.substring(0, 16)} to"),
                  Text('${allocation.departure_date!.substring(0, 16)}'),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${type_of_guest_house_list[allocation.guest_house_id ?? 0]}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('ID:  ${allocation.id}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          // Text('assigned rooms ${allocation.assigned_room!.rooms!.length}')
          // Text('Dr Abdur Rahim'),
        ],
      ),
      trailing: Text('${allocation.status}'),
    ),
  );
}

_getBackgroundImage(String? profile_picture) {
  if (profile_picture == null) {
    return AssetImage('images/man.png');
  } else {
    try {
      return NetworkImage('$hostImageUrl${profile_picture}');
    } catch (e) {
      return AssetImage('images/man.png');
    }
  }
}

Widget getAllocationItem(Allocation allocation, bool is_admin) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
    decoration: BoxDecoration(
      color: _getColorByStatus(
          '${allocation.status}',
          is_admin
              ? allocation.is_admin_seen ?? 0
              : allocation.is_user_seen ?? 0),
      border: Border.all(width: 1.0, color: primaryDeep),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: ListTile(
      leading: CircleAvatar(
        child: Text('${allocation.id}'),
      ),
      title: Text(type_of_guest_house_list[allocation.guest_house_id]!),
      // title: Text(
      //     "${type_of_guest_house_list[allocation.guest_house_id ?? 0].title}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.date_range),
              SizedBox(
                width: 4.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${allocation.boarding_date!.substring(0, 16)} to"),
                  Text('${allocation.departure_date!.substring(0, 16)}'),
                ],
              ),
            ],
          ),
          // Text('assigned rooms ${allocation.assigned_room!.rooms!.length}')
          // Text('Dr Abdur Rahim'),
        ],
      ),
      trailing: Text('${allocation.status}'),
    ),
  );
}

Color _getColorByStatus(String status, int seen) {
  if (seen == 1) {
    if (status == 'pending') {
      return Colors.yellow.shade50;
    } else if (status == 'approved') {
      return Colors.blue.shade50;
    } else {
      return Colors.red.shade100;
    }
  } else {
    if (status == 'pending') {
      return Colors.yellow.shade200;
    } else if (status == 'approved') {
      return Colors.blue.shade200;
    } else {
      return Colors.red.shade200;
    }
  }
}

void showToast(BuildContext context, String text, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: color,
  ));
}

Future<User?> getUserDetails(int? user_id) {
  AdminUserApi api = AdminUserApi(url: '/api/v1/admin/users/details');
  return api.getUserById(user_id!);
}
