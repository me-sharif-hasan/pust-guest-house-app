import 'package:flutter/material.dart';

class MonthlyStat extends StatefulWidget {
  const MonthlyStat({super.key});

  @override
  State<MonthlyStat> createState() => _MonthlyStatState();
}

class _MonthlyStatState extends State<MonthlyStat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Monthly Stat')),
    );
  }
}