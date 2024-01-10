import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class CreateProfileScreen extends StatefulWidget {

  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> with WidgetsBindingObserver{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // App is in the background, clear SharedPreferences here
      clearSharedPref();
    }
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text(CustomString.dialogTitle, style: TextStyle(fontFamily: 'Poppins')),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context, false);
                  },
                  child: const Text(CustomString.dialogNo, style: TextStyle(fontFamily: 'Poppins')),
                ),
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () async {
                      Navigator.pop(context, true);
                      clearSharedPref();
                    },
                    child: const Text(CustomString.dialogYes, style: TextStyle(fontFamily: 'Poppins'))),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        backgroundColor: CustomColors.kWhiteColor,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  SizedBox(height: size.height * 0.05),

                  /// Profile Pic
                  const Center(
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                      AssetImage(ImagePath.profilePath),
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// First Name Form Field
                  TextFormField(
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
                        labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')
                    ),
                    style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins'),
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// Last Name Form Field
                  TextFormField(
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
                        labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')
                    ),
                    style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins'),
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// Gender Field
                  const Text(
                    CustomString.selectGender,
                    style: TextStyle(fontSize: 14,fontFamily: 'Poppins'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      radioButton(CustomString.male),
                      const Text(CustomString.male,style: TextStyle(fontFamily: 'Poppins',fontSize: 12)),
                      SizedBox(width: size.width * 0.1),
                      radioButton(CustomString.female),
                      const Text(CustomString.female,style: TextStyle(fontFamily: 'Poppins',fontSize: 12)),
                    ],
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// Date of Birth Field
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return CustomString.dateOfBirthRequired;
                      } else {
                        return null;
                      }
                    },
                    controller: dobController,
                    textAlign: TextAlign.start,
                    //editing controller of this TextField
                    decoration: const InputDecoration(
                      labelText: CustomString.dateOfBirth,
                      labelStyle: TextStyle(
                          color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins'),
                      suffixIcon: Icon(Icons.calendar_month,
                          color: CustomColors.kBlueColor),
                    ),
                    style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins'),
                    onTap: () async {
                      _showDatePicker(context: context);
                    },
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// City Form Field
                  TextFormField(
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
                        labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')
                    ),
                    style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins'),
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// Country Form Field
                  TextFormField(
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
                        labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins'),
                    ),
                    style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins'),
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// Create Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ApiConfig().createProfile(context: context, popUp: true, fNameController: fNameController, lNameController: lNameController, genderController: genderController, dobController: dobController, cityController: cityController, countryController: countryController);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.kBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.all(14)),
                      child: const Text(
                        CustomString.createProfile,
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
      ),
    );
  }

  _showDatePicker({context}) async {
    final provider = Provider.of<DobProvider>(context, listen: false);
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
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: CustomColors.kBlueColor // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      debugPrint(
          "PickedData-------->$pickedDate"); //pickedDate output format => 2021-03-10 00:00:00.000
      String formatYopDate = DateFormat('yyyy-MM-dd')
          .format(pickedDate); // we also use "dd-MM-yyyy" format or may more..
      debugPrint(
          "FormattedData----->$formatYopDate"); //formatted date output using intl package =>  2021-03-16
      provider.setDobDate(formatYopDate); //set output date to TextField value.
      dobController.text = provider.dobInput;
    } else {}
  }

  Widget radioButton(String gender) {
    return Consumer<ProfileGenderProvider>(builder: (context, val, child) {
      return Radio<String>(
        fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return CustomColors.kBlueColor;
          }
          return CustomColors.kLightGrayColor;
        }),
        value: gender,
        groupValue: val.selectedValue,
        onChanged: (value) {
          val.setGenderValue(value);
        },
      );
    });
  }
}
