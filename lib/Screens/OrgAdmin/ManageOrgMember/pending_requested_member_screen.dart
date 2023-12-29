import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:versa_tribe/extension.dart';
import '../ManageDepartment/add_new_department.dart';

class PendingRequestedOrgMembersScreen extends StatefulWidget {

  final String orgNAME;
  final int orgID;

  const PendingRequestedOrgMembersScreen({super.key, required this.orgNAME, required this.orgID});

  @override
  State<PendingRequestedOrgMembersScreen> createState() => _PendingRequestedOrgMembersScreenState();
}

class _PendingRequestedOrgMembersScreenState extends State<PendingRequestedOrgMembersScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
          future: ApiConfig.getOrgMemberData(context: context,orgName: widget.orgNAME, tabIndex: 0),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return SizedBox(
                height: size.height*0.21,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }else if(snapshot.connectionState == ConnectionState.done){
              return Consumer<RequestMemberProvider>(
                  builder: (context, val, child) {
                    return val.requestPendingOrgDataList.isNotEmpty ?
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: val.requestPendingOrgDataList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: defaultTargetPlatform == TargetPlatform.iOS ? size.height * 0.1 : size.height * 0.13,
                            decoration: const BoxDecoration(
                                border: BorderDirectional(
                                  bottom: BorderSide(width: 0.3,color: CustomColors.kLightGrayColor),
                                )
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03,
                                vertical: size.height * 0.005),
                            child: SizedBox(
                              width: size.width * 0.6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                          text: "${val.requestPendingOrgDataList[index].firstName} ${val.requestPendingOrgDataList[index].lastName} ${CustomString.requestedToJoinAdmin}",style: DefaultTextStyle.of(context).style,
                                          children: [
                                            TextSpan(text: val.requestPendingOrgDataList[index].deptName??"", style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
                                          ]
                                      ),
                                    ),
                                  ),
                                  Text(timeAgo(val.requestPendingOrgDataList[index].tStamp.toString()),
                                      style: const TextStyle(fontSize: 12, color: CustomColors.kLightGrayColor, fontFamily: 'Poppins')),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: CustomColors.kGrayColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                                            onPressed: () async {
                                              showRemoveConfirmation(context:context, indexedOrgId:val.requestPendingOrgDataList[index].orgId, personId:val.requestPendingOrgDataList[index].personId, orgName: widget.orgNAME, orgId: widget.orgID, screen: CustomString.pendingRequested);
                                            },
                                            child: const Text(CustomString.reject, style: TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'))),
                                      ),
                                      SizedBox(width: size.width * 0.02),
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: CustomColors.kBlueColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                                            onPressed: () {
                                              _showDialog(reqDepName:val.requestPendingOrgDataList[index].deptName,context: context,orgID: val.requestPendingOrgDataList[index].orgId,personID:val.requestPendingOrgDataList[index].personId,depID: val.requestPendingOrgDataList[index].deptId);
                                              debugPrint("------->${val.requestPendingOrgDataList[index].orgId}");
                                            },
                                            child: const Text(CustomString.assign, style: TextStyle(color: CustomColors.kWhiteColor, fontFamily: 'Poppins'))),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }) :
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height * 0.02),
                          SizedBox(height: size.height * 0.2, width: size.width/1.5, child: Image.asset(ImagePath.noData, fit: BoxFit.fill)),
                          SizedBox(height: size.height * 0.2),
                          const Text(CustomString.noDataFound, style: TextStyle(color: CustomColors.kLightGrayColor))
                        ]),
                    );
                  }
              );
            }
            return Container();
          }
      ),
    );
  }

  void _showDialog({reqDepName,context,orgID,personID,depID}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * 0.07,
                child: Scaffold(
                  appBar: AppBar(
                    iconTheme: const IconThemeData(color: CustomColors.kBlackColor),
                    backgroundColor: CustomColors.kGrayColor,
                    elevation: 0,
                    title: const Text(
                      CustomString.assignDepartment,
                      style: TextStyle(color: CustomColors.kBlueColor),
                    ),
                  ),
                ),
              ),
              Consumer<DepartmentProvider>(builder: (context, val, child) {
                return Column(
                  children: [
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                          color: CustomColors.kWhiteColor,
                          child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              color: CustomColors.kGrayColor,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(" Create New Department +",
                                        style: TextStyle(fontFamily: 'Poppins', color: CustomColors.kBlueColor))),
                              ))),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewDepartment(orgId: widget.orgID)));
                      },
                    ),
                    ListView.builder(
                      itemCount: val.department.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                              height: size.height * 0.05,
                              child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  color: val.department[index].deptName == reqDepName ? CustomColors.kBlueColor : CustomColors.kGrayColor,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(" ${val.department[index].deptName}",
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: val.department[index].deptName == reqDepName ? CustomColors.kWhiteColor : null)
                                      )
                                  )
                              )
                          ),
                          onTap: () {
                            ApiConfig.updateAssignOrgRequestStatus(context: context,orgID: orgID,personID: personID,depID: val.department[index].deptId,reqStatus: 1,orgName: widget.orgNAME);
                          },
                        );
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
