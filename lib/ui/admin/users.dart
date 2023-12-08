import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/userModel.dart';
import 'package:guest_house_pust/network/admin/userApi.dart';
import 'package:guest_house_pust/ui/admin/user/userDetails.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';
import 'package:url_launcher/url_launcher.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Future<UserList?>? user_list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: user_list,
          builder: (context, AsyncSnapshot<UserList?> snapshot) {
            if (snapshot.hasData) {
              // return Container();
              return createUserPage(snapshot.data!.users, context);
            } else {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }
          },
        ),
      )),
    );
  }

  loadAllUser() async {
    AdminUserApi adminUserApi = AdminUserApi(url: '/api/v1/admin/users');
    user_list = adminUserApi.loadUsers();
    user_list!.then((value) {
      print("number of user : ${value!.users!.length}");
    });
  }

  Widget createUserPage(List<User>? users, BuildContext context) {
    return Column(
        children: users!.map((e) {
      return userItemBuilder(e);
    }).toList());
  }

  Widget userItemBuilder(User e) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: primary),
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(

        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserDetails(user: e,)));
        },
        leading: CircleAvatar(
          backgroundImage: getBackgroundImage(e.profile_picture),
        ),
        title: Text(
          '${e.name}',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${e.phone}'),
          GestureDetector(
            onTap: () {
              print('Calling');
              _makePhoneCall('+88${e.phone!}');
            },
            child: Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    color: primary,
                    border: Border.all(width: 2.0, color: primary),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                )),
          )
        ]),
        trailing: Text('${e.id}'),
        tileColor: primaryExtraLight,
      ),
    );
  }

  getBackgroundImage(String? profile_picture) {
    if (profile_picture == null) {
      return AssetImage('images/man.png');
    } else {
      return NetworkImage('$hostImageUrl${profile_picture}');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
