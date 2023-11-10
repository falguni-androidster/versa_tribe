import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';
import 'package:versa_tribe/Utils/custom_string.dart';

import '../../Providers/person_details_provider.dart';

class EditSkillScreen extends StatefulWidget {
  final String skillName;
  final int months;
  final int perSkillId;

  const EditSkillScreen(
      {super.key,
      required this.skillName,
      required this.months,
      required this.perSkillId});

  @override
  State<EditSkillScreen> createState() => _EditSkillScreenState();
}

class _EditSkillScreenState extends State<EditSkillScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController skillController = TextEditingController();
  TextEditingController monthController = TextEditingController();

  dynamic providerSkill;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (skillController.text == "" && monthController.text == "") {
      skillController.text = widget.skillName;
      monthController.text = widget.months.toString();
      providerSkill = Provider.of<SearchSkillProvider>(context,listen: false);
      providerSkill.skillList.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerSkill =
    Provider.of<SearchSkillProvider>(context, listen: false);
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
                  color: CustomColors.kBlackColor)
              //replace with our own icon data.
              ),
          centerTitle: true,
          title: const Text(CustomString.editSkill,
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
                /// Skill name
                TextFormField(
                  readOnly: true,
                    controller: skillController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return CustomString.skillNameRequired;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      if (value != "") {
                        ApiConfig.searchSkill(
                            context: context, skillString: value);
                        providerSkill.skillList.clear();
                        providerSkill.setVisible(true);
                      }else{
                        providerSkill.setVisible(false);
                      }
                      providerSkill.skillList.clear();
                    },
                    cursorColor: CustomColors.kBlueColor,
                    decoration: const InputDecoration(
                        labelText: CustomString.skillName,
                        labelStyle: TextStyle(
                            color: CustomColors.kLightGrayColor, fontSize: 14)),
                    style: const TextStyle(color: CustomColors.kBlackColor)),
                Consumer<SearchSkillProvider>(builder: (context, val, child) {
                  return val.visible == true ?ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.skillList.length,
                      itemBuilder: (context, index) {
                        debugPrint(
                            "INSTITUTE--------->${val.skillList[index].skillName}");
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
                                    '${val.skillList[index].skillName}',
                                    style: const TextStyle(
                                        color: CustomColors
                                            .kLightGrayColor))),
                          ),
                          onTap: () async {
                            skillController.text =
                                val.skillList[index].skillName ??
                                    skillController.text;
                            val.setVisible(false);
                          },
                        );
                      }): Container();
                }),

                SizedBox(height: mHeight * 0.02),

                /// Experience(months)
                TextFormField(
                    controller: monthController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return CustomString.experienceMonthRequired;
                      } else {
                        return null;
                      }
                    },
                    cursorColor: CustomColors.kBlueColor,
                    decoration: const InputDecoration(
                        labelText: CustomString.experienceMonth,
                        labelStyle: TextStyle(
                            color: CustomColors.kLightGrayColor, fontSize: 14)),
                    style: const TextStyle(color: CustomColors.kBlackColor)),

                SizedBox(height: mHeight * 0.02),

                /// Submit Button
                SizedBox(
                    width: double.infinity,
                    height: mHeight * 0.06,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ApiConfig.editSkillData(
                                context: context,
                                personSkillId: widget.perSkillId,
                                skill: skillController.text,
                                months: monthController.text);
                          } else {
                            return;
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                CustomColors.kBlueColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                        color: Colors.transparent)))),
                        child: const Text(CustomString.editSkill,
                            style: TextStyle(
                                color: CustomColors.kWhiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
