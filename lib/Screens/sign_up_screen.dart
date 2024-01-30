import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/sign_in_screen.dart';

import 'package:versa_tribe/extension.dart';

import '../Utils/auth_options.dart';

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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.06),
                  const Text(
                    'Hello!',
                    style: TextStyle(fontSize: 50, color: CustomColors.kBlueColor, fontFamily: 'Poppins', fontWeight: FontWeight.w500, decoration: TextDecoration.underline, decorationColor: CustomColors.kBlueColor)),

                  SizedBox(height: size.height * 0.015),

                  const Text(
                    CustomString.signupStarted,
                    style: TextStyle(fontSize: 20, fontFamily: 'Poppins',color: CustomColors.kLightGrayColor)),

                  SizedBox(height: size.height * 0.03),

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
                        }},
                      decoration: const InputDecoration(
                          labelText: CustomString.emailAddress,
                          labelStyle: TextStyle(color: CustomColors.kLightGrayColor,fontSize: 14, fontFamily: 'Poppins')
                      ),
                      style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins')
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// Password Field
                  Consumer<SignUpPwdProvider>(builder: (context, val, child) {
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
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              child: Icon(
                                  val.visible == true ? Icons.visibility : Icons.visibility_off, color: CustomColors.kLightGrayColor),
                                  onTap: () {
                                    val.setVisible();
                                  },
                                ),
                            labelText: CustomString.password,
                            labelStyle: const TextStyle(color: CustomColors.kLightGrayColor,fontSize: 14, fontFamily: 'Poppins')
                        ),
                        style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                      ),
                    );
                  }),

                  SizedBox(height: size.height * 0.02),

                  /// Confirm Password Field
                  Consumer<ConfirmPwdProvider>(builder: (context, val, child) {
                    return SizedBox(
                      height: size.height*0.06,
                      child: TextFormField(
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
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              child: Icon(
                                  val.visible == true ? Icons.visibility : Icons.visibility_off, color: CustomColors.kLightGrayColor),
                                  onTap: () {
                                    val.setVisible();
                                  },
                                ),
                            labelText: CustomString.confirmPassword,
                            labelStyle: const TextStyle(color: CustomColors.kLightGrayColor,fontSize: 14, fontFamily: 'Poppins')
                        ),
                        style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins')
                      ),
                    );
                  }),

                  SizedBox(height: size.height * 0.02),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()){
                          ApiConfig().signUpClick(context: context, emailController: emailController, passwordController: passwordController, confirmPasswordController: confirmPasswordController);
                        }},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.kBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.all(16)
                      ),
                      child: const Text(
                        CustomString.signUp,
                        style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.white)
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.01),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        CustomString.continueWith,
                        style: TextStyle(
                          color: CustomColors.kLightGrayColor,
                          fontFamily: 'Poppins',
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
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              AuthOP().googleSignInMethod(context: context);
                            },
                            icon: Image.asset(ImagePath.googlePath),
                            label: const Text(CustomString.google,
                                style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              foregroundColor: CustomColors.kBlackColor,
                              backgroundColor: CustomColors.kGrayColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              AuthOP().facebookAuth(context: context);
                            },
                            icon: Image.asset(ImagePath.facebookPath),
                            label: const Text(CustomString.facebook, style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                                foregroundColor: CustomColors.kBlackColor,
                                backgroundColor: CustomColors.kGrayColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.all(12)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.01),

                  /// SignIn Text
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignInScreen()));
                      },
                    highlightColor: CustomColors.kWhiteColor,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          CustomString.alreadyHaveAccount,
                          style: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w600)
                        ),
                        Text(
                          CustomString.signIn,
                          style: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins', decoration: TextDecoration.underline, fontWeight: FontWeight.w600)
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
}
