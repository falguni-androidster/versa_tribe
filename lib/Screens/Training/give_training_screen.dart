import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:versa_tribe/extension.dart';

class GiveTrainingItemScreen extends StatefulWidget {

  final TrainingResponse trainingResponse;

  const GiveTrainingItemScreen({super.key,required this.trainingResponse});

  @override
  State<GiveTrainingItemScreen> createState() => _GiveTrainingItemScreenState();
}

class _GiveTrainingItemScreenState extends State<GiveTrainingItemScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kWhiteColor,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios,
              color: CustomColors.kBlackColor),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(CustomString.manageTraining,
            style: TextStyle(
                color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      backgroundColor: CustomColors.kWhiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.02,
                left: size.width * 0.02,
                right: size.height * 0.02),
            child: TabBar(
              isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: 5),
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: CustomColors.kBlueColor, // Change the color of the selected tab here
              ),
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelStyle: const TextStyle(fontSize: 14, color: CustomColors.kBlackColor, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
              tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(fontSize: 14, color : CustomColors.kWhiteColor,fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
              tabs: <Widget>[
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(CustomString.trainingDetails)
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(CustomString.joinedMembers)
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(CustomString.pendingRequest)
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[

                /// Training Details
                SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.all(size.width * 0.02),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.trainingResponse.trainingName!,
                                style: const TextStyle(color: CustomColors.kBlueColor, fontSize: 20, fontFamily: 'Poppins', fontWeight: FontWeight.w500, overflow: TextOverflow.fade)),
                            SizedBox(height: size.height * 0.01),
                            Text('Organization : ${widget.trainingResponse.orgName!}',
                                style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                            SizedBox(height: size.height * 0.01),
                            Text('Duration : ${DateUtil().formattedDate(DateTime.parse(widget.trainingResponse.startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(widget.trainingResponse.endDate!).toLocal())}',
                                style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                            SizedBox(height: size.height * 0.01),
                            Text('Person Limit : ${widget.trainingResponse.personLimit!}',
                                style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                            SizedBox(height: size.height * 0.01),
                            const Text('Description',
                                style: TextStyle(color: CustomColors.kBlackColor, fontSize: 16, fontFamily: 'Poppins')),
                            SizedBox(height: size.height * 0.01 / 2),
                            Text(widget.trainingResponse.description!,
                                style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins', overflow: TextOverflow.fade)),
                            SizedBox(height: size.height * 0.01),
                            const Text(CustomString.manageCriteria,
                                style: TextStyle(color: CustomColors.kBlackColor, fontSize: 16, fontFamily: 'Poppins')),
                            SizedBox(height: size.height * 0.01),
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
                                          return val.trainingQua.isNotEmpty ? containerQualificationTraining(val.trainingQua,size) : Container(
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

                /// Joined Members
                FutureBuilder(
                    future: ApiConfig.getTrainingJoinedMembers(context, widget.trainingResponse.trainingId, true),
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
                        return Consumer<TrainingJoinedMembersProvider>(
                            builder: (context, val, child) {
                              return val.trainingJoinedMembers.isNotEmpty ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: val.trainingJoinedMembers.length,
                                itemBuilder: (context, index) {
                                  return containerJoinedMembers(val.trainingJoinedMembers[index]);
                                },
                              ) : Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: size.height * 0.02),
                                    SizedBox(height: size.height * 0.2, width: size.width / 1.5, child: Image.asset(ImagePath.noData, fit: BoxFit.fill)),
                                    SizedBox(height: size.height * 0.2),
                                    const Text(CustomString.noDataFound, style: TextStyle(color: CustomColors.kLightGrayColor))
                                  ],),
                              );
                            });
                      }
                      else{
                        debugPrint("-----Joined Members print future builder else------");
                      }
                      return Container();
                    }),

                /// Pending Requests
                FutureBuilder(
                    future: ApiConfig.getTrainingPendingRequests(context, widget.trainingResponse.trainingId, false),
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
                        return Consumer<TrainingPendingRequestProvider>(
                            builder: (context, val, child) {
                              return val.trainingPendingRequests.isNotEmpty ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: val.trainingPendingRequests.length,
                                itemBuilder: (context, index) {
                                  return containerPendingRequest(val.trainingPendingRequests[index]);
                                },
                              ) : Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: size.height * 0.02),
                                    SizedBox(height: size.height * 0.2, width: size.width / 1.5, child: Image.asset(ImagePath.noData, fit: BoxFit.fill)),
                                    SizedBox(height: size.height * 0.2),
                                    const Text(CustomString.noDataFound, style: TextStyle(color: CustomColors.kLightGrayColor))
                                  ],),
                              );
                            });
                      }
                      else{
                        debugPrint("-----Pending Requests print future builder else------");
                      }
                      return Container();
                    }),
              ],
            ),
          ),
        ],
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
          Text(trainingEx.companyName!,
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
                  qualification.mandatory == true ? SvgPicture.asset(ImagePath.tickCircleIcon, width: 20, height: 20,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)) : Container(),
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
                  hobby.mandatory == true ? SvgPicture.asset(ImagePath.tickCircleIcon, width: 20, height: 20,colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)) : Container(),
                ],
              )),
        ),
      );
    }

    return Wrap(
      children: containerWidgets,
    );
  }

  /// Training Joined Members Container
  Widget containerJoinedMembers(TrainingJoinedMembersModel trainingJoinedMembersModel) {
    return Card(
      elevation: 3,
      color: CustomColors.kWhiteColor,
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins'),
                      children: [
                        TextSpan(
                          text: '${trainingJoinedMembersModel.firstName} ${trainingJoinedMembersModel.lastName} is joined in ',
                        ),
                        TextSpan(
                          text: trainingJoinedMembersModel.trainingName,
                          style: const TextStyle(
                            color: Colors.blue, // Change this to the color you desire
                            // You can apply other styles specific to this part of the text if needed
                          ),
                        ),
                        const TextSpan(text: ' Training'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  rejectRequestTraining(context: context, trainingId: trainingJoinedMembersModel.trainingId, personId: trainingJoinedMembersModel.personId);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.kGrayColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
                child: const Text(
                  CustomString.reject,
                  style: TextStyle(fontSize: 14, color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Training Joined Members Container
  Widget containerPendingRequest(TrainingPendingRequestsModel trainingPendingRequestsModel) {
    return Card(
      elevation: 3,
      color: CustomColors.kWhiteColor,
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins'),
                      children: [
                        TextSpan(
                          text: '${trainingPendingRequestsModel.firstName} ${trainingPendingRequestsModel.lastName} is requested to join ',
                        ),
                        TextSpan(
                          text: trainingPendingRequestsModel.trainingName,
                          style: const TextStyle(
                            color: Colors.blue, // Change this to the color you desire
                            // You can apply other styles specific to this part of the text if needed
                          ),
                        ),
                        const TextSpan(text: ' Training'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        rejectRequestTraining(context: context, trainingId: trainingPendingRequestsModel.trainingId, personId: trainingPendingRequestsModel.personId);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.kGrayColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          )),
                      child: const Text(
                        CustomString.reject,
                        style: TextStyle(fontSize: 14, color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        approveRequestTraining(context: context,trainingId: trainingPendingRequestsModel.trainingId,personId: trainingPendingRequestsModel.personId, isJoin: true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.kBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          )),
                      child: const Text(
                        CustomString.approve,
                        style: TextStyle(fontSize: 14, color: CustomColors.kWhiteColor, fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Reject Request Training
  rejectRequestTraining({context, trainingId, personId}) async {
    String apiUrl = "${ApiConfig.baseUrl}/api/Training_Join/Delete?training_Id=$trainingId&person_Id=$personId";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.delete(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      showToast(context, CustomString.rejected);
      Navigator.pop(context); // Pop the current screen
      Navigator.push(context, MaterialPageRoute(builder: (context) => GiveTrainingItemScreen(trainingResponse: widget.trainingResponse)));// Push the screen again
    } else {
      showToast(context, 'Try Again.....');
    }
  }

  /// Approve Request Training
  approveRequestTraining({context, trainingId, personId, isJoin}) async {
    Map<String, dynamic> requestData = {
      "Training_Id": trainingId,
      "Person_Id": personId,
      "Is_Join": isJoin,
    };
    String url = "${ApiConfig.baseUrl}/api/Training_Join/Update";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    final response = await http.put(Uri.parse(url),body: jsonEncode(requestData) , headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      showToast(context, CustomString.approved);
      Navigator.pop(context); // Pop the current screen
      Navigator.push(context, MaterialPageRoute(builder: (context) => GiveTrainingItemScreen(trainingResponse: widget.trainingResponse))); // Push the screen again
    } else {
      showToast(context, 'Try Again.....');
    }
  }
}
