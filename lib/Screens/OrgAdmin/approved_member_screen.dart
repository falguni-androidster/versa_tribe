import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:versa_tribe/extension.dart';

class ApprovedMemberScreen extends StatefulWidget {

  final String orgNAME;
  final int orgID;

  const ApprovedMemberScreen({super.key, required this.orgNAME,required this.orgID});

  @override
  State<ApprovedMemberScreen> createState() => _ApprovedMemberScreenState();
}

class _ApprovedMemberScreenState extends State<ApprovedMemberScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
          future: ApiConfig.getOrgMemberData(context: context,orgName: widget.orgNAME, tabIndex: 1),
          builder: (context,snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return SizedBox(
                height: size.height * 0.21,
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
                                border: BorderDirectional(bottom: BorderSide(width: 0.3,color: CustomColors.kLightGrayColor))
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
                                          showRemoveConfirmation(context:context, indexedOrgId:val.approveOrgDataList[index].orgId, personId:val.approveOrgDataList[index].personId, orgName: widget.orgNAME, orgId: widget.orgID, screen: CustomString.approved);
                                      }
                                    },
                                    itemBuilder: (_) => [
                                      const PopupMenuItem(value: 0, child: Text(CustomString.view, style: TextStyle(fontFamily: 'Poppins'))),
                                      const PopupMenuItem(value: 1, child: Text(CustomString.edit, style: TextStyle(fontFamily: 'Poppins'))),
                                      const PopupMenuItem(value: 2, child: Text(CustomString.remove, style: TextStyle(fontFamily: 'Poppins')))
                                    ]),
                              ],
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
}
