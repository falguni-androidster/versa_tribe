import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Screens/home_screen.dart';
import 'package:versa_tribe/Screens/onboarding_screen.dart';
import 'package:versa_tribe/Screens/sign_in_screen.dart';
import 'package:versa_tribe/extension.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkFirstTimeUser();
  }

  Future<void> checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isFirstTimeUser = prefs.getBool(CustomString.firstTimeUser) ?? true;
    bool isLoggedIn = prefs.getSharedPrefBoolValue(
        key: CustomString.isLoggedIn) ?? false;

    Future.delayed(const Duration(seconds: 3), () {
      if (isLoggedIn) {
        // User is already logged in, navigate to home page
        _navigateToNextScreen(context: context, screenName: 'homeScreen');
      } else {
        _navigateToNextScreen(context: context, screenName: 'signInScreen');
      }
    });


    /*if (isFirstTimeUser) {
      Future.delayed(const Duration(seconds: 3), () {
        _navigateToNextScreen(context: context, screenName: 'onBoardingScreen');
      });
      // Set isFirstTimeUser to false
      await prefs.setBool(CustomString.firstTimeUser, false);
    } else {
      Future.delayed(const Duration(seconds: 3), (){
        if (isLoggedIn) {
          // User is already logged in, navigate to home page
          _navigateToNextScreen(context: context, screenName: 'homeScreen');
        }else{
          _navigateToNextScreen(context: context, screenName: 'signInScreen');
        }
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.kWhiteColor,
      alignment: Alignment.center,
      child: Image.asset(ImagePath.splashPath),
    );
  }

  // Navigate to Next Screen
  Future<void> _navigateToNextScreen({context, screenName}) async {
    if (screenName == 'signInScreen') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignInScreen()));
    } else if (screenName == 'homeScreen') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else if (screenName == 'onBoardingScreen') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
    }
  }

}
