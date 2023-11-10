import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Providers/profile_gender_provider.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';
import 'package:versa_tribe/Utils/custom_string.dart';
import '../../Providers/date_provider.dart';
import '../../Providers/person_details_provider.dart';

class EditExperienceScreen extends StatefulWidget {
  final String? title;
  final String? pExJobTitle;
  final String? industry;
  final String? company;
  final int? pExId;
  final String? sDate;
  final String? eDate;

  const EditExperienceScreen(
      {this.title,
      this.pExJobTitle,
      this.company,
      this.industry,
      this.pExId,
      this.sDate,
      this.eDate,
      super.key});

  @override
  State<EditExperienceScreen> createState() => _EditExperienceScreenState();
}

class _EditExperienceScreenState extends State<EditExperienceScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController companyNController = TextEditingController();
  TextEditingController industryNController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  dynamic cmpProvider;
  dynamic indProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cmpProvider = Provider.of<SearchExCompanyProvider>(context, listen: false);
    indProvider = Provider.of<SearchExIndustryProvider>(context, listen: false);
    final oldRadioProvider = Provider.of<RadioComIndProvider>(context, listen: false);

    widget.company!=""?oldRadioProvider.setRadioValue("Company"):oldRadioProvider.setRadioValue("Industry");

    cmpProvider.cmpList.clear();
    indProvider.indList.clear();

    String sDATE = DateFormat('yyyy-MM-dd').format(DateTime.parse("${widget.sDate}"));
    String eDATE = DateFormat('yyyy-MM-dd').format(DateTime.parse("${widget.eDate}"));
    startDateController.text = sDATE;
    endDateController.text = eDATE;
    jobTitleController.text = "${widget.pExJobTitle}";
    companyNController.text = "${widget.company}";
    industryNController.text = "${widget.industry}";
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Company----->${widget.company}");
    debugPrint("Industry----->${widget.industry}");
    final providerCompany = Provider.of<SearchExCompanyProvider>(context, listen: false);
    final providerIndustry = Provider.of<SearchExIndustryProvider>(context, listen: false);
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: CustomColors.kWhiteColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios,
                color: CustomColors.kBlackColor),
            //replace with our own icon data.
          ),
          centerTitle: true,
          title: const Text(CustomString.editExperience,
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
                SizedBox(
                  height: mHeight * 0.01,
                ),
                Consumer<PersonExperienceProvider>(
                    builder: (context, val, child) {
                  return TextFormField(
                      controller: jobTitleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return CustomString.jobTitleRequired;
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: CustomString.jobTitle,
                          labelStyle: TextStyle(
                              color: CustomColors.kLightGrayColor,
                              fontSize: 14)),
                      style: const TextStyle(color: CustomColors.kBlackColor));
                }),
                SizedBox(height: mHeight * 0.02),

                ///RadioButton
                const Text(CustomString.selectYourCompanyAndIndustry,
                    style: TextStyle(color: CustomColors.kLightGrayColor)),
                Row(
                  children: [
                    radioBTN(CustomString.company),
                    Consumer<RadioComIndProvider>(builder: (context, val, child) {
                        return Text(CustomString.company,
                            style: TextStyle(
                                color: val.selectedValue=="Company"
                                    ? CustomColors.kBlueColor
                                    : CustomColors.kLightGrayColor));
                      }
                    ),
                    radioBTN(CustomString.industry),
                    Consumer<RadioComIndProvider>(builder: (context, val, child) {
                        return Text(CustomString.industry,
                            style: TextStyle(
                                color: val.selectedValue=="Industry"
                                    ? CustomColors.kBlueColor
                                    : CustomColors.kLightGrayColor));
                      }
                    )
                  ],
                ),

                ///Company & Industry Name
                Consumer<RadioComIndProvider>(
                    builder: (context, val, child) {
                      print("radio btn value--------->${val.selectedValue}");
                      return TextFormField(
                          controller: val.selectedValue!=""?val.selectedValue=="Company"?companyNController:industryNController:widget.industry!=""
                              ? industryNController
                              : widget.company!=""
                                  ? companyNController
                                  : val.selectedValue == "Company"
                                      ? companyNController
                                      : industryNController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return val.selectedValue == "Company"
                                  ? CustomString.companyNameRequired
                                  : CustomString.enterIndustryName;
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            if (value != "" && value.isNotEmpty) {
                              print("Selected--======---=-=-->${val.selectedValue}");
                              val.selectedValue == "Company" ? ApiConfig.searchExCompany(context: context, companyString: value) : ApiConfig.searchExIndustry(context: context, industryString: value);
                              providerCompany.cmpList.clear();
                              providerIndustry.indList.clear();
                              val.selectedValue=="Company"?industryNController.clear():companyNController.clear();
                              val.selectedValue=="Company"?providerCompany.setVisible(true):providerIndustry.setVisible(true);
                            }else{
                              val.selectedValue=="Company"?providerCompany.setVisible(false):providerIndustry.setVisible(false);
                            }
                            providerCompany.cmpList.clear();
                            providerIndustry.indList.clear();
                          },
                          decoration: InputDecoration(
                              labelText: val.selectedValue == "Company"
                                  ? CustomString.companyName
                                  : CustomString.industryName,
                              labelStyle: const TextStyle(
                                  color: CustomColors.kLightGrayColor,
                                  fontSize: 14)),
                          style:
                              const TextStyle(color: CustomColors.kBlackColor));
                    }
                    ),

                ///for display search values
                Consumer<SearchExCompanyProvider>(
                    builder: (context, val, child) {
                  return val.visible == true
                      ?ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.cmpList.length,
                      itemBuilder: (context, index) {
                        debugPrint("Company--------->${val.cmpList[index].companyName}");
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
                                          '${val.cmpList[index].companyName}',
                                          style: const TextStyle(
                                              color: CustomColors
                                                  .kLightGrayColor))),
                                ),
                                onTap: () async {
                                  companyNController.text =
                                      val.cmpList[index].companyName ??
                                          companyNController.text;
                                  val.setVisible(false);
                                },
                              );
                      }): Container();
                }),
                Consumer<SearchExIndustryProvider>(
                    builder: (context, val, child) {
                  return val.visible == true
                      ?ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.indList.length,
                      itemBuilder: (context, index) {
                        debugPrint(
                            "INSTITUTE--------->${val.indList[index].industryFieldName}");
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
                                          '${val.indList[index].industryFieldName}',
                                          style: const TextStyle(
                                              color: CustomColors
                                                  .kLightGrayColor))),
                                ),
                                onTap: () async {
                                  industryNController.text =
                                      val.indList[index].industryFieldName ??
                                          industryNController.text;
                                  val.setVisible(false);
                                },
                              );
                      }): Container();
                }),

                /// Start DateTime & End DateTime
                Container(
                  padding: EdgeInsets.only(top: mHeight*0.02),
                  margin: EdgeInsets.symmetric(horizontal: mWidth * 0.01 / 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Start dateTime
                      SizedBox(
                        width: 150,
                        child: Consumer<DateProvider>(
                            builder: (context, val, child) {
                          return TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return CustomString.selectStartDate;
                              } else {
                                return null;
                              }
                            },
                            controller: startDateController,
                            textAlign: TextAlign.center,

                            //editing controller of this TextField
                            decoration: const InputDecoration(
                              labelText: CustomString.startDate,
                              labelStyle: TextStyle(
                                  color: CustomColors.kLightGrayColor,
                                  fontSize: 14),
                              suffixIcon: Icon(Icons.calendar_month,
                                  color: CustomColors.kBlueColor),
                            ),
                            style: const TextStyle(
                                color: CustomColors.kBlackColor),
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              _showDatePicker(
                                  context: context, key: "startDate");
                            },
                          );
                        }),
                      ),

                      ///End dateTime
                      SizedBox(
                        width: 150,
                        child: Consumer<DateProvider>(
                            builder: (context, val, child) {
                          return TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return CustomString.selectEndDate;
                              } else {
                                return null;
                              }
                            },
                            controller: endDateController,
                            textAlign: TextAlign.center,
                            //editing controller of this TextField
                            decoration: const InputDecoration(
                              labelText: CustomString.endDate,
                              labelStyle: TextStyle(
                                  color: CustomColors.kLightGrayColor,
                                  fontSize: 14),
                              suffixIcon: Icon(Icons.calendar_month,
                                  color: CustomColors.kBlueColor),
                            ),
                            style: const TextStyle(
                                color: CustomColors.kBlackColor),
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: startDateController.text == ""
                                ? () {}
                                : () async {
                                    _showDatePicker(
                                        context: context,
                                        key: "endDate",
                                        startDate: val.pickedDate);
                                  },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: mHeight * 0.03),

                /// Submit Button
                SizedBox(
                    width: double.infinity,
                    height: mHeight * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ApiConfig.updateExData(
                              context: context,
                              peronExperienceId: widget.pExId,
                              jobTitle: jobTitleController.text,
                              comName: companyNController.text,
                              indName: industryNController.text,
                              sDate: startDateController.text,
                              eDate: endDateController.text);
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
                      child: const Text(CustomString.editExperience,
                          style: TextStyle(
                              fontSize: 16,
                              color: CustomColors.kWhiteColor,
                              backgroundColor: CustomColors.kBlueColor,
                              fontWeight: FontWeight.w600)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget radioBTN(String comInd) {
    return Consumer<RadioComIndProvider>(builder: (context, val, child) {
      return Radio<String>(
        fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return CustomColors.kBlueColor;
          }
          return CustomColors.kLightGrayColor;
        }),
        value: comInd,
        groupValue: val.selectedValue ==""? widget.company != ""
            ? "Company"
            :  widget.company != ""
                ? "Industry"
                : val.selectedValue:val.selectedValue,
        // groupValue: widget.company != null && widget.company != ""
        //     ? "Company"
        //     : widget.industry != null && widget.company != ""
        //         ? "Industry"
        //         : val.selectedValue,
        onChanged: (value) {
          print("Updated Radio value--->>$value");
          val.setRadioValue(value);
          val.callNotify();
        },
      );
    });
  }

  Future<DateTime?> _showDatePicker({context, required key, startDate}) async {
    final provider = Provider.of<DateProvider>(context, listen: false);
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: key == "startDate" ? DateTime.now() : startDate,
      firstDate: key == "startDate" ? DateTime(1970) : startDate,
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
                  foregroundColor: CustomColors.kBlueColor // button text color
                  ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (key == "startDate") {
      if (pickedDate != null) {
        debugPrint(
            "Start-PickedData-------->$pickedDate"); //pickedDate output format => 2021-03-10 00:00:00.000
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        //String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        debugPrint(
            "Start-FormattedData----->$formattedDate"); //formatted date output using intl package =>  2021-03-16
        provider.setStartDate(
            formattedDate, pickedDate); //set output date to TextField value.
        endDateController.text =
            ""; // set empty end date TextField when start date select.
        startDateController.text = provider.startDateInput;
      } else {}
    } else {
      if (pickedDate != null) {
        debugPrint(
            "End-PickedData-------->$pickedDate"); //pickedDate output format => 2021-03-10 00:00:00.000
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        //String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        debugPrint(
            "End-FormattedData----->$formattedDate"); //formatted date output using intl package =>  2021-03-16
        provider
            .setEndDate(formattedDate); //set output date to TextField value.
        endDateController.text = provider.endDateInput;
      } else {}
    }
    return pickedDate;
  }
}
