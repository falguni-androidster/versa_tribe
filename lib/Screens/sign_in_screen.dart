import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/sign_up_screen.dart';
import '../Utils/auth_options.dart';
import 'forgot_password_screen.dart';
import 'package:versa_tribe/extension.dart';

class SignInScreen extends StatefulWidget {

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ConnectivityResult connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    // Listen for connectivity changes and update the UI accordingly.
    connection(context);
   // checkSignInStatus();
  }
  // void checkSignInStatus() async {
  //   bool isSignedIn = await googleSignIn.isSignedIn();
  //   if (isSignedIn) {
  //     debugPrint("User Signed In");
  //   } else {
  //     debugPrint("User Signed Out");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.05),
                  const Text(
                    CustomString.hello,
                    style: TextStyle(
                        fontSize: 50,
                        color: CustomColors.kBlueColor,
                        fontFamily: 'Poppins'),
                  ),

                  const Text(
                    CustomString.again,
                    style: TextStyle(
                        fontSize: 50,
                        color: CustomColors.kBlueColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.underline,
                        decorationColor: CustomColors.kBlueColor),
                  ),

                  SizedBox(height: size.height * 0.02),

                  const Text(
                    CustomString.welcomeBack,
                    style: TextStyle(
                        fontSize: 20,
                        color: CustomColors.kLightGrayColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400),
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// Email Address Field
                  SizedBox(
                    height: size.height*0.06,
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return CustomString.emailRequired;
                        } // using regular expression
                        else if (!Validator().regEmail.hasMatch(value)) {
                          return CustomString.validEmailAddress;
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: CustomString.emailAddress,
                          labelStyle: TextStyle(
                              color: CustomColors.kLightGrayColor,
                              fontSize: 14,
                              fontFamily: 'Poppins')),
                      style: const TextStyle(
                          fontSize: 14,
                          color: CustomColors.kBlackColor,
                          fontFamily: 'Poppins'),
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// Password Field
                  Consumer<SignInPwdProvider>(builder: (context, val, child) {
                    return SizedBox(
                      height: size.height*0.06,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: val.visible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return CustomString.passwordRequired;
                          } // using regular expression
                          else if (!Validator().regPassword.hasMatch(value)) {
                            return CustomString.validPassword;
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(
                            fontSize: 14,
                            color: CustomColors.kBlackColor,
                            fontFamily: 'Poppins'),
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              child: Icon(
                                  val.visible == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: CustomColors.kLightGrayColor),
                              onTap: () {
                                val.setVisible();
                              },
                            ),
                            labelText: CustomString.password,
                            labelStyle: const TextStyle(
                                color: CustomColors.kLightGrayColor,
                                fontSize: 14,
                                fontFamily: 'Poppins')
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: size.height * 0.02),

                  /// Forgot Password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        _navigateToNextScreen(
                            context: context, screenName: 'forgotScreen');
                      },
                      child: const Text(
                        CustomString.forgotPassword,
                        style: TextStyle(
                            color: CustomColors.kBlueColor,
                            fontSize: 14,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// SignIn Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ApiConfig().signInClick(context: context,emailController: emailController,passwordController: passwordController);
                        } else {
                          return;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.kBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.all(16)),
                      child: const Text(
                        CustomString.signIn,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      CustomString.continueWith,
                      style: TextStyle(
                          color: CustomColors.kLightGrayColor,
                          fontSize: 14,
                          fontFamily: 'Poppins'),
                    ),
                  ),

                  SizedBox(height: size.height * 0.01),

                  /// Social Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              AuthOP().googleSignInMethod(context: context);
                            },
                            icon: Image.asset(ImagePath.googlePath),
                            label: const Text(CustomString.google,
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                                foregroundColor: CustomColors.kLightGrayColor,
                                backgroundColor: CustomColors.kGrayColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.all(12)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: (){
                              AuthOP().facebookAuth(context: context);
                            },//_loginWithFacebook,
                            icon: Image.asset(ImagePath.facebookPath),
                            label: const Text(CustomString.facebook,
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                                foregroundColor: CustomColors.kLightGrayColor,
                                backgroundColor: CustomColors.kGrayColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.all(12)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.01),

                  /// SignUP Text
                  InkWell(
                    onTap: () {
                      _navigateToNextScreen(context: context, screenName: 'signupScreen');
                    },
                    highlightColor: CustomColors.kWhiteColor,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          CustomString.donTHaveAccount,
                          style: TextStyle(
                              color: CustomColors.kLightGrayColor,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          CustomString.signUp,
                          style: TextStyle(
                              color: CustomColors.kLightGrayColor,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  // Navigate to Next Screen
  Future<void> _navigateToNextScreen({context, screenName}) async {
    if (screenName == 'signupScreen') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignUpScreen()));
    } else if (screenName == 'forgotScreen') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
    }
  }
}
