import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class ProjectOrgIdListScreen extends StatefulWidget {
  final ProjectListByOrgIDModel projectResponseModel;
  const ProjectOrgIdListScreen({super.key, required this.projectResponseModel});
  @override
  State<ProjectOrgIdListScreen> createState() => _ProjectOrgIdListScreenState();
}
class _ProjectOrgIdListScreenState extends State<ProjectOrgIdListScreen> {

  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      apiConfig.getProjectExperience(context, widget.projectResponseModel.projectId);
      apiConfig.getProjectQualification(context, widget.projectResponseModel.projectId);
      apiConfig.getProjectSkill(context, widget.projectResponseModel.projectId);
      apiConfig.getProjectHobby(context, widget.projectResponseModel.projectId);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.projectResponseModel.projectName!,
                        style: const TextStyle(color: CustomColors.kBlueColor, fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.normal, overflow: TextOverflow.fade)),
                    SizedBox(height: size.height * 0.01),
                    widget.projectResponseModel.startDate != null &&  widget.projectResponseModel.endDate != null ? Text(
                        'Duration : ${DateUtil().formattedDate(DateTime.parse(widget.projectResponseModel.startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(widget.projectResponseModel.endDate!).toLocal())}',
                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')) :
                    const Text('Duration : 00/00/0000 - 00/00/0000', style: TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01),
                    const Text("Project Criteria",
                        style: TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01),
                    const Text(CustomString.experience,
                        style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),

                    ///Project Criteria Experience
                    FutureBuilder(
                        future: apiConfig.getProjectExperience(context, widget.projectResponseModel.projectId),
                        builder: (context,snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return SizedBox(
                              height: size.height * 0.1,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          else if(snapshot.connectionState == ConnectionState.done){
                            return Consumer<ProjectExperienceProvider>(
                                builder: (context, val, child) {
                                  return val.projectEx.isNotEmpty ?
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: val.projectEx.length,
                                    itemBuilder: (context, index) {
                                      return containerExperienceProject(val.projectEx[index],size);
                                    },
                                  ): Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                    color: CustomColors.kGrayColor,
                                    child: const Center(child: Text(CustomString.noExperienceCriteriaFound,style: TextStyle(color: CustomColors.kLightGrayColor))),
                                  );
                                },
                            );
                          }
                          else{
                            debugPrint("-----Experience print future builder else------");
                          }
                          return Container();
                        }),
                    SizedBox(height: size.height * 0.01 / 2),
                    const Text(CustomString.qualification,
                        style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),

                    ///Project Criteria Qualification
                    FutureBuilder(
                        future: apiConfig.getProjectQualification(context, widget.projectResponseModel.projectId),
                        builder: (context,snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return SizedBox(
                              height: size.height * 0.1,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          else if(snapshot.connectionState == ConnectionState.done){
                            return Consumer<ProjectQualificationProvider>(
                                builder: (context, val, child) {
                                  return val.projectQua.isNotEmpty ?
                                  containerQualificationProject(val.projectQua,size) :
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                    color: CustomColors.kGrayColor,
                                    child: const Center(child: Text(CustomString.noQualificationCriteriaFound,style: TextStyle(color: CustomColors.kLightGrayColor))),
                                  );
                                });
                          }
                          else{
                            debugPrint("-----Qualification print future builder else------");
                          }
                          return Container();
                        }),
                    SizedBox(height: size.height * 0.01 / 2),
                    const Text(CustomString.skill,
                        style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),

                    ///Project Criteria Skill
                    FutureBuilder(
                        future: apiConfig.getProjectSkill(context, widget.projectResponseModel.projectId),
                        builder: (context,snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return SizedBox(
                              height: size.height * 0.1,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          else if(snapshot.connectionState == ConnectionState.done){
                            return Consumer<ProjectSkillProvider>(
                                builder: (context, val, child) {
                                  return val.projectSkill.isNotEmpty ?
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: val.projectSkill.length,
                                    itemBuilder: (context, index) {
                                      return containerSkillProject(val.projectSkill[index],size);
                                    },
                                  ): Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                    color: CustomColors.kGrayColor,
                                    child: const Center(child: Text(CustomString.noSkillCriteriaFound,style: TextStyle(color: CustomColors.kLightGrayColor))),
                                  );
                                });
                          }
                          else{
                            debugPrint("-----Skill print future builder else------");
                          }
                          return Container();
                        }),
                    SizedBox(height: size.height * 0.01 / 2),
                    const Text(CustomString.hobby,
                        style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),

                    ///Project Criteria Hobby
                    FutureBuilder(
                        future: apiConfig.getProjectHobby(context, widget.projectResponseModel.projectId),
                        builder: (context,snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return SizedBox(
                              height: size.height * 0.1,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          else if(snapshot.connectionState == ConnectionState.done){
                            return Consumer<ProjectHobbyProvider>(
                                builder: (context, val, child) {
                                  return val.projectHobby.isNotEmpty ?
                                  containerHobbyProject(val.projectHobby,size) :
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                    color: CustomColors.kGrayColor,
                                    child: const Center(child: Text(CustomString.noHobbyCriteriaFound,style: TextStyle(color: CustomColors.kLightGrayColor))),
                                  );
                                });
                          }
                          else{
                            debugPrint("-----Hobby print future builder else------");
                          }
                          return Container();
                        }
                    ),
                  ]
              )
          ),
        ),
      ),
    );
  }

  /// Project Experience Container
  Widget containerExperienceProject(ProjectExperienceModel projectEx,size) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 2.0,color: CustomColors.kBlueColor), borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      padding: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.005),
      margin:  EdgeInsets.symmetric(vertical: size.height*0.005),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(projectEx.jobTitle!,
                  style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
              const Spacer(),
              projectEx.mandatory == true ? SvgPicture.asset(ImagePath.tickCircleIcon, width: 20, height: 20,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)) : Container(),
            ],
          ),
          projectEx.companyName != null ? Text(projectEx.companyName!,
              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')) :
          Text(projectEx.industryFieldName!,
              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
          Text('Experience : ${projectEx.expMonths!}',
              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins'))
        ],
      ),
    );
  }

  /// Project Qualification Container
  Widget containerQualificationProject(List<ProjectQualificationModel> projectQua, Size size) {
    List<Widget> containerWidgets = [];
    for (ProjectQualificationModel qualification in projectQua) {
      containerWidgets.add(
        Padding(padding: EdgeInsets.only(right: size.width * 0.02, bottom: size.height * 0.01),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(3.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(qualification.couName!,
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
                  SizedBox(width: size.width * 0.01),
                  qualification.mandatory == true ? SvgPicture.asset(ImagePath.tickCircleIcon, width: 20, height: 16,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)) : Container(),
                ],
              )),
        ),
      );
    }

    return Wrap(
      children: containerWidgets,
    );
  }

  /// Project Skill Container
  Widget containerSkillProject(ProjectSkillModel projectSkill,size) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 2.0,color: CustomColors.kBlueColor), borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      padding: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.005),
      margin:  EdgeInsets.symmetric(vertical: size.height*0.005),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(projectSkill.skillName!,
                  style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
              const Spacer(),
              projectSkill.mandatory == true ? SvgPicture.asset(ImagePath.tickCircleIcon, width: 20, height: 20,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)) : Container(),
            ],
          ),
          Text('Experience : ${projectSkill.experience}',
              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins'))
        ],
      ),
    );
  }

  /// Project Hobby Container
  Widget containerHobbyProject(List<ProjectHobbyModel> projectHobby, Size size) {
    List<Widget> containerWidgets = [];
    for (ProjectHobbyModel hobby in projectHobby) {
      containerWidgets.add(
        Padding(padding: EdgeInsets.only(right: size.width * 0.02, bottom: size.height * 0.01),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(3.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(hobby.hobbyName!,
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
                  SizedBox(width: size.width * 0.01),
                  hobby.mandatory == true ? SvgPicture.asset(ImagePath.tickCircleIcon, width: 20, height: 18,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)) : Container(),
                ],
              )),
        ),
      );
    }

    return Wrap(
      children: containerWidgets,
    );
  }
}

