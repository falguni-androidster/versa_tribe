import 'dart:async';

import 'package:flutter/material.dart';
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
    ApiConfig().getProfileData();
    //Navigates to new screen after 3 seconds.
    Timer(const Duration(seconds: 1), () {
      Navigator.pushNamed(context, '/home', arguments: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      body:  Center(
        child: SizedBox(
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
                  CustomString.profileReady, textAlign: TextAlign.center,
                  style: TextStyle(color: CustomColors.kBlackColor, fontSize: 30, fontFamily: 'Poppins', fontWeight: FontWeight.w600)
              ),
            ],
          ),
        ),
      )
    );
  }
}
