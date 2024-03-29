import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({super.key});
  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController skillController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final providerSkill = Provider.of<SearchSkillProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kGrayColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
        ),
        centerTitle: true,
        title: const Text(CustomString.createSkill, style: TextStyle(color: CustomColors.kBlueColor,fontSize: 16, fontFamily: 'Poppins')),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04, vertical: size.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Skill name
                SizedBox(
                  height: size.height*0.06,
                  child: TextFormField(
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
                          apiConfig.searchSkill(
                              context: context, skillString: value);
                          providerSkill.skillList.clear();
                          providerSkill.setVisible(true);
                        }else{
                          providerSkill.setVisible(false);
                        }
                        providerSkill.skillList.clear();
                      },
                      decoration: const InputDecoration(
                          labelText: CustomString.skillName,
                          labelStyle: TextStyle(
                              color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                ),

                Consumer<SearchSkillProvider>(builder: (context, val, child) {
                  return val.visible == true
                      ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.skillList.length,
                      itemBuilder: (context, index) {
                        debugPrint("skill search--------->${val.skillList[index].skillName}");
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
                                          '${val.skillList[index].skillName}',
                                          style: const TextStyle(
                                              color: CustomColors
                                                  .kLightGrayColor, fontFamily: 'Poppins'))),
                                ),
                                onTap: () async {
                                  skillController.text =
                                      val.skillList[index].skillName ??
                                          skillController.text;
                                  val.setVisible(false);
                                },
                              );
                      })
                  : Container();
                }),

                SizedBox(height: size.height * 0.02),

                /// Experience(months)
                SizedBox(
                  height: size.height*0.06,
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: monthController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return CustomString.experienceMonthRequired;
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: CustomString.experienceMonth,
                          labelStyle: TextStyle(
                              color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins')),
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                ),

                SizedBox(height: size.height * 0.02),

                /// Submit Button
                SizedBox(
                    width: double.infinity,
                    height: size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          apiConfig.addSkillData(
                              context: context,
                              skill: skillController.text,
                              month: monthController.text);
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
                      child: const Text(CustomString.createSkill,
                          style: TextStyle(
                              color: CustomColors.kWhiteColor,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
