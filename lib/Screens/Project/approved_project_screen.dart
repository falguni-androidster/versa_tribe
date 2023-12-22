import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class ApprovedProjectScreen extends StatefulWidget {
  const ApprovedProjectScreen({super.key});

  @override
  State<ApprovedProjectScreen> createState() => _ApprovedProjectScreenState();
}

class _ApprovedProjectScreenState extends State<ApprovedProjectScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      body: FutureBuilder(
        future: ApiConfig.getApprovedProject(context: context, isApproved: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: size.height * 0.21,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );

          } else if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<ProjectApprovedProvider>(
                builder: (context, val, child) {
                  return val.projectApproved.isNotEmpty ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: val.projectApproved.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Card(
                          color: CustomColors.kWhiteColor,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                          margin: EdgeInsets.all(size.width * 0.01),
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
                                              const TextSpan(
                                                text: 'Your request is to join in ',
                                              ),
                                              TextSpan(
                                                text: val.projectApproved[index].projectName,
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
                                      onPressed: () {
                                        ApiConfig.rejectProjectManageUser(context, val.projectApproved[index].id, val.projectApproved[index].projectId);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: CustomColors.kGrayColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          )),
                                      child: const Text(
                                        CustomString.leave,
                                        style: TextStyle(fontSize: 12, color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
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
                              const Text(CustomString.noDataFound, style: TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))
                            ]),
                      ));
                });
          } else {
            debugPrint("-----Requested Training print future builder------");
          }
          return Container();
        },
      ),
    );
  }
}