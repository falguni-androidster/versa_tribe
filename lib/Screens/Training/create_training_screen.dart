import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:versa_tribe/Screens/Home/training_screen.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';

import '../../Providers/date_provider.dart';
import '../../Utils/api_config.dart';
import '../../Utils/custom_string.dart';
import '../../Utils/custom_toast.dart';

class CreateTrainingScreen extends StatefulWidget {

  const CreateTrainingScreen({super.key});

  @override
  State<CreateTrainingScreen> createState() => _CreateTrainingScreenState();
}

class _CreateTrainingScreenState extends State<CreateTrainingScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController trainingNameController = TextEditingController();
  TextEditingController trainingDiscriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController personLimitController = TextEditingController();

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
      appBar: AppBar(
        backgroundColor: CustomColors.kWhiteColor,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(CustomString.training, style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                SizedBox(height: size.height * 0.02),

                /// Training Name Field
                TextFormField(
                  controller: trainingNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return CustomString.trainingNameRequired;
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: CustomString.trainingName,
                      labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
                  style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')
                ),

                SizedBox(height: size.height * 0.02),

                /// Training Description Field
                TextFormField(
                  controller: trainingDiscriptionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return CustomString.trainingDescriptionRequired;
                    } else {
                      return null;
                    }
                  },
                  maxLines: 10,
                  maxLength: 5000,
                  decoration: const InputDecoration(
                      labelText: CustomString.trainingDescription,
                      labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
                  style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')
                ),

                SizedBox(height: size.height * 0.02),

                /// Start Date & End Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    /// Start date
                    Expanded(child: Consumer<TrainingDobProvider>(builder: (context, val, child) {
                        return TextField(
                          controller: startDateController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                          //editing controller of this TextField
                          decoration: const InputDecoration(
                            labelText: CustomString.startDate,
                            labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins'),
                            prefixIcon: Icon(Icons.calendar_today, color: CustomColors.kBlueColor)
                          ),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1970),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2030),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: CustomColors.kBlueColor, // <-- SEE HERE
                                      onPrimary: CustomColors.kWhiteColor, // <-- SEE HERE
                                      onSurface: CustomColors.kBlackColor // <-- SEE HERE
                                    ),
                                    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: CustomColors.kBlueColor)),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              debugPrint("Start-PickedData-------->$pickedDate"); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                              debugPrint("Start-FormattedData----->$formattedDate"); //formatted date output using intl package =>  2021-03-16
                              val.setTrainingStartDate(formattedDate, pickedDate); //set output date to TextField value.
                              endDateController.text = ""; // set empty end date TextField when start date select.
                              startDateController.text = val.trainingStartDateInput;
                            } else {}
                          },
                        );
                      }),
                    ),

                    SizedBox(width: size.width * 0.05),

                    /// End date
                    Expanded(child: Consumer<TrainingDobProvider>(builder: (context, val, child) {
                        return TextField(
                          controller: endDateController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: CustomColors.kBlackColor),
                          //editing controller of this TextField
                          decoration: const InputDecoration(
                            labelText: CustomString.endDate,
                            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            floatingLabelAlignment: FloatingLabelAlignment.center,
                            labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins'),
                            prefixIcon: Icon(Icons.calendar_today, color: CustomColors.kBlueColor)
                          ),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: val.pickedDate,
                              firstDate: val.pickedDate,
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2030),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: CustomColors.kBlueColor, // <-- SEE HERE
                                      onPrimary: CustomColors.kWhiteColor, // <-- SEE HERE
                                      onSurface: CustomColors.kBlackColor // <-- SEE HERE
                                    ),
                                    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: CustomColors.kBlueColor)),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              debugPrint("End-PickedData-------->$pickedDate"); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                              debugPrint("End-FormattedData----->$formattedDate"); //formatted date output using intl package =>  2021-03-16
                              val.setTrainingEndDate(formattedDate); //set output date to TextField value.
                              endDateController.text = val.trainingEndDateInput;
                            } else {}
                          },
                        );
                      }),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.02),

                /// Person Limit Field
                TextFormField(
                    controller: personLimitController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return CustomString.personLimitRequired;
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: CustomString.personLimit,
                        labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
                    style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')
                ),

                SizedBox(height: size.height * 0.02),

                /// Elevated Create training Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      createTrainingClick(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.kBlueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.all(16)),
                    child: const Text(
                      CustomString.createTraining,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createTrainingClick(context) async {
    if (_formKey.currentState!.validate()) {
      if (connectivityResult == ConnectivityResult.none) {
        showToast(context, CustomString.checkNetworkConnection);
      } else {
        // Put Loading
        const CircularProgressIndicator();

        /* Map data = {
          'Training_Name': trainingNameController.text.toString(),
          'Description': trainingDiscriptionController.text.toString(),
          'Start_Date': startDateController.text.toString(),
          'End_Date': endDateController.text.toString(),
          'PersonLimit': personLimitController.text.toString(),
        };

        const String trainingUrl = '${ApiConfig.baseUrl}/api/Training/Create?Org_Id=$orgId';
        final response = await http.post(Uri.parse(trainingUrl), body: jsonEncode(data), headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
        if (response.statusCode == 200) {
          showToast(context, CustomString.trainingCreatedSuccess);
          if (!mounted) return;
          _navigateToNextScreen(context);
        } else {
          showToast(context, CustomString.somethingWrongMessage);
        }
      }*/
      }
    }
  }

 /* void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const TrainingScreen()));
  }*/
}
