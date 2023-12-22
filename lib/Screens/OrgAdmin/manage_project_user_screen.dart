import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class ManageUserProjectScreen extends StatefulWidget {

  final ProjectListByOrgIDModel projectResponseModel;

  const ManageUserProjectScreen({super.key, required this.projectResponseModel});

  @override
  State<ManageUserProjectScreen> createState() => _ManageUserProjectScreenState();
}

class _ManageUserProjectScreenState extends State<ManageUserProjectScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: ApiConfig.getProjectManageUserData(context, widget.projectResponseModel.projectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: size.height * 0.21,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<ProjectListManageUserProvider>(
                builder: (context, val, child) {
                  return val.getProjectListManageUser.isNotEmpty ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: val.getProjectListManageUser.length,
                    itemBuilder: (context, index) {
                      return val.getProjectListManageUser[index].isApproved != true ? Card(
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
                                            text: '${val.getProjectListManageUser[index].firstName} is requested to join ',
                                          ),
                                          TextSpan(
                                            text: val.getProjectListManageUser[index].projectName,
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              // Change this to the color you desire
                                              // You can apply other styles specific to this part of the text if needed
                                            ),
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
                                          ApiConfig.rejectProjectManageUser(context, val.getProjectListManageUser[index].id, widget.projectResponseModel.projectId);
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
                      ) : Card(
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
                                            text: '${val.getProjectListManageUser[index].firstName} request to join in ',
                                          ),
                                          TextSpan(
                                            text: val.getProjectListManageUser[index].projectName,
                                            style: const TextStyle(
                                              color: Colors.blue, // Change this to the color you desire
                                              // You can apply other styles specific to this part of the text if needed
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
                                       ApiConfig.rejectProjectManageUser(context, val.getProjectListManageUser[index].id, widget.projectResponseModel.projectId);
                                    },
                                    child: const Text(CustomString.remove, style: TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'))),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ) : SizedBox(
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
      ),
    );
  }
}
