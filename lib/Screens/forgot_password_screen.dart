import 'package:flutter/material.dart';
import 'package:versa_tribe/extension.dart';

class ForgotPasswordScreen extends StatefulWidget {

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kWhiteColor,
        leading: InkWell(
          child:
              const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                CustomString.forgotPassword,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: CustomColors.kLightGrayColor,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              const Text(
                CustomString.forgotMessage,
                style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.kLightGrayColor,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400),
              ),

              SizedBox(height: size.height * 0.02),

              /// Email Address Field
              TextFormField(
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
                  color: CustomColors.kBlackColor,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),

              SizedBox(height: size.height * 0.02),

              /// SignUp Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ApiConfig().forgotPasswordClick(context: context, emailController: emailController);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.kBlueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.all(14)),
                  child: const Text(
                    CustomString.submit,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
