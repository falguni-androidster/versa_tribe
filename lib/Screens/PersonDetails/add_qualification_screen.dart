import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class AddQualificationScreen extends StatefulWidget {
  const AddQualificationScreen({super.key});

  @override
  State<AddQualificationScreen> createState() => _AddQualificationScreenState();
}

class _AddQualificationScreenState extends State<AddQualificationScreen> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController courseController = TextEditingController();
  TextEditingController instituteController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController yopController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<SearchCourseProvider>(context, listen: false);
    final providerInstitute = Provider.of<SearchInstituteProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kGrayColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor), //replace with our own icon data.
        ),
        centerTitle: true,
        title: const Text(CustomString.createQualification, style: TextStyle(color: CustomColors.kBlueColor,fontSize: 16,fontFamily: 'Poppins')),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Course name
                SizedBox(
                  height: size.height*0.06,
                  child: TextFormField(
                      controller: courseController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return CustomString.courseNameRequired;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if (value != "" && value.isNotEmpty) {
                          apiConfig.searchCourse(
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
                              color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                ),

                Consumer<SearchCourseProvider>(builder: (context, val, child) {
                  return val.visible == true
                      ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.courseList.length,
                      itemBuilder: (context, index) {
                        debugPrint("company name--------->${val.courseList[index].couName}");
                        return  InkWell(
                                child: Card(
                                  shadowColor: CustomColors.kBlueColor,
                                  elevation: 3,
                                  color: CustomColors.kGrayColor,
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: size.width * 0.02),
                                      height: size.height * 0.05,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          '${val.courseList[index].couName}',
                                          style: const TextStyle(
                                              color: CustomColors.kLightGrayColor,fontFamily: 'Poppins'))),
                                ),
                                onTap: () async {
                                  courseController.text =
                                      val.courseList[index].couName ??
                                          courseController.text;
                                  val.setVisible(false);
                                });
                      })
                  : Container();
                }),

                SizedBox(height: size.height * 0.02),

                /// Institute name
                SizedBox(
                  height: size.height*0.06,
                  child: TextFormField(
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
                          apiConfig.searchInstitute(
                              context: context, instituteString: value);
                          providerInstitute.instituteList.clear();
                        }else{
                          providerInstitute.setVisible(false);
                        }
                        providerInstitute.instituteList.clear();
                        providerInstitute.setVisible(true);
                      },
                      decoration: const InputDecoration(
                          labelText: CustomString.instituteName,
                          labelStyle: TextStyle(
                              color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                ),

                Consumer<SearchInstituteProvider>(
                    builder: (context, val, child) {
                  return val.visible == true
                      ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.instituteList.length,
                      itemBuilder: (context, index) {
                        debugPrint("institute name--------->${val.instituteList[index].instName}");
                        return InkWell(
                                child: Card(
                                  shadowColor: CustomColors.kBlueColor,
                                  elevation: 3,
                                  color: CustomColors.kGrayColor,
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: size.width * 0.02),
                                      height: size.height * 0.05,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          '${val.instituteList[index].instName}',
                                          style: const TextStyle(
                                              color: CustomColors.kLightGrayColor,fontFamily: 'Poppins'))),
                                ),
                                onTap: () async {
                                  instituteController.text =
                                      val.instituteList[index].instName ??
                                          instituteController.text;
                                  val.setVisible(false);
                                },
                              );
                      }):Container();
                }),

                SizedBox(height: size.height * 0.02),

                /// Grade
                SizedBox(
                  height: size.height*0.06,
                  child: TextFormField(
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
                              color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                ),

                SizedBox(height: size.height * 0.02),

                /// City name
                SizedBox(
                  height: size.height*0.06,
                  child: TextFormField(
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
                              color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                ),

                SizedBox(height: size.height * 0.02),

                /// Year Of Passing
                SizedBox(
                  height: size.height*0.06,
                  width: size.width/2.1,
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
                    decoration: const InputDecoration(
                      labelText: CustomString.passingDate,
                      labelStyle: TextStyle(
                          color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins'),
                      suffixIcon: Icon(Icons.calendar_month, color: CustomColors.kBlueColor),
                    ),
                    style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins'),
                    readOnly: true,
                    onTap: () async {
                      _showDatePicker(context: context);
                    },
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                /// Button
                SizedBox(
                    width: double.infinity,
                    height: size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          apiConfig.addQualificationData(
                              context: context,
                              courseName: courseController.text,
                              instituteName: instituteController.text,
                              city: cityController.text,
                              grade: gradeController.text,
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
                      child: const Text(CustomString.createQualification,
                          style: TextStyle(
                            color: CustomColors.kWhiteColor,
                            fontSize: 16,
                            fontFamily: 'Poppins',
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
      provider.setYopDate(formatYopDate); //set output date to TextField value.
      yopController.text = provider.yopDateInput;
    } else {}
  }
}
