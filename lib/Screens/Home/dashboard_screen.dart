import 'package:flutter/material.dart';
import 'package:versa_tribe/extension.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Home",style: TextStyle(fontSize: 25,color: CustomColors.kBlueColor),),),
    );
  }
}
