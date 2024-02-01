import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Providers/visiblity_join_training_btn_provider.dart';
import 'package:versa_tribe/extension.dart';

class TakeTrainingDetailScreen extends StatefulWidget {

  final TakeTrainingDataModel trainingResponse;
  final int orgID;

  const TakeTrainingDetailScreen({super.key,required this.trainingResponse, required this.orgID});

  @override
  State<TakeTrainingDetailScreen> createState() => _TakeTrainingDetailScreenState();
}

class _TakeTrainingDetailScreenState extends State<TakeTrainingDetailScreen> {
  @override
  initState(){
    super.initState();
    debugPrint("----->${widget.trainingResponse.toJson()}");
  }

  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      ApiConfig.getTrainingExperience(context, widget.trainingResponse.trainingId);
      ApiConfig.getTrainingQualification(context, widget.trainingResponse.trainingId);
      ApiConfig.getTrainingSkill(context, widget.trainingResponse.trainingId);
      ApiConfig.getTrainingHobby(context, widget.trainingResponse.trainingId);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<TakeTrainingListProvider>(context,listen:false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kGrayColor,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios,
              color: CustomColors.kBlackColor),
          onTap: () {
            ApiConfig.getTakeTrainingData(context: context ,orgId: widget.orgID);
            Navigator.pop(context);
          },
        ),
        title: const Text(CustomString.trainingDetails,
            style: TextStyle(
                color: CustomColors.kBlueColor,fontSize: 16, fontFamily: 'Poppins')),
        centerTitle: true,
      ),
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
                    Text(widget.trainingResponse.trainingName!,
                        style: const TextStyle(color: CustomColors.kBlueColor, fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.normal, overflow: TextOverflow.fade)),
                    SizedBox(height: size.height * 0.01),
                    Text('Duration : ${DateUtil().formattedDate(DateTime.parse(widget.trainingResponse.startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(widget.trainingResponse.endDate!).toLocal())}',
                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                    //SizedBox(height: size.height * 0.002),
                    Text('Person Limit : ${widget.trainingResponse.personLimit!}',
                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01),
                    const Text('Description',
                        style: TextStyle(color: CustomColors.kBlackColor, fontSize: 16, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),
                    Text(widget.trainingResponse.description!,
                        style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins', overflow: TextOverflow.fade)),
                    SizedBox(height: size.height * 0.01),
                    const Text("Training Criteria",
                        style: TextStyle(color: CustomColors.kBlackColor, fontSize: 16, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01),

                    ///Criteria Experience
                    const Text(CustomString.experience,
                        style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),
                    FutureBuilder(
                        future: ApiConfig.getTrainingExperience(context, widget.trainingResponse.trainingId),
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
                                      return containerExperienceTraining(val.trainingEx[index],size);
                                    },
                                  ) : Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
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

                    ///Criteria Qualification
                    const Text(CustomString.qualification,
                        style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),
                    FutureBuilder(
                        future: ApiConfig.getTrainingQualification(context, widget.trainingResponse.trainingId),
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
                                  return val.trainingQua.isNotEmpty ? containerQualificationTraining(val.trainingQua,size) :
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

                    ///Criteria Skill
                    const Text(CustomString.skill,
                        style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),
                    FutureBuilder(
                        future: ApiConfig.getTrainingSkill(context, widget.trainingResponse.trainingId),
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
                                      return containerSkillTraining(val.trainingSkill[index],size);
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

                    ///Criteria hobby
                    const Text(CustomString.hobby,
                        style: TextStyle(color: CustomColors.kBlackColor, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Poppins')),
                    SizedBox(height: size.height * 0.01 / 2),
                    FutureBuilder(
                        future: ApiConfig.getTrainingHobby(context, widget.trainingResponse.trainingId),
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
                    SizedBox(height: size.height * 0.01),
                    ///Join Training Button
                    SizedBox(
                      width: double.infinity,
                      child: Consumer<VisibilityJoinTrainingBtnProvider>(
                          builder: (context,val,child) {
                            return widget.trainingResponse.isJoin==true &&val.trainingBtnVisibility==true?
                            ElevatedButton(
                              onPressed: () {
                                ApiConfig().deleteJoinedTraining(context: context, trainingId: widget.trainingResponse.trainingId);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.kBlueColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ), padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                              ),
                              child: const Text(
                                "Leave",
                                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
                              ),
                            ):
                            val.trainingBtnVisibility==false?
                            ElevatedButton(
                            onPressed: () {
                              ApiConfig().joinTraining(context: context, trainingId: widget.trainingResponse.trainingId,isJoin: false, trainingResponse: widget.trainingResponse);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.kBlueColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ), padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  ),
                            child: const Text(
                              CustomString.joinTraining,
                              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
                            ),
                            ): ElevatedButton(
                            onPressed: () {
                            ApiConfig().deleteJoinedTraining(context: context, trainingId: widget.trainingResponse.trainingId);
                            },
                            style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.kBlueColor,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            ), padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                            ),
                            child: const Text(
                            "Cancel",
                            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
                            ),
                            );
                          }
                        )
                    ),
                    SizedBox(height: size.height*0.01,),
                    Consumer<VisibilityJoinTrainingBtnProvider>(
                        builder: (context,val,child) {
                          return widget.trainingResponse.isJoin==true && val.trainingBtnVisibility==true?Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: CustomColors.kLightGrayColor,
                            ),
                            child: const Text("Already Joined",
                              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
                            ),
                          ):val.trainingBtnVisibility==true? Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: CustomColors.kLightGrayColor,
                          ),
                          child: const Text("Requested",
                            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
                          ),
                        ):const SizedBox.shrink();
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
  Widget containerExperienceTraining(TrainingExperienceModel trainingEx,size) {
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
              Text(trainingEx.jobTitle!,
                  style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
              const Spacer(),
              trainingEx.mandatory == true ? SvgPicture.asset(ImagePath.tickCircleIcon, width: 20, height: 20,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)) : Container(),
            ],
          ),
          trainingEx.companyName!=null&&trainingEx.companyName!=""?Text(trainingEx.companyName!,
              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')):
          Text(trainingEx.industryFieldName!,
              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
          Text('Experience : ${trainingEx.expMonths!}',
              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins'))
        ],
      ),
    );
  }

  /// Training Skill Container
  Widget containerSkillTraining(TrainingSkillModel trainingSkill,size) {
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
              Text(trainingSkill.skillName!,
                  style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
              const Spacer(),
              trainingSkill.mandatory == true ? SvgPicture.asset(ImagePath.tickCircleIcon, width: 10, height: 20,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)) : Container(),
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

