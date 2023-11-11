import 'package:flutter/material.dart';
import 'package:guest_house_pust/models/allocationModel.dart';
import 'package:guest_house_pust/util/variables.dart';

class RequestDetails extends StatelessWidget {
  final Allocation? allocation;
  const RequestDetails({super.key, this.allocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [],
      ),
      body: Container(
        child: Column(
          children: [
            Center(child: Text("Details ${allocation!.boarding_date}")),
          ],
        ),
      ),
    );
  }

  headingText(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
