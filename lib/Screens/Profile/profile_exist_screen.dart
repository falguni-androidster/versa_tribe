import 'dart:async';

import 'package:flutter/material.dart';
import 'package:versa_tribe/Screens/home_screen.dart';
import 'package:versa_tribe/extension.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProfileExistScreen extends StatefulWidget {
  const ProfileExistScreen({super.key});

  @override
  State<ProfileExistScreen> createState() => _ProfileExistScreenState();
}

class _ProfileExistScreenState extends State<ProfileExistScreen> {

  @override
  void initState() {
    super.initState();
    //Navigates to new screen after 3 seconds.
    Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen(popUp: true)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      body:  SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularPercentIndicator(
                lineWidth: 30.0,
                radius: 150.0,
                animation: true,
                animationDuration: 1500,
                percent: 1.0,
                progressColor: CustomColors.kBlueColor
            ),
            const SizedBox(height: 20),
            const Text(
                CustomString.profileReady,
                style: TextStyle(color: CustomColors.kBlackColor, fontSize: 30, fontFamily: 'Poppins', fontWeight: FontWeight.w600)
            ),
          ],
        ),
      )
    );
  }
}
