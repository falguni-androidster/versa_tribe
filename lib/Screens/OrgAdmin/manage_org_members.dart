import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import '../../Providers/manage_org_index_provider.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/custom_string.dart';
import '../../Utils/helper.dart';
import '../../Utils/image_path.dart';

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
    super.initState();
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
            //padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            padding: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.02, right: size.height * 0.02),
            child: Consumer<IndexProvider>(builder: (context, val, child) {
              return TabBar(
                onTap: (value) async {
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
                    future: ApiConfig.getOrgMemberData(context: context, tabIndex: 0),
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
                                      height: size.height * 0.1,
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
                                            //SizedBox(height: size.height * 0.01),
                                            Text(timeAgo(val.requestPendingOrgDataList[index].tStamp.toString()),
                                                style: const TextStyle(fontSize: 12, color: CustomColors.kLightGrayColor, fontFamily: 'Poppins')),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width/2.2,
                                                  child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CustomColors.kGrayColor),),
                                                      onPressed: () {
                                                        ApiConfig.deleteOrgRequest(context: context,orgID: val.requestPendingOrgDataList[index].orgId,personID:val.requestPendingOrgDataList[index].personId);
                                                      },
                                                      child: const Text(CustomString.reject, style: TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'))),
                                                ),
                                                SizedBox(width: size.width * 0.03,),
                                                SizedBox(
                                                  width: size.width/2.2,
                                                  child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CustomColors.kBlueColor),),
                                                      onPressed: () {
                                                        ApiConfig.deleteOrgRequest(context: context,orgID: val.requestPendingOrgDataList[index].orgId,personID:val.requestPendingOrgDataList[index].personId);
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
                    future: ApiConfig.getOrgMemberData(context: context, tabIndex: 1),
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

                                                  case 1:
                                                  ///edit logic
                                                  /*  Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditExperienceScreen(
                                                                    title: CustomString.editExperience,
                                                                    pExJobTitle: vaL.personEx[index].jobTitle!,
                                                                    company: comN ?? "",
                                                                    industry: vaL.personEx[index].industryFieldName ?? "",
                                                                    pExId: vaL.personEx[index].perExpId,
                                                                    sDate: vaL.personEx[index].startDate!,
                                                                    eDate: vaL.personEx[index].endDate!)));*/
                                                  case 2:
                                                  showRemoveConfirmation(context: context);
                                                }
                                              },
                                              itemBuilder: (_) => [
                                                const PopupMenuItem(
                                                    value: 0, child: Text(CustomString.view, style: TextStyle(fontFamily: 'Poppins'))),
                                                const PopupMenuItem(
                                                    value: 0, child: Text(CustomString.edit, style: TextStyle(fontFamily: 'Poppins'))),
                                                const PopupMenuItem(
                                                    value: 1, child: Text(CustomString.remove, style: TextStyle(fontFamily: 'Poppins')))
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
