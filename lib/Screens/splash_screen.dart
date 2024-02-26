import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    bool isFirstTimeUser = prefs.getSharedPrefBoolValue(key: CustomString.firstTimeUser) ?? true;
    bool isLoggedIn = prefs.getSharedPrefBoolValue(key: CustomString.isLoggedIn) ?? false;

    if (isFirstTimeUser) {
      Future.delayed(const Duration(seconds: 3), () {
        prefs.setBool("pop", true);
        _navigateToNextScreen(context: context, screenName: 'onBoardingScreen');
      });
      // Set isFirstTimeUser to false
      await prefs.setSharedPrefBoolValue(key: CustomString.firstTimeUser, false);
    } else {
      Future.delayed(const Duration(seconds: 3), (){
        prefs.setBool("pop", false);
        if (isLoggedIn) {
          // User is already logged in, navigate to home page
          _navigateToNextScreen(context: context, screenName: 'homeScreen');
        }else{
          _navigateToNextScreen(context: context, screenName: 'signInScreen');
        }
      });
    }
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
      Navigator.pushNamed(context, '/home');
    } else if (screenName == 'onBoardingScreen') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
    }
  }

}
