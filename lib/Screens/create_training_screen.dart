import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';

import '../Providers/date_provider.dart';
import '../Utils/custom_string.dart';

class CreateTrainingScreen extends StatefulWidget {
  const CreateTrainingScreen({super.key});

  @override
  State<CreateTrainingScreen> createState() => _CreateTrainingScreenState();
}

class _CreateTrainingScreenState extends State<CreateTrainingScreen> {

  final _form = GlobalKey<FormState>();
  TextEditingController trainingNameController = TextEditingController();
  TextEditingController trainingDiscriptionController = TextEditingController();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

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
        title: const Text(CustomString.training, style: TextStyle(color: CustomColors.kBlueColor)),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),

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
                      labelStyle: TextStyle(
                          color: CustomColors.kLightGrayColor,
                          fontSize: 14)),
                  style: const TextStyle(color: CustomColors.kBlackColor),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

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
                      labelStyle: TextStyle(
                          color: CustomColors.kLightGrayColor,
                          fontSize: 14)
                  ),
                  style: const TextStyle(color: CustomColors.kBlackColor),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Start Date & End Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    ///Start date
                    Expanded(
                      child: Consumer<DateProvider>(
                          builder: (context,val,child) {
                            return TextField(
                              controller: startDateController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: CustomColors.kBlackColor),
                              //editing controller of this TextField
                              decoration: const InputDecoration(
                                  labelText: CustomString.startDate,
                                  labelStyle: TextStyle(
                                      color: CustomColors.kLightGrayColor,
                                      fontSize: 14),
                                prefixIcon: Icon(Icons.calendar_today, color: CustomColors.kBlueColor),
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
                                          onSurface: CustomColors.kBlackColor, // <-- SEE HERE
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                              foregroundColor: CustomColors.kBlueColor// button text color
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (pickedDate != null) {
                                  debugPrint("Start-PickedData-------->$pickedDate"); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                  debugPrint("Start-FormattedData----->$formattedDate"); //formatted date output using intl package =>  2021-03-16
                                  val.setStartDate(formattedDate, pickedDate);//set output date to TextField value.
                                  endDateController.text = "";// set empty end date TextField when start date select.
                                  startDateController.text = val.startDateInput;
                                } else {
                                }

                              },
                            );
                          }
                      ),
                    ),
                    SizedBox(width: size.width * 0.05),

                    ///End date
                    Expanded(
                      child: Consumer<DateProvider>(
                          builder: (context,val,child) {
                            return TextField(
                              controller: endDateController,textAlign: TextAlign.center,
                              style: const TextStyle(color: CustomColors.kBlackColor),
                              //editing controller of this TextField
                              decoration: const InputDecoration(
                                labelText: CustomString.endDate,
                                labelStyle: TextStyle(
                                    color: CustomColors.kLightGrayColor,
                                    fontSize: 14),
                                prefixIcon: Icon(Icons.calendar_today, color: CustomColors.kBlueColor),
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
                                          onSurface: CustomColors.kBlackColor, // <-- SEE HERE
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                              foregroundColor: CustomColors.kBlueColor// button text color
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (pickedDate != null) {
                                  debugPrint("End-PickedData-------->$pickedDate"); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                  debugPrint("End-FormattedData----->$formattedDate"); //formatted date output using intl package =>  2021-03-16
                                  val.setEndDate(formattedDate); //set output date to TextField value.
                                  endDateController.text = val.endDateInput;
                                } else {
                                }
                              },
                            );
                          }
                      ),
                    ),
                  ],
                ),

                SizedBox(
                    height: size.height * 0.02
                ),

                /// Elevated Create training Button
                SizedBox(
                    width: double.infinity,
                    height: size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_form.currentState!.validate()) {
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(CustomColors.kBlueColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: CustomColors.kBlueColor)))),
                      child: const Text(CustomString.createTraining,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
