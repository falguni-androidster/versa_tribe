import 'package:flutter/material.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';
import 'package:versa_tribe/Utils/custom_string.dart';

class AddHobbyScreen extends StatefulWidget {
  const AddHobbyScreen({super.key});

  @override
  State<AddHobbyScreen> createState() => _AddHobbyScreenState();
}

class _AddHobbyScreenState extends State<AddHobbyScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController hobbyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kWhiteColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:
              const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
          //replace with our own icon data.
        ),
        centerTitle: true,
        title: const Text(CustomString.createHobby,
            style: TextStyle(color: CustomColors.kBlueColor)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mWidth * 0.04, vertical: mHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Hobby name
                TextFormField(
                    controller: hobbyController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return CustomString.hobbyRequired;
                      } else {
                        return null;
                      }
                    },
                    cursorColor: CustomColors.kBlueColor,
                    decoration: const InputDecoration(
                        labelText: CustomString.searchHobby,
                        labelStyle: TextStyle(
                            color: CustomColors.kLightGrayColor, fontSize: 14)),
                    style: const TextStyle(color: CustomColors.kBlackColor)),

                SizedBox(height: mHeight * 0.03),

                /// Submit Button
                SizedBox(
                    width: double.infinity,
                    height: mHeight * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ApiConfig.addHobbyData(
                              context: context,
                              hobbyName: hobbyController.text);
                        } else {
                          return;
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              CustomColors.kBlueColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                          color: Colors.transparent)))),
                      child: const Text(CustomString.buttonContinue,
                          style: TextStyle(
                            color: CustomColors.kWhiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          )),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
