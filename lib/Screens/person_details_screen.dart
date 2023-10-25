import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';
import 'package:versa_tribe/Utils/custom_string.dart';
import '../Providers/person_details_provider.dart';
import 'PersonDetails/add_experience_screen.dart';
import 'PersonDetails/add_hobby_screen.dart';
import 'PersonDetails/add_qualification_screen.dart';
import 'PersonDetails/add_skill_screen.dart';
import 'PersonDetails/edit_experience_screen.dart';
import 'PersonDetails/edit_qualification_screen.dart';
import 'PersonDetails/edit_skill_screen.dart';

class PersonDetailsScreen extends StatefulWidget {
  const PersonDetailsScreen({super.key});
  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}
class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiConfig.getUserExperience(context);
    ApiConfig.getUserQualification(context);
    ApiConfig.getUserSkills(context);
    ApiConfig.getUserHobby(context);
  }

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mWidget = MediaQuery.of(context).size.width;
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
          title: const Text(CustomString.profileDSHeaderText,
              style: TextStyle(color: CustomColors.kBlueColor))),
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: mHeight * 0.02),

            /// Experience
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(
                left: mWidget * 0.03,
                right: mWidget * 0.03,
              ),
              padding: EdgeInsets.all(mWidget * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(
                      width: mWidget * 0.04,
                    ),
                    const Text(CustomString.experience,
                        style: TextStyle(
                            color: CustomColors.kBlueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const Spacer(),
                    IconButton(
                      icon:
                          const Icon(Icons.add, color: CustomColors.kBlueColor),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddExperienceScreen()));
                      },
                    ),
                  ]),
                  Consumer<PersonExperienceProvider>(builder: (context, val, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: val.personEx.length,
                      itemBuilder: (context, index) {
                        String? comN = val.personEx[index].companyName;
                        String? indN = val.personEx[index].industryFieldName;
                        String? sDate = val.personEx[index].startDate;
                        String sd = DateFormat.yMMM().format(DateTime.parse(sDate!));
                        String? eDate = val.personEx[index].endDate;
                        String ed = DateFormat.yMMM().format(DateTime.parse(eDate!));
                        return _buildTimelineTile(comN: comN, indN: indN, ed: ed, sd: sd, vaL: val, index: index, widgetKey: "personExperience");
                      },
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: mHeight * 0.02),

            /// Qualifications
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(
                left: mWidget * 0.03,
                right: mWidget * 0.03,
              ),
              padding: EdgeInsets.all(mWidget * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: mWidget * 0.04),
                      const Text(CustomString.qualification,
                          style: TextStyle(
                              color: CustomColors.kBlueColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add,
                            color: CustomColors.kBlueColor),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddQualificationScreen()));
                        },
                      )
                    ],
                  ),
                  Consumer<PersonQualificationProvider>(builder: (context, val, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: val.personQl.length,
                      itemBuilder: (context, index) {
                        String date = val.personQl[index].yop.toString();
                        String passingY = DateFormat.yMMM().format(DateTime.parse(date));
                        return _buildTimelineTile(
                          index: index,
                          vaL: val,
                          passingYear: passingY,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: mHeight * 0.02),

            /// Skill
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(
                left: mWidget * 0.03,
                right: mWidget * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(
                      width: mWidget * 0.04,
                    ),
                    const Text(CustomString.skill,
                        style: TextStyle(
                            color: CustomColors.kBlueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: CustomColors.kBlueColor,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddSkillScreen()));
                      },
                    ),
                  ]),
                  Consumer<PersonSkillProvider>(builder: (context, val, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: val.personSkill.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                              left: mWidget * 0.04, bottom: mHeight * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: mWidget * 0.05),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${val.personSkill[index].skillName}",
                                      style: const TextStyle(
                                          color: CustomColors.kBlueColor,
                                          fontWeight: FontWeight.w500,fontSize: 14),
                                    ),
                                    SizedBox(height: mHeight * 0.005),
                                    Text(
                                        "Experience : ${val.personSkill[index].experience ?? ""}",
                                        style: const TextStyle(
                                            color: CustomColors.kLightGrayColor,fontSize: 12)),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              PopupMenuButton(
                                  icon: const Icon(Icons.more_horiz,
                                      color: CustomColors.kBlueColor),
                                  onSelected: (item) {
                                    int perSKID =
                                    val.personSkill[index].perSkId!;
                                    String skillName =
                                    val.personSkill[index].skillName!;
                                    int month =
                                    val.personSkill[index].experience!;
                                    switch (item) {
                                      case 0:
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditSkillScreen(
                                                        skillName:
                                                        skillName,
                                                        months: month,
                                                        perSkillId:
                                                        perSKID)));
                                      case 1:
                                        _showDeleteConfirmation(context,
                                            "identityPSD", perSKID, "");
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    const PopupMenuItem(
                                        value: 0,
                                        child: Text(CustomString.edit)),
                                    const PopupMenuItem(
                                        value: 1,
                                        child:
                                        Text(CustomString.delete))
                                  ]),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: mHeight * 0.02),

            /// Hobbies
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(horizontal: mWidget * 0.03),
              height: mHeight * 0.20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: mHeight * 0.01),
                  Row(children: [
                    SizedBox(width: mWidget * 0.03),
                    const Text(CustomString.hobbies,
                        style: TextStyle(
                            color: CustomColors.kBlueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add, color: CustomColors.kBlueColor),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddHobbyScreen()));
                      },
                    ),
                  ]),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: Consumer<PersonHobbyProvider>(
                          builder: (context, val, child) {
                        return GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: mWidget * 0.1,
                              childAspectRatio: 1 / 5,
                              crossAxisSpacing: 1,
                            ),
                            itemCount: val.personHobby.length,
                            itemBuilder: (context, index) {
                              return Wrap(children: [
                                InkWell(
                                    onTap: () {
                                      _showDeleteConfirmation(
                                          context,
                                          "identityPHD",
                                          val.personHobby[index].hobbyId,
                                          val.personHobby[index].personId);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: CustomColors.kBlueColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            "${val.personHobby[index].name}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18))))
                              ]);
                            });
                      }),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: mHeight * 0.01)
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, identityKey, int? iD, personId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(CustomString.deleteTitle),
          content: const Text(CustomString.deleteContent),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: const Text(CustomString.cancel),
            ),
            TextButton(
              onPressed: () {
                // Add your delete logic here
                if (identityKey == "identityPED") {
                  ApiConfig.deletePersonEx(context, iD);
                } else if (identityKey == "identityPQD") {
                  ApiConfig.deletePersonQL(context, iD);
                } else if (identityKey == "identityPSD") {
                  ApiConfig.deletePersonSkill(context, iD);
                } else if (identityKey == "identityPHD") {
                  ApiConfig.deletePersonHobby(context, personId, iD);
                }
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: const Text(CustomString.delete),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimelineTile({index, vaL, comN, indN, sd, ed, widgetKey, passingYear}) {
    var mHeight = MediaQuery.of(context).size.height;
    return TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0.05,
        isFirst: index == 0 ? true : false,
        isLast: index == index - 1 ? true : false,
        indicatorStyle: IndicatorStyle(
          indicator: _buildIndicator(),
          padding: const EdgeInsets.all(14),
          indicatorXY: 0,
        ),
        afterLineStyle: const LineStyle(
          thickness: 2,
          color: Colors.blue,
        ),
        beforeLineStyle: const LineStyle(
          thickness: 2,
          color: Colors.blue,
        ),
        endChild: widgetKey == "personExperience" ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${vaL.personEx[index].jobTitle}",
                  style:
                  const TextStyle(color: CustomColors.kBlueColor),
                ),
                PopupMenuButton(
                    icon: const Icon(
                      Icons.more_horiz,
                      color: CustomColors.kBlueColor,
                    ),
                    onSelected: (item) {
                      switch (item) {
                        case 0:
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditExperienceScreen(
                                          title: CustomString.editExperience,
                                          pExJobTitle: vaL.personEx[index].jobTitle!,
                                          company: comN,
                                          industry: vaL.personEx[index].industryFieldName,
                                          pExId: vaL.personEx[index].perExpId,
                                          sDate: vaL.personEx[index].startDate!,
                                          eDate: vaL.personEx[index].endDate!)));
                        case 1:
                          _showDeleteConfirmation(
                              context,
                              "identityPED",
                              vaL.personEx[index].perExpId,
                              "");
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 0, child: Text(CustomString.edit)),
                      const PopupMenuItem(value: 1, child: Text(CustomString.delete))
                    ]
                )
              ],
            ),
            comN != "" && comN != null ? Text("Company : ${vaL.personEx[index].companyName ?? ""}", style: const TextStyle(color: CustomColors.kBlackColor)) : Text("Industry Field: ${vaL.personEx[index].industryFieldName ?? ""}", style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12)),
            SizedBox(height: mHeight * 0.005),
            Text("$sd - $ed * ${vaL.personEx[index].expMonths} Months", style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12)),
          ],
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  vaL.personQl[index].couName,
                  style: const TextStyle(
                      color: CustomColors.kBlueColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14)
                ),
                const Spacer(),
                PopupMenuButton(
                    icon: const Icon(
                      Icons.more_horiz,
                      color: CustomColors.kBlueColor,
                    ),
                    onSelected: (item) {
                      String course = vaL.personQl[index].couName;
                      String institute = vaL.personQl[index].instName;
                      String grade = vaL.personQl[index].grade;
                      int pQID = vaL.personQl[index].pqId;
                      String yop = DateFormat("yyyy-MM-dd")
                          .format(vaL.personQl[index].yop);
                      switch (item) {
                        case 0:
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditQualificationScreen(
                                          courseName: course,
                                          grade: grade,
                                          institute: institute,
                                          yop: yop,
                                          pqID: pQID)));
                        case 1:
                          _showDeleteConfirmation(
                              context,
                              "identityPQD",
                              vaL.personQl[index].pqId,
                              "");
                      }
                    },
                    itemBuilder: (_) => [
                          const PopupMenuItem(value: 0, child: Text(CustomString.edit)),
                          const PopupMenuItem(value: 1, child: Text(CustomString.delete))
                        ]),
              ],
            ),
            Text("Institute : ${vaL.personQl[index].instName}", style: const TextStyle(color: CustomColors.kBlackColor)),
            SizedBox(height: mHeight * 0.005),
            Text("Grade : ${vaL.personQl[index].grade}", style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12)),
            SizedBox(height: mHeight * 0.005),
            Text("Year Of Passing : $passingYear", style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12)),
          ],
        ));
  }

  Widget _buildIndicator() {
    return const Center(
      child: Icon(
        Icons.radio_button_checked,
        color: Colors.blue,
        size: 20,
      ),
    );
  }
}
