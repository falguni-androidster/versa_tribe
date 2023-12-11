import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/OrgAdmin/add_new_department.dart';
import 'package:versa_tribe/extension.dart';

class ManageOrgMembers extends StatefulWidget {
  final String orgNAME;
  final int orgID;
  const ManageOrgMembers({super.key, required this.orgNAME,required this.orgID});
  @override
  State<ManageOrgMembers> createState() => _ManageOrgMembersState();
}
class _ManageOrgMembersState extends State<ManageOrgMembers> with SingleTickerProviderStateMixin {
  // define your tab controller here
  late TabController _tabController;

  @override
  void initState() {
    // initialise your tab controller here
    _tabController = TabController(length: 2, vsync: this);
    ApiConfig.getDepartment(context: context,orgId: widget.orgID);
    super.initState();
  }
  void _showDialog({reqDepName,context,orgID,personID,depID}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * 0.075,
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
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.01),
                          height: size.height * 0.05,
                          child: const Card(
                              color: CustomColors.kGrayColor,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(" Create New Department +",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: CustomColors.kBlueColor))))),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddNewDepartment(orgId: widget.orgID)));
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kWhiteColor,
        leading: InkWell(
          child:
          const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
          onTap: () async {
            Navigator.pop(context);
          },
        ),
        title: const Text(CustomString.manageOrgMember, style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.02, right: size.height * 0.02),
            child: Consumer<IndexProvider>(builder: (context, val, child) {
              return TabBar(
                onTap: (value) async {
                  debugPrint("Index Value for Tabs-----}$value");
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ManageOrgMembers(orgNAME: widget.orgNAME, orgID:widget.orgID)));
                  val.setOrgMemberIndex(value);
                  if (value == 0) {
                  } else {
                  }
                },
                isScrollable:true,
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                controller: _tabController,
                labelColor: CustomColors.kBlueColor,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: CustomColors.kBlackColor,
                unselectedLabelStyle: const TextStyle(fontSize: 16, color: CustomColors.kBlackColor, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                tabs: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width*0.03, vertical:size.height*0.008),
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                          color: CustomColors.kGrayColor),
                      child: const Text(CustomString.pendingRequested,style: TextStyle(fontFamily: 'Poppins'))),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width*0.03, vertical:size.height*0.008),
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                          color: CustomColors.kGrayColor),
                      child: const Text(CustomString.approved, style: TextStyle(fontFamily: 'Poppins'))),
                ],
              );
            }),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                ///Pending Requested
                FutureBuilder(
                    future: ApiConfig.getOrgMemberData(context: context,orgName: widget.orgNAME, tabIndex: 0),
                    builder: (context,snapshot) {
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return SizedBox(
                          height: size.height*0.21,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }else if(snapshot.connectionState==ConnectionState.done){
                        return Consumer<DisplayOrgMemberProvider>(
                            builder: (context, val, child) {
                              return val.requestPendingOrgDataList.isNotEmpty ?
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: val.requestPendingOrgDataList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: defaultTargetPlatform == TargetPlatform.iOS?size.height * 0.1:size.height * 0.13,
                                      decoration: const BoxDecoration(
                                          border: BorderDirectional(
                                            bottom: BorderSide(width: 0.3,color: CustomColors.kLightGrayColor),
                                          )
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.03,
                                          vertical: size.height * 0.005),
                                      child: SizedBox(
                                        width: size.width * 0.7,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: RichText(
                                                text: TextSpan(
                                                    text: "${val.requestPendingOrgDataList[index].firstName} ${val.requestPendingOrgDataList[index].lastName} ${CustomString.requestedToJoinAdmin}",style: DefaultTextStyle.of(context).style,
                                                    children: [
                                                      TextSpan(text: val.requestPendingOrgDataList[index].deptName??"",style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
                                                    ]
                                                ),
                                              ),
                                            ),
                                            Text(timeAgo(val.requestPendingOrgDataList[index].tStamp.toString()),
                                                style: const TextStyle(fontSize: 12, color: CustomColors.kLightGrayColor, fontFamily: 'Poppins')),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width/2.2,
                                                  child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CustomColors.kGrayColor),),
                                                      onPressed: () async {
                                                        showRemoveConfirmation(context:context, indexedOrgId:val.requestPendingOrgDataList[index].orgId, personId:val.requestPendingOrgDataList[index].personId, orgName: widget.orgNAME, orgId: widget.orgID);
                                                      },
                                                      child: const Text(CustomString.reject, style: TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'))),
                                                ),
                                                SizedBox(width: size.width * 0.03,),
                                                SizedBox(
                                                  width: size.width/2.2,
                                                  child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CustomColors.kBlueColor),),
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
                                    SizedBox(height: size.height*0.02,),
                                    SizedBox(height: size.height*0.2,width: size.width/1.5,child: Image.asset(ImagePath.noData,fit: BoxFit.fill,)),
                                    SizedBox(height: size.height*0.2,),
                                    const Text(CustomString.noDataFound,style: TextStyle(color: CustomColors.kLightGrayColor),)
                                  ],),
                              );
                            }
                        );
                      }
                      return Container();
                    }
                ),

                ///Approved
                FutureBuilder(
                    future: ApiConfig.getOrgMemberData(context: context,orgName: widget.orgNAME, tabIndex: 1),
                    builder: (context,snapshot) {
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return SizedBox(
                          height: size.height*0.21,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }else if(snapshot.connectionState==ConnectionState.done){
                        return Consumer<DisplayOrgMemberProvider>(
                            builder: (context, val, child) {
                              return val.approveOrgDataList.isNotEmpty ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: val.approveOrgDataList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      //height: size.height * 0.1,
                                      decoration: const BoxDecoration(
                                          border: BorderDirectional(
                                            bottom: BorderSide(width: 0.3,color: CustomColors.kLightGrayColor),)
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.03,
                                          vertical: size.height * 0.005),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.7,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: size.height * 0.004),
                                                Flexible(
                                                    child: RichText(
                                                      text: TextSpan(
                                                          text: "${val.approveOrgDataList[index].firstName} ${val.approveOrgDataList[index].lastName} ${CustomString.approvedToJoinAdmin} ",style: DefaultTextStyle.of(context).style,
                                                          children: [
                                                            TextSpan(text: val.approveOrgDataList[index].deptName??"",style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
                                                          ]
                                                      ),)
                                                ),
                                                SizedBox(height: size.height * 0.004),
                                                Text(timeAgo(val.approveOrgDataList[index].tStamp.toString()),
                                                    style: const TextStyle(fontSize: 10, color: CustomColors.kLightGrayColor, fontFamily: 'Poppins')),
                                                SizedBox(height: size.height * 0.004),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton(
                                              child: CircleAvatar(
                                                  radius:10,backgroundColor: Colors.transparent,
                                                  child: SvgPicture.asset(ImagePath.more, width: 15, height: 30, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn))),
                                              onSelected: (item) {
                                                switch (item) {
                                                  case 0:
                                                    showToast(context, "View Clicked");
                                                  case 1:
                                                  ///edit logic
                                                    showToast(context, "Edit Clicked");
                                                  case 2:
                                                    showRemoveConfirmation(context:context, indexedOrgId:val.approveOrgDataList[index].orgId, personId:val.approveOrgDataList[index].personId, orgName: widget.orgNAME, orgId: widget.orgID);
                                                }
                                              },
                                              itemBuilder: (_) => [
                                                const PopupMenuItem(
                                                    value: 0, child: Text(CustomString.view, style: TextStyle(fontFamily: 'Poppins'))),
                                                const PopupMenuItem(
                                                    value: 1, child: Text(CustomString.edit, style: TextStyle(fontFamily: 'Poppins'))),
                                                const PopupMenuItem(
                                                    value: 2, child: Text(CustomString.remove, style: TextStyle(fontFamily: 'Poppins')))
                                              ]),
                                        ],
                                      ),
                                    );
                                  }) :
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: size.height*0.02,),
                                    SizedBox(height: size.height*0.2,width: size.width/1.5,child: Image.asset(ImagePath.noData,fit: BoxFit.fill,)),
                                    SizedBox(height: size.height*0.2,),
                                    const Text(CustomString.noDataFound,style: TextStyle(color: CustomColors.kLightGrayColor),)
                                  ],),
                              );
                            }
                        );
                      }
                      return Container();
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
