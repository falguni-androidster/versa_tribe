import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Screens/home_screen.dart';
import 'package:versa_tribe/Screens/onboarding_screen.dart';
import 'package:versa_tribe/Screens/sign_in_screen.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';
import 'package:versa_tribe/Utils/image_path.dart';
import '../Utils/custom_string.dart';

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
    bool isFirstTimeUser = prefs.getBool(CustomString.firstTimeUser) ?? true;
    bool isLoggedIn = prefs.getBool(CustomString.isLoggedIn) ?? false;

    if (isFirstTimeUser) {
      // First-time user, show onboarding screen
      // Delay for 3 seconds and then navigate to the Onboarding screen
      // Add a delay to simulate a splash screen.
      Future.delayed(const Duration(seconds: 5), () {
        // Navigate to the next screen after the delay.
        _navigateToNextScreen(context: context, screenName: 'onBoardingScreen');
      });
      // Set isFirstTimeUser to false
      await prefs.setBool(CustomString.firstTimeUser, false);
    } else {
      // Not a first-time user, navigate to the home screen or any other screen
      Future.delayed(const Duration(seconds: 5), (){
        // Navigate to the next screen after the delay.
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else if (screenName == 'onBoardingScreen') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
    }
  }

}
