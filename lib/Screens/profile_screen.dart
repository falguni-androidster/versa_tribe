import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';
import 'package:versa_tribe/Utils/image_path.dart';
import 'package:http/http.dart' as http;

import '../Providers/profile_provider.dart';
import '../Utils/api_config.dart';
import '../Utils/custom_string.dart';
import '../Utils/custom_toast.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  DateTime date = DateTime.now(); // Initialize with current date
  String? selectDate;
  String? selectGender;
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CustomColors.kLightColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Center(
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage:
                        AssetImage(ImagePath.profilePath),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),

                    /// First Name Form Field
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: fNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return CustomString.fNameRequired;
                          } // using regular expression
                          else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            labelText: CustomString.firstName,
                            labelStyle: TextStyle(color: CustomColors.kLightGrayColor,fontSize: 14)
                        ),
                        style: const TextStyle(color: CustomColors.kBlackColor),
                      ),
                    ),

                    /// Last Name Form Field
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: lNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return CustomString.lNameRequired;
                          } // using regular expression
                          else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            labelText: CustomString.lastName,
                            labelStyle: TextStyle(color: CustomColors.kLightGrayColor,fontSize: 14)
                        ),
                        style: const TextStyle(color: CustomColors.kBlackColor),
                      ),
                    ),

                    /// Gender Field
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0),
                      child: Text(
                        CustomString.selectGender,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        radioButton(CustomString.male),
                        const Text(CustomString.male),
                        radioButton(CustomString.female),
                        const Text(CustomString.female),
                        radioButton(CustomString.other),
                        const Text(CustomString.other),
                      ],
                    ),

                    /// Date of Birth Field
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0,right: 8.0),
                      child: Text(
                        CustomString.dateOfBirth,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: OutlinedButton.icon(
                        onPressed: () => _selectDate(context),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          selectDate =  DateFormat('yyyy-MM-dd').format(date),
                          style: const TextStyle(
                              fontSize: 16,color: CustomColors.kBlackColor),
                        ),
                      ),
                    ),

                    /// City Form Field
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: cityController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return CustomString.cityRequired;
                          } // using regular expression
                          else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            labelText: CustomString.city,
                            labelStyle: TextStyle(color: CustomColors.kLightGrayColor,fontSize: 14)
                        ),
                        style: const TextStyle(color: CustomColors.kBlackColor),
                      ),
                    ),

                    /// Country Form Field
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: countryController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return CustomString.countryRequired;
                          } // using regular expression
                          else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            labelText: CustomString.country,
                            labelStyle: TextStyle(color: CustomColors.kLightGrayColor,fontSize: 14)
                        ),
                        style: const TextStyle(color: CustomColors.kBlackColor),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            profileClick(context);
                          },
                          child: const Text(
                            CustomString.submit,
                            style: TextStyle(color: CustomColors.kBlueColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _navigateToNextScreen(context),
                          child: const Text(
                            CustomString.cancel,
                            style: TextStyle(color: CustomColors.kBlueColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  Widget radioButton(String gender) {
    return Consumer<ProfileProvider>(builder: (context, val, child) {
      return Radio<String>(
        fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return CustomColors.kBlueColor;
          }
          return CustomColors.kLightGrayColor;
        }),
        value: gender,
        groupValue: selectGender = val.selectedValue,
        onChanged: (value) {
          val.setGenderValue(value);
        },
      );
    });
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  Future<void> profileClick(context) async {
    if (_formKey.currentState!.validate()) {
      if(connectivityResult == ConnectivityResult.none){
        showToast(context, CustomString.checkNetworkConnection);
      } else if(connectivityResult == ConnectivityResult.mobile){
        showToast(context, CustomString.notConnectServer);
      } else {

        // Put Loading
        SharedPreferences pref = await SharedPreferences.getInstance();
        String? token = pref.getString(CustomString.accessToken);

        Map data = {
          'FirstName': fNameController.text.toString(),
          'LastName': lNameController.text.toString(),
          'Gender': selectGender,
          'City': cityController.text.toString(),
          'Country': countryController.text.toString(),
          'DOB': selectDate
        };

        const String profileUrl = '${ApiConfig.baseUrl}/api/Person/Create';
        final response = await http.post(Uri.parse(profileUrl), body: jsonEncode(data), headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
        if (response.statusCode == 200) {
          showToast(context, CustomString.profileSuccessCreated);
          if (!mounted) return;
          _navigateToNextScreen(context);
        } else {
          showToast(context, CustomString.somethingWrongMessage);
        }
      }
    }
  }
}
