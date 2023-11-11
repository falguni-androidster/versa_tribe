import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';
import 'package:versa_tribe/Utils/custom_string.dart';

import '../../Model/person_qualification.dart';
import '../../Providers/date_provider.dart';
import '../../Providers/person_details_provider.dart';

class EditQualificationScreen extends StatefulWidget {
  final String? courseName;
  final String? institute;
  final String? grade;
  final String? city;
  final String? yop;
  final int? pqID;

  const EditQualificationScreen(
      {super.key,
      required this.courseName,
      required this.institute,
      required this.grade,
      required this.city,
      required this.yop,
      required this.pqID});

  @override
  State<EditQualificationScreen> createState() =>
      _EditQualificationScreenState();
}

class _EditQualificationScreenState extends State<EditQualificationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController courseController = TextEditingController();
  TextEditingController instituteController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController yopController = TextEditingController();
  dynamic provider;
  dynamic providerInstitute;

  @override
  void initState() {
    provider = Provider.of<SearchCourseProvider>(context, listen: false);
    providerInstitute =
        Provider.of<SearchInstituteProvider>(context, listen: false);
    provider.courseList.clear();
    providerInstitute.instituteList.clear();
    // TODO: implement initState
    super.initState();

    if (courseController.text == "" &&
        instituteController.text == "" &&
        gradeController.text == "" &&
        cityController.text == "" &&
        yopController.text == "") {
      courseController.text = widget.courseName.toString();
      instituteController.text = widget.institute.toString();
      gradeController.text = widget.grade.toString();
      cityController.text = widget.city.toString();
      yopController.text = widget.yop.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchCourseProvider>(context, listen: false);
    final providerInstitute = Provider.of<SearchInstituteProvider>(context, listen: false);
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: CustomColors.kWhiteColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: CustomColors.kBlackColor,
            ), //replace with our own icon data.
          ),
          centerTitle: true,
          title: const Text(CustomString.editQualification,
              style: TextStyle(color: CustomColors.kBlueColor))),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mWidth * 0.04, vertical: mHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Course name
                Selector<PersonQualificationProvider,List<PersonQualificationModel>>(
                    selector: (_, val) => val.personQl,
                    builder: (context, personQl, child) {
                      return TextFormField(
                          controller: courseController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return CustomString.courseNameRequired;
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            if (value != "") {
                              ApiConfig.searchCourse(
                                  context: context, courseString: value);
                              provider.courseList.clear();
                              provider.setVisible(true);
                            }else{
                              provider.setVisible(false);
                            }
                            provider.courseList.clear();
                          },
                          decoration: const InputDecoration(
                              labelText: CustomString.courseName,
                              labelStyle: TextStyle(
                                  color: CustomColors.kLightGrayColor,
                                  fontSize: 14)),
                          style:
                              const TextStyle(color: CustomColors.kBlackColor));
                    }),
                Consumer<SearchCourseProvider>(builder: (context, val, child) {
                  return val.visible == true
                      ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.courseList.length,
                      itemBuilder: (context, index) {
                        debugPrint("Course name search--------->${val.courseList[index].couName}");
                        return InkWell(
                                child: Card(
                                  shadowColor: CustomColors.kBlueColor,
                                  elevation: 3,
                                  color: CustomColors.kGrayColor,
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: mWidth * 0.02),
                                      height: mHeight * 0.05,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          '${val.courseList[index].couName}',
                                          style: const TextStyle(
                                              color: CustomColors
                                                  .kLightGrayColor))),
                                ),
                                onTap: () async {
                                  courseController.text =
                                      val.courseList[index].couName ??
                                          courseController.text;
                                  val.setVisible(false);
                                },
                              );
                      }):Container();
                }),
                SizedBox(height: mWidth * 0.03),

                /// Institute name
                TextFormField(
                    controller: instituteController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return CustomString.instituteNameRequired;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      if (value != "") {
                        ApiConfig.searchInstitute(
                            context: context, instituteString: value);
                        providerInstitute.instituteList.clear();
                        providerInstitute.setVisible(true);
                      }else{
                        providerInstitute.setVisible(false);
                      }
                      providerInstitute.instituteList.clear();
                    },
                    decoration: const InputDecoration(
                        labelText: CustomString.instituteName,
                        labelStyle: TextStyle(
                            color: CustomColors.kLightGrayColor, fontSize: 14)),
                    style: const TextStyle(color: CustomColors.kBlackColor)),
                Consumer<SearchInstituteProvider>(
                    builder: (context, val, child) {
                  return val.visible == true
                      ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.instituteList.length,
                      itemBuilder: (context, index) {
                        debugPrint("institute name search--------->${val.instituteList[index].instName}");
                        return InkWell(
                                child: Card(
                                  shadowColor: CustomColors.kBlueColor,
                                  elevation: 3,
                                  color: CustomColors.kGrayColor,
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: mWidth * 0.02),
                                      height: mHeight * 0.05,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          '${val.instituteList[index].instName}',
                                          style: const TextStyle(
                                              color: CustomColors
                                                  .kLightGrayColor))),
                                ),
                                onTap: () async {
                                  instituteController.text =
                                      val.instituteList[index].instName ??
                                          instituteController.text;
                                  val.setVisible(false);
                                },
                              );
                      }): Container();
                }),
                SizedBox(height: mWidth * 0.03),

                /// Grade
                TextFormField(
                    controller: gradeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return CustomString.gradeRequired;
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: CustomString.grade,
                        labelStyle: TextStyle(
                            color: CustomColors.kLightGrayColor, fontSize: 14)),
                    style: const TextStyle(color: CustomColors.kBlackColor)),
                SizedBox(height: mWidth * 0.03),
                /// City
                TextFormField(
                    controller: cityController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return CustomString.cityRequired;
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: CustomString.city,
                        labelStyle: TextStyle(
                            color: CustomColors.kLightGrayColor, fontSize: 14)),
                    style: const TextStyle(color: CustomColors.kBlackColor)),
                SizedBox(height: mWidth * 0.03),

                /// Year Of Passing
                SizedBox(
                  width: mWidth/2.1,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return CustomString.passingDateRequired;
                      } else {
                        return null;
                      }
                    },
                    controller: yopController,
                    textAlign: TextAlign.center,
                    //editing controller of this TextField
                    decoration: const InputDecoration(
                      labelText: CustomString.startDate,
                      labelStyle: TextStyle(
                          color: CustomColors.kLightGrayColor, fontSize: 14),
                      suffixIcon: Icon(
                        Icons.calendar_month,
                        color: CustomColors.kBlueColor,
                      ),
                    ),
                    style: const TextStyle(color: CustomColors.kBlackColor),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      _showDatePicker(context: context);
                    },
                  ),
                ),
                SizedBox(height: mWidth * 0.03),

                /// Submit Button
                SizedBox(
                    width: double.infinity,
                    height: mHeight * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ApiConfig.editQualificationData(
                              context: context,
                              personQualificationID: widget.pqID,
                              courseName: courseController.text,
                              instituteName: instituteController.text,
                              grade: gradeController.text,
                              city: cityController.text,
                              yop: yopController.text);
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
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                          color: Colors.transparent)))),
                      child: const Text(CustomString.editQualification,
                          style: TextStyle(
                              color: CustomColors.kWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDatePicker({context}) async {
    final provider = Provider.of<YOPDateProvider>(context, listen: false);
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
                      foregroundColor: CustomColors.kBlueColor))),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      debugPrint("PickedData-------->$pickedDate"); //pickedDate output format => 2021-03-10 00:00:00.000
      String formatYopDate = DateFormat('yyyy-MM-dd').format(pickedDate); // we also use "dd-MM-yyyy" format or may more..
      debugPrint("FormattedData----->$formatYopDate"); //formatted date output using intl package =>  2021-03-16
      provider.setYopDate(formatYopDate); //set output date to TextField value.
      yopController.text = provider.yopDateInput;
    } else {}
  }
}
