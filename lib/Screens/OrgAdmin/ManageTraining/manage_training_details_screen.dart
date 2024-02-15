import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class ManageTrainingDetailScreen extends StatefulWidget {
  final TakeTrainingDataModel trainingResponse;
  const ManageTrainingDetailScreen({super.key, required this.trainingResponse});
  @override
  State<ManageTrainingDetailScreen> createState() => _ManageTrainingDetailScreenState();
}

class _ManageTrainingDetailScreenState extends State<ManageTrainingDetailScreen> {
  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      apiConfig.getTrainingExperience(context, widget.trainingResponse.trainingId);
      apiConfig.getTrainingQualification(context, widget.trainingResponse.trainingId);
      apiConfig.getTrainingSkill(context, widget.trainingResponse.trainingId);
      apiConfig.getTrainingHobby(context, widget.trainingResponse.trainingId);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
                    Text(widget.trainingResponse.trainingName!,
                        style: const TextStyle(color: CustomColors.kBlueColor, fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.normal, overflow: TextOverflow.fade)),
                    //SizedBox(height: size.height * 0.01),
                    // Text('Organization : ${widget.trainingResponse.orgName!}',
                    //     style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01),
                    Text('Duration : ${DateUtil().formattedDate(DateTime.parse(widget.trainingResponse.startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(widget.trainingResponse.endDate!).toLocal())}',
                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                    Text('Person Limit : ${widget.trainingResponse.personLimit!}',
                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01),
                    const Text('Description',
                        style: TextStyle(color: CustomColors.kBlackColor, fontSize: 16, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),
                    Text(widget.trainingResponse.description!,textAlign: TextAlign.justify,
                        style: const TextStyle(color: CustomColors.kLightGrayColor,fontSize: 14, fontFamily: 'Poppins', overflow: TextOverflow.fade)),
                    SizedBox(height: size.height * 0.01),
                    const Text("Training Criteria",
                        style: TextStyle(color: CustomColors.kBlackColor, fontSize: 16, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01),

                    ///Experience Criteria
                    const Text(CustomString.experience,
                        style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),
                    FutureBuilder(
                        future: apiConfig.getTrainingExperience(context, widget.trainingResponse.trainingId),
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
                            return Consumer<TrainingExperienceProvider>(
                                builder: (context, val, child) {
                                  return val.trainingEx.isNotEmpty ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: val.trainingEx.length,
                                    itemBuilder: (context, index) {
                                      return containerExperienceTraining(val.trainingEx[index]);
                                    },
                                  ) : Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8.0),
                                    color: CustomColors.kGrayColor,
                                    child: const Center(child: Text(CustomString.noExperienceCriteriaFound,style: TextStyle(color: CustomColors.kLightGrayColor))),
                                  );
                                });
                          }
                          else{
                            debugPrint("-----Experience print future builder else------");
                          }
                          return Container();
                        }),
                    SizedBox(height: size.height * 0.01 / 2),

                    ///Qualification Criteria
                    const Text(CustomString.qualification,
                        style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),
                    FutureBuilder(
                        future: ApiConfig().getTrainingQualification(context, widget.trainingResponse.trainingId),
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
                            return Consumer<TrainingQualificationProvider>(
                                builder: (context, val, child) {
                                  return val.trainingQua.isNotEmpty ?
                                  containerQualificationTraining(val.trainingQua,size) :
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8.0),
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

                    ///Skill Criteria
                    const Text(CustomString.skill,
                        style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),
                    FutureBuilder(
                        future: apiConfig.getTrainingSkill(context, widget.trainingResponse.trainingId),
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
                            return Consumer<TrainingSkillProvider>(
                                builder: (context, val, child) {
                                  return val.trainingSkill.isNotEmpty ?
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: val.trainingSkill.length,
                                    itemBuilder: (context, index) {
                                      return containerSkillTraining(val.trainingSkill[index]);
                                    },
                                  ): Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8.0),
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

                    ///Hobby Criteria
                    const Text(CustomString.hobby,
                        style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),
                    FutureBuilder(
                        future: apiConfig.getTrainingHobby(context, widget.trainingResponse.trainingId),
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
                            return Consumer<TrainingHobbyProvider>(
                                builder: (context, val, child) {
                                  return val.trainingHobby.isNotEmpty ? containerHobbyTraining(val.trainingHobby,size) : Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8.0),
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

  /// Training Experience Container
  Widget containerExperienceTraining(TrainingExperienceModel trainingEx) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 2.0,color: CustomColors.kBlueColor), borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      padding: const EdgeInsets.all(6.0),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(trainingEx.jobTitle!,
                  style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
              const Spacer(),
              trainingEx.mandatory == true ? SvgPicture.asset(ImagePath.tickCircleIcon, width: 20, height: 20,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)) : Container(),
            ],
          ),
          Text(trainingEx.companyName??trainingEx.industryFieldName!,
              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
          Text('Experience : ${trainingEx.expMonths!}',
              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins'))
        ],
      ),
    );
  }

  /// Training Skill Container
  Widget containerSkillTraining(TrainingSkillModel trainingSkill) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 2.0,color: CustomColors.kBlueColor), borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      padding: const EdgeInsets.all(6.0),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(trainingSkill.skillName!,
                  style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
              const Spacer(),
              trainingSkill.mandatory == true ? SvgPicture.asset(ImagePath.tickCircleIcon, width: 20, height: 20,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)) : Container(),
            ],
          ),
          Text('Experience : ${trainingSkill.experience}',
              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins'))
        ],
      ),
    );
  }

  /// Training Qualification Container
  Widget containerQualificationTraining(List<TrainingQualificationModel> trainingQua, Size size) {
    List<Widget> containerWidgets = [];
    for (TrainingQualificationModel qualification in trainingQua) {
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
                  qualification.mandatory == true ? SvgPicture.asset(ImagePath.tickCircleIcon, width: 20, height: 18,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)) : Container(),
                ],
              )),
        ),
      );
    }

    return Wrap(
      children: containerWidgets,
    );
  }

  /// Training Hobby Container
  Widget containerHobbyTraining(List<TrainingHobbyModel> trainingHobby, Size size) {
    List<Widget> containerWidgets = [];
    for (TrainingHobbyModel hobby in trainingHobby) {
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
