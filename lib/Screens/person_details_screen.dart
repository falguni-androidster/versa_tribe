import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import 'package:versa_tribe/Utils/custom_colors.dart';
import 'package:versa_tribe/Utils/custom_string.dart';
import '../Model/profile_response.dart';
import '../Providers/person_details_provider.dart';
import '../Utils/container_list.dart';
import '../Utils/image_path.dart';
import 'PersonDetails/add_experience_screen.dart';
import 'PersonDetails/add_hobby_screen.dart';
import 'PersonDetails/add_qualification_screen.dart';
import 'PersonDetails/add_skill_screen.dart';
import 'PersonDetails/edit_experience_screen.dart';
import 'PersonDetails/edit_qualification_screen.dart';
import 'PersonDetails/edit_skill_screen.dart';
import 'Profile/update_profile_screen.dart';

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

    var size = MediaQuery.of(context).size;

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
              style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins'))),

      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: size.height * 0.01),

            FutureBuilder<ProfileResponse>(
              future: ApiConfig().getProfileData(),
              builder: (context, snapshot) {
                return containerProfile(snapshot, size.width);
              },
            ),

            SizedBox(height: size.height * 0.02),

            /// Experience
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(
                left: size.width * 0.03,
                right: size.width * 0.03,
              ),
              padding: EdgeInsets.only(bottom: size.height * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [

                    SizedBox(width: size.width * 0.03,),

                    const Text(CustomString.experience,
                        style: TextStyle(
                            color: CustomColors.kBlueColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 16, fontFamily: 'Poppins')),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add, color: CustomColors.kBlueColor),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AddExperienceScreen()));
                      },
                    ),
                  ]),
                  Consumer<PersonExperienceProvider>(
                      builder: (context, val, child) {
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
                        return _buildTimelineTile(
                            comN: comN,
                            ed: ed,
                            sd: sd,
                            vaL: val,
                            index: index,
                            widgetKey: "personExperience");
                      },
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.02),

            /// Qualifications
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(
                left: size.width * 0.03,
                right: size.width * 0.03,
              ),
              padding: EdgeInsets.only(bottom: size.height * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: size.width * 0.03),
                      const Text(CustomString.qualification,
                          style: TextStyle(
                              color: CustomColors.kBlueColor,
                              fontSize: 16, fontFamily: 'Poppins')),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add,
                            color: CustomColors.kBlueColor),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddQualificationScreen()));
                        },
                      )
                    ],
                  ),
                  Consumer<PersonQualificationProvider>(
                      builder: (context, val, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: val.personQl.length,
                      itemBuilder: (context, index) {
                        String date = val.personQl[index].yop.toString();
                        String passingY =
                            DateFormat.yMMM().format(DateTime.parse(date));
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

            SizedBox(height: size.height * 0.02),

            /// Skill
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(
                left: size.width * 0.03,
                right: size.width * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(width: size.width * 0.03,),
                    const Text(CustomString.skill,style: TextStyle(color: CustomColors.kBlueColor, fontSize: 16, fontFamily: 'Poppins')),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: CustomColors.kBlueColor,
                      ),
                      onPressed: () {
                        Navigator.push(
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
                              left: size.width * 0.03, bottom: size.height * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${val.personSkill[index].skillName}",
                                    style: const TextStyle(color: CustomColors.kBlueColor, fontSize: 14, fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  Text(
                                      "Experience: ${val.personSkill[index].experience ?? ""} months",
                                      style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                ],
                              ),
                              const Spacer(),
                              PopupMenuButton(
                                  child: CircleAvatar(
                                    radius:10,backgroundColor: Colors.transparent,
                                      child: SvgPicture.asset(ImagePath.moreIcon,width: 5,height: 4,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn),)),
                                  onSelected: (item) {
                                    int perSKID =
                                        val.personSkill[index].perSkId!;
                                    String skillName =
                                        val.personSkill[index].skillName!;
                                    int month =
                                        val.personSkill[index].experience!;
                                    switch (item) {
                                      case 0:
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditSkillScreen(
                                                        skillName: skillName,
                                                        months: month,
                                                        perSkillId: perSKID)));
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
                                            child: Text(CustomString.delete))
                                      ]),
                              SizedBox(width: size.width * 0.04)
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.02),

            // /// Hobbies
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(color: CustomColors.kBlueColor, width: 2),
            //       borderRadius: BorderRadius.circular(10)),
            //   margin: EdgeInsets.symmetric(horizontal: mWidget * 0.03),
            //   height: mHeight * 0.20,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       SizedBox(height: mHeight * 0.01),
            //       Row(children: [
            //         SizedBox(width: mWidget * 0.03),
            //         const Text(CustomString.hobbies,
            //             style: TextStyle(
            //                 color: CustomColors.kBlueColor,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 16)),
            //         const Spacer(),
            //         IconButton(
            //           icon:
            //               const Icon(Icons.add, color: CustomColors.kBlueColor),
            //           onPressed: () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => const AddHobbyScreen()));
            //           },
            //         ),
            //       ]),
            //       Expanded(
            //         child: Container(
            //           padding: const EdgeInsets.all(6),
            //           child: Consumer<PersonHobbyProvider>(
            //               builder: (context, val, child) {
            //             return GridView.builder(
            //                 scrollDirection: Axis.horizontal,
            //                 gridDelegate:
            //                     SliverGridDelegateWithMaxCrossAxisExtent(
            //                   maxCrossAxisExtent: mWidget * 0.1,
            //                   childAspectRatio: 1 / 5,
            //                   crossAxisSpacing: 1,
            //                 ),
            //                 itemCount: val.personHobby.length,
            //                 itemBuilder: (context, index) {
            //                   return Wrap(children: [
            //                     InkWell(
            //                         onTap: () {
            //                           _showDeleteConfirmation(
            //                               context,
            //                               "identityPHD",
            //                               val.personHobby[index].hobbyId,
            //                               val.personHobby[index].personId);
            //                         },
            //                         child: Container(
            //                             decoration: BoxDecoration(
            //                                 border: Border.all(
            //                                     color: CustomColors.kBlueColor,
            //                                     width: 2),
            //                                 borderRadius:
            //                                     BorderRadius.circular(10)),
            //                             padding: const EdgeInsets.all(5.0),
            //                             child: Text(
            //                                 "${val.personHobby[index].name}",
            //                                 style: const TextStyle(
            //                                     color: Colors.black,
            //                                     fontSize: 18))))
            //                   ]);
            //                 });
            //           }),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: mHeight * 0.01),


            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: Padding(
                padding: EdgeInsets.only(left: size.width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.01),
                    Row(children: [
                      const Text(CustomString.hobbies,
                          style: TextStyle(color: CustomColors.kBlueColor, fontSize: 16, fontFamily: 'Poppins')),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add, color: CustomColors.kBlueColor),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddHobbyScreen()));
                        },
                      ),
                    ]),

                    Consumer<PersonHobbyProvider>(
                        builder: (context, val, child) {
                          List<String> hobbyNameList=[];
                          List<int> hobbyIdList=[];
                          List<int> personIdList=[];
                           for (var element in val.personHobby) {
                             hobbyNameList.add(element.name!);
                             hobbyIdList.add(element.hobbyId!);
                             personIdList.add(element.personId!);
                           }
                          return TextContainerList(textData: hobbyNameList, personId:personIdList,hobbyId:hobbyIdList);
                        }
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );

  }

  void _showDeleteConfirmation(
      BuildContext context, identityKey, int? iD, personId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(CustomString.deleteTitle, style: TextStyle(),),
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
              child: const Text(CustomString.delete, style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimelineTile(
      {index, vaL, comN, sd, ed, widgetKey, passingYear}) {
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    return TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0.05,
        isFirst: index == 0 ? true : false,
        isLast: index == index - 1 ? true : false,
        indicatorStyle: IndicatorStyle(
          indicator: _buildIndicator(),
          indicatorXY: 0,
        ),
        afterLineStyle: const LineStyle(
          thickness: 2,
          color: CustomColors.kBlueColor,
        ),
        beforeLineStyle: const LineStyle(
          thickness: 2,
          color: CustomColors.kBlueColor,
        ),
        endChild: widgetKey == "personExperience"
            ? Padding(
              padding: EdgeInsets.only(left: mWidth*0.02,),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("${vaL.personEx[index].jobTitle}", style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
                        const Spacer(),
                        PopupMenuButton(
                            // icon: const Icon(
                            //   Icons.more_horiz,
                            //   color: CustomColors.kBlueColor,
                            // ),
                            child: CircleAvatar(
                                radius:10,backgroundColor: Colors.transparent,
                                child: SvgPicture.asset(ImagePath.moreIcon,width: 15,height: 4,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn),)),
                            onSelected: (item) {
                              switch (item) {
                                case 0:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditExperienceScreen(
                                                  title:
                                                      CustomString.editExperience,
                                                  pExJobTitle: vaL
                                                      .personEx[index].jobTitle!,
                                                  company: comN ?? "",
                                                  industry: vaL.personEx[index]
                                                          .industryFieldName ??
                                                      "",
                                                  pExId: vaL
                                                      .personEx[index].perExpId,
                                                  sDate: vaL
                                                      .personEx[index].startDate!,
                                                  eDate: vaL.personEx[index]
                                                      .endDate!)));
                                case 1:
                                  _showDeleteConfirmation(context, "identityPED",
                                      vaL.personEx[index].perExpId, "");
                              }
                            },
                            itemBuilder: (_) => [
                                  const PopupMenuItem(
                                      value: 0, child: Text(CustomString.edit, style: TextStyle(fontFamily: 'Poppins'))),
                                  const PopupMenuItem(
                                      value: 1, child: Text(CustomString.delete, style:  TextStyle(fontFamily: 'Poppins')))
                                ]),
                        SizedBox(width: mWidth*0.04,)
                      ],
                    ),
                    SizedBox(height: mHeight * 0.006),
                    comN != "" && comN != null ? Text(
                            "Company : ${vaL.personEx[index].companyName ?? ""}",
                            style: const TextStyle(color: CustomColors.kBlackColor)) : Text("Industry Field: ${vaL.personEx[index].industryFieldName ?? ""}", style: const TextStyle(
                                color: CustomColors.kBlackColor, fontFamily: 'Poppins'/*fontSize: 12*/)),
                    SizedBox(height: mHeight * 0.005),
                    Text("$sd - $ed * ${vaL.personEx[index].expMonths} Months", style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                  ],
                ),
            )
            : Padding(
              padding: EdgeInsets.only(left: mWidth*0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(vaL.personQl[index].couName,
                            style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
                        const Spacer(),
                        PopupMenuButton(
                            child: CircleAvatar(
                                radius:10,backgroundColor: Colors.transparent,
                                child: SvgPicture.asset(ImagePath.moreIcon,width: 5,height: 4,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn))),
                            onSelected: (item) {
                              String course = vaL.personQl[index].couName;
                              String institute = vaL.personQl[index].instName;
                              String grade = vaL.personQl[index].grade;
                              String city = vaL.personQl[index].ctyName;
                              int pQID = vaL.personQl[index].pqId;
                              String yop = DateFormat("yyyy-MM-dd")
                                  .format(vaL.personQl[index].yop);
                              switch (item) {
                                case 0:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditQualificationScreen(
                                                  courseName: course,
                                                  grade: grade,
                                                  city: city,
                                                  institute: institute,
                                                  yop: yop,
                                                  pqID: pQID)));
                                case 1:
                                  _showDeleteConfirmation(context, "identityPQD",
                                      vaL.personQl[index].pqId, "");
                              }
                            },
                            itemBuilder: (_) => [
                                  const PopupMenuItem(
                                      value: 0, child: Text(CustomString.edit, style: TextStyle(fontFamily: 'Poppins'))),
                                  const PopupMenuItem(
                                      value: 1, child: Text(CustomString.delete, style: TextStyle(fontFamily: 'Poppins')))
                                ]),
                        SizedBox(width: mWidth * 0.04)
                      ],
                    ),
                    SizedBox(height: mHeight * 0.006),
                    Text("Institute: ${vaL.personQl[index].instName}",
                        style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins')),
                    SizedBox(height: mHeight * 0.005),
                    Text("Course Type: ${vaL.personQl[index].couName}",
                        style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins')),
                    SizedBox(height: mHeight * 0.005),
                    Text("Grade: ${vaL.personQl[index].grade}",
                        style: const TextStyle(
                            color: CustomColors.kBlackColor,fontFamily: 'Poppins')),
                    SizedBox(height: mHeight * 0.005),
                  /*  Text("City : ${vaL.personQl[index].ctypName}",
                        style: const TextStyle(
                            color: CustomColors.kBlackColor, fontSize: 12)),
                    SizedBox(height: mHeight * 0.005),*/
                    Text("Year Of Passing: $passingYear",
                        style: const TextStyle(
                            color: CustomColors.kLightGrayColor,fontSize: 12, fontFamily: 'Poppins')),
                  ],
                ),
            ));
  }

  Widget _buildIndicator() {
    return const Center(
      child: Icon(
        Icons.radio_button_checked,
        color: CustomColors.kBlueColor,
        size: 20,
      ),
    );
  }

  Widget containerProfile(snapshot, mWidget) {
    return Card(
      elevation: 5,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
      ),
      margin: EdgeInsets.only(
        left: mWidget * 0.03,
        right: mWidget * 0.03,
      ),
      child: Container(
        decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CustomColors.kBlueColor, width: 2),
        ),),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  backgroundColor: CustomColors.kWhiteColor,
                  radius: 40,
                  child: Image.asset(ImagePath.profilePath)),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${snapshot.data?.firstName ?? ''} ${snapshot.data?.lastName ?? ''}',
                        style: const TextStyle(
                            color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                    const SizedBox(height: 2),
                    Text(snapshot.data?.tOwner ?? '',
                        style: const TextStyle(
                            color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins'))
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                child: SvgPicture.asset(ImagePath.editProfileIcon,height: 15,width: 15,colorFilter: const ColorFilter.mode(CustomColors.kBlackColor,BlendMode.srcIn)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateProfileScreen(firstName: snapshot.data?.firstName ?? '',lastName: snapshot.data?.lastName ?? '',gender: snapshot.data?.gender ?? '',dob: snapshot.data?.dOB ?? '',city: snapshot.data?.city ?? '',country: snapshot.data?.country ?? '')));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
