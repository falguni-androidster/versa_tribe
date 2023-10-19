import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:versa_tribe/Screens/sign_in_screen.dart';
import 'package:versa_tribe/Utils/custom_toast.dart';

import '../Utils/api_config.dart';
import '../Utils/custom_colors.dart';
import '../Utils/custom_string.dart';
import '../Utils/validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kWhiteColor,
        leading: InkWell(
          child: const Icon(Icons.arrow_back, color: CustomColors.kBlackColor),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    CustomString.forgotPassword,
                    style: TextStyle(
                        fontSize: 50,
                        color: CustomColors.kBlackColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0,top: 10.0),
                  child: Text(
                    CustomString.forgotMessage,
                    style: TextStyle(
                        fontSize: 16, color: CustomColors.kLightGrayColor),
                  ),
                ),
                const SizedBox(height: 20),

                /// Email Address Field
                Padding(
                  padding: const EdgeInsets.all(10.0),
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

                /// SignUp Button
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        forgotClick(context);
                        },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.kBlackColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.all(16)
                      ),
                      child: const Text(
                        CustomString.submit,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ]
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

  Future<void> forgotClick(context) async {
    if (_formKey.currentState!.validate()) {
      if(connectivityResult == ConnectivityResult.none){
        showToast(context, CustomString.checkNetworkConnection);
      } else if(connectivityResult == ConnectivityResult.mobile){
        showToast(context, CustomString.notConnectServer);
      } else {
        // put Loading
        Map data = {
          'Email': emailController.text.toString(),
        };

        const String forgotUrl = '${ApiConfig.baseUrl}/api/Account/ForgotPassword';
        final response = await http.post(Uri.parse(forgotUrl), body: data);
        if (response.statusCode == 200) {
          showToast(context, CustomString.forgotPwdMessage);
          if (!mounted) return;
          _navigateToNextScreen(context);
        } else if (response.statusCode == 400){
          showToast(context, response.body);
        } else {
          showToast(context, CustomString.wrongEmail);
        }
      }
    }
  }
}
