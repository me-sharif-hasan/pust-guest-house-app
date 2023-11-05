import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/network/clientApiHandel.dart';
import 'package:guest_house_pust/ui/client/userProfile.dart';
import 'package:guest_house_pust/util/colors.dart';
import 'package:guest_house_pust/util/variables.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {

  Future<AllocationList?>? allocationData;

  @override
  void initState() {
    super.initState();
    ClientNetwork clientNetwork = ClientNetwork(url: '/api/v1/public/allocation');
    allocationData = clientNetwork.loadAllocations('/all');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: userTapPotions.length,
      child: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
            actions: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    print('User clicked');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserProfile()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
              )
            ],
            bottom: TabBar(
              isScrollable: true,
              labelStyle: TextStyle(color: primary),
              tabs: userTapPotions.map((e) {
                return Tab(
                  text: e,
                );
              }).toList(),
              labelColor: Colors.white,
              indicator: BoxDecoration(
                  // Customize the indicator
                  color: primary,
                  borderRadius: BorderRadius.circular(4.0),
                  gradient: LinearGradient(colors: [
                    primaryDeep,
                    primaryLight
                  ]) // Set the color of the selected tab
                  ),
            ),
          ),
          body: TabBarView(
            children:
                userTapPotions.map((e) => Container(
                  child: FutureBuilder(  
                    future: allocationData,
                    builder: (context, AsyncSnapshot<AllocationList?> snapshot){
                      if(snapshot.hasData){
                        return createAllocationPage(snapshot.data!.allocations, context);
                      }else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                )).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          )),
    );
  }
  
  Widget createAllocationPage(List<Allocation>? allocations, BuildContext context) {
    return Container(
      
    );
  }
}
