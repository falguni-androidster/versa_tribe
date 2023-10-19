import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Providers/confirm_password_provider.dart';
import 'package:versa_tribe/Screens/sign_in_screen.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';

import 'package:http/http.dart' as http;
import 'package:versa_tribe/Utils/custom_toast.dart';
import 'package:versa_tribe/Utils/image_path.dart';

import '../Providers/password_provider.dart';
import '../Utils/api_config.dart';
import '../Utils/custom_string.dart';
import '../Utils/validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  ConnectivityResult connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    // Check initial connectivity status when the widget is first built.
    _checkConnectivity();
    // Listen for connectivity changes and update the UI accordingly.
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        connectivityResult = result;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    var connectResult = await Connectivity().checkConnectivity();
    setState(() {
      connectivityResult = connectResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CustomColors.kWhiteColor,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.06),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      CustomString.hello,
                      style: TextStyle(
                          fontSize: 50,
                          color: CustomColors.kBlackColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      CustomString.signupStarted,
                      style: TextStyle(
                          fontSize: 20, color: CustomColors.kLightGrayColor),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  /// Email Address Field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                          labelStyle: TextStyle(color: CustomColors.kLightGrayColor,fontSize: 14)
                      ),
                      style: const TextStyle(color: CustomColors.kBlackColor),
                    ),
                  ),

                  /// Password Field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<PwdProvider>(builder: (context, val, child) {
                      return TextFormField(
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
                        style: const TextStyle(color: CustomColors.kBlackColor),
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              child: Icon(
                                  val.visible == true ? Icons.visibility : Icons.visibility_off, color: CustomColors.kBlackColor),
                                  onTap: () {
                                    val.setVisible();
                                  },
                                ),
                            labelText: CustomString.password,
                            labelStyle: const TextStyle(color: CustomColors.kLightGrayColor,fontSize: 14)
                        ),
                      );
                    }),
                  ),

                  /// Confirm Password Field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<ConfirmPwdProvider>(builder: (context, val, child) {
                      return TextFormField(
                        controller: confirmPasswordController,
                        obscureText: val.visible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return CustomString.confirmPasswordRequired;
                          } // using regular expression
                          else if (!Validator().regPassword.hasMatch(value)) {
                            return CustomString.validConfirmPassword;
                          } else{
                            return null;
                          }
                          },
                        style: const TextStyle(color: CustomColors.kBlackColor),
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              child: Icon(
                                  val.visible == true ? Icons.visibility : Icons.visibility_off, color: CustomColors.kBlackColor),
                                  onTap: () {
                                    val.setVisible();
                                  },
                                ),
                            labelText: CustomString.confirmPassword,
                            labelStyle: const TextStyle(color: CustomColors.kLightGrayColor,fontSize: 14)
                        ),
                      );
                    }),
                  ),

                  /// SignUp Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          signUpClick(context);
                          },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.kBlackColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.all(16)
                        ),
                        child: const Text(
                          CustomString.signUp,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        CustomString.continueWith,
                        style: TextStyle(
                          color: CustomColors.kLightGrayColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  /// Social Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Handle social button click
                            },
                            icon: Image.asset(ImagePath.facebookPath),
                            label: const Text(CustomString.facebook),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black, backgroundColor: CustomColors.kGrayColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Handle social button click
                            },
                            icon: Image.asset(ImagePath.googlePath),
                            label: const Text(CustomString.google),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black, backgroundColor: CustomColors.kGrayColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// SignIn Text
                  InkWell(
                    onTap: () {
                      _navigateToNextScreen(context);
                      },
                    highlightColor: CustomColors.kWhiteColor,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          CustomString.alreadyHaveAccount,
                          style: TextStyle(color: CustomColors.kLightGrayColor,fontSize: 14),
                        ),
                        Text(
                          CustomString.signInNow,
                          style: TextStyle(color: CustomColors.kBlackColor,fontSize: 14,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }

  // Navigate to next Screen
  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  Future<void> signUpClick(context) async {
    if (_formKey.currentState!.validate()) {
      if(connectivityResult == ConnectivityResult.none){
        showToast(context, CustomString.checkNetworkConnection);
      } else if(connectivityResult == ConnectivityResult.mobile){
        showToast(context, CustomString.notConnectServer);
      } else {
        if (passwordController.text.toString() != confirmPasswordController.text.toString()) {
          showToast(context, CustomString.passwordAndConfirmPasswordNotMatch);
        }
        // Put Loading
        Map data = {
          'Email': emailController.text.toString(),
          'Password': passwordController.text.toString(),
          'ConfirmPassword': confirmPasswordController.text.toString()
        };

        const String signupUrl = '${ApiConfig.baseUrl}/api/Account/Register';
        final response = await http.post(Uri.parse(signupUrl), body: data);
        if (response.statusCode == 200) {
          showToast(context, CustomString.accountSuccessCreated);
          if (!mounted) return;
          _navigateToNextScreen(context);
        } else if (response.statusCode == 400){
          showToast(context, CustomString.accountAlreadyTaken);
        } else {
          showToast(context, CustomString.somethingWrongMessage);
        }
      }
    }
  }
}


