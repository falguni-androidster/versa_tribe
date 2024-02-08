import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Providers/dropmenu_provider.dart';
import 'package:versa_tribe/extension.dart';

class ManageUserProjectScreen extends StatefulWidget {
  final ProjectListByOrgIDModel projectResponseModel;
  const ManageUserProjectScreen({super.key, required this.projectResponseModel});
  @override
  State<ManageUserProjectScreen> createState() => _ManageUserProjectScreenState();
}
class _ManageUserProjectScreenState extends State<ManageUserProjectScreen> {
  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      ApiConfig.getProjectManageUserData(context, widget.projectResponseModel.projectId);
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
        child: Consumer<DropMenuProvider>(
          builder: (context,v,child) {
            return v.orgProjectMenuItems=="Pending Request"?FutureBuilder(
              future: _loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: size.height * 0.21,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                else if (snapshot.connectionState == ConnectionState.done) {
                  return Consumer<ProjectListManageUserProvider>(
                      builder: (context, val, child) {
                        return val.getProjectListManageUser.isNotEmpty ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: val.getProjectListManageUser.length,
                          itemBuilder: (context, index) {
                            return val.getProjectListManageUser[index].isApproved != true ?
                            Card(
                              elevation: 3,
                              color: CustomColors.kWhiteColor,
                              margin: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.005),
                              child: Padding(
                                padding:EdgeInsets.symmetric(horizontal: size.width*0.04,vertical: size.height*0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins'),
                                              children: [
                                                TextSpan(
                                                  text: '${val.getProjectListManageUser[index].firstName} is requested to join ',
                                                ),
                                                TextSpan(
                                                  text: val.getProjectListManageUser[index].projectName,
                                                  style: const TextStyle(color: CustomColors.kBlueColor,fontSize: 14, fontFamily: 'Poppins'),
                                                ),
                                                const TextSpan(text: ' Project'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: CustomColors.kGrayColor,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                                              onPressed: () async {
                                                ApiConfig.cancelProjectJoinedRequest(context: context, id: val.getProjectListManageUser[index].id, projectId: widget.projectResponseModel.projectId);
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
                                                ApiConfig.approveProjectManageUser(context, val.getProjectListManageUser[index].id, widget.projectResponseModel.projectId);
                                              },
                                              child: const Text(CustomString.approve, style: TextStyle(color: CustomColors.kWhiteColor, fontFamily: 'Poppins'))),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ):Container();
                            //     : Card(
                            //   elevation: 3,
                            //   color: CustomColors.kWhiteColor,
                            //   margin: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.005),
                            //   child: Padding(
                            //     padding:EdgeInsets.symmetric(horizontal: size.width*0.04,vertical: size.height*0.01),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       children: [
                            //         Row(
                            //           children: [
                            //             Expanded(
                            //               child: RichText(
                            //                 text: TextSpan(
                            //                   style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins'),
                            //                   children: [
                            //                     TextSpan(
                            //                       text: '${val.getProjectListManageUser[index].firstName} request is to join in ',
                            //                     ),
                            //                     TextSpan(
                            //                       text: val.getProjectListManageUser[index].projectName,
                            //                       style: const TextStyle(
                            //                         color: CustomColors.kBlueColor,
                            //                       ),
                            //                     ),
                            //                     const TextSpan(text: ' Project is confirmed'),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         SizedBox(
                            //           width: double.infinity,
                            //           child: ElevatedButton(
                            //               style: ElevatedButton.styleFrom(
                            //                   backgroundColor: CustomColors.kGrayColor,
                            //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                            //               onPressed: () async {
                            //                  ApiConfig.cancelProjectJoinedRequest(context: context, id: val.getProjectListManageUser[index].id, projectId: widget.projectResponseModel.projectId);
                            //               },
                            //               child: const Text(CustomString.remove, style: TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'))),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // );
                          },
                        ) :
                        SizedBox(
                            width: size.width,
                            height: defaultTargetPlatform == TargetPlatform.iOS ? size.height * 0.21 : size.height * 0.25,
                            child: Center(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(ImagePath.noData, fit: BoxFit.fill),
                                    const Text(CustomString.noProjectFound, style: TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))
                                  ]),
                            ));
                      });
                } else {
                  debugPrint("-----Project Manage User print future builder------");
                }
                return Container();
              },
            ):
            FutureBuilder(
              future: _loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: size.height * 0.21,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                else if (snapshot.connectionState == ConnectionState.done) {
                  return Consumer<ProjectListManageUserProvider>(
                      builder: (context, val, child) {
                        return val.getProjectListManageUser.isNotEmpty ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: val.getProjectListManageUser.length,
                          itemBuilder: (context, index) {
                            return val.getProjectListManageUser[index].isApproved == true ?
                            // Card(
                            //   elevation: 3,
                            //   color: CustomColors.kWhiteColor,
                            //   margin: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.005),
                            //   child: Padding(
                            //     padding:EdgeInsets.symmetric(horizontal: size.width*0.04,vertical: size.height*0.01),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       children: [
                            //         Row(
                            //           children: [
                            //             Expanded(
                            //               child: RichText(
                            //                 text: TextSpan(
                            //                   style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins'),
                            //                   children: [
                            //                     TextSpan(
                            //                       text: '${val.getProjectListManageUser[index].firstName} is requested to join ',
                            //                     ),
                            //                     TextSpan(
                            //                       text: val.getProjectListManageUser[index].projectName,
                            //                       style: const TextStyle(color: CustomColors.kBlueColor,fontSize: 14, fontFamily: 'Poppins'),
                            //                     ),
                            //                     const TextSpan(text: ' Project'),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         Row(
                            //           children: [
                            //             Expanded(
                            //               child: ElevatedButton(
                            //                   style: ElevatedButton.styleFrom(
                            //                       backgroundColor: CustomColors.kGrayColor,
                            //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                            //                   onPressed: () async {
                            //                     ApiConfig.cancelProjectJoinedRequest(context: context, id: val.getProjectListManageUser[index].id, projectId: widget.projectResponseModel.projectId);
                            //                   },
                            //                   child: const Text(CustomString.reject, style: TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'))),
                            //             ),
                            //             SizedBox(width: size.width * 0.02),
                            //             Expanded(
                            //               child: ElevatedButton(
                            //                   style: ElevatedButton.styleFrom(
                            //                       backgroundColor: CustomColors.kBlueColor,
                            //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                            //                   onPressed: () {
                            //                     ApiConfig.approveProjectManageUser(context, val.getProjectListManageUser[index].id, widget.projectResponseModel.projectId);
                            //                   },
                            //                   child: const Text(CustomString.approve, style: TextStyle(color: CustomColors.kWhiteColor, fontFamily: 'Poppins'))),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ):Container();
                            Card(
                              elevation: 3,
                              color: CustomColors.kWhiteColor,
                              margin: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.005),
                              child: Padding(
                                padding:EdgeInsets.symmetric(horizontal: size.width*0.04,vertical: size.height*0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins'),
                                              children: [
                                                TextSpan(
                                                  text: '${val.getProjectListManageUser[index].firstName} request is to join in ',
                                                ),
                                                TextSpan(
                                                  text: val.getProjectListManageUser[index].projectName,
                                                  style: const TextStyle(
                                                    color: CustomColors.kBlueColor,
                                                  ),
                                                ),
                                                const TextSpan(text: ' Project is confirmed'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: CustomColors.kGrayColor,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                                          onPressed: () async {
                                            ApiConfig.cancelProjectJoinedRequest(context: context, id: val.getProjectListManageUser[index].id, projectId: widget.projectResponseModel.projectId);
                                          },
                                          child: const Text(CustomString.remove, style: TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'))),
                                    ),
                                  ],
                                ),
                              ),
                            ):Container();
                          },
                        ) :
                        SizedBox(
                            width: size.width,
                            height: defaultTargetPlatform == TargetPlatform.iOS ? size.height * 0.21 : size.height * 0.25,
                            child: Center(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(ImagePath.noData, fit: BoxFit.fill),
                                    const Text(CustomString.noProjectFound, style: TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))
                                  ]),
                            ));
                      });
                } else {
                  debugPrint("-----Project Manage User print future builder------");
                }
                return Container();
              },
            );
          }
        ),
      ),
    );
  }
}
