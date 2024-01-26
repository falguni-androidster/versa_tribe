import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/Project/project_details_screen.dart';

import 'package:versa_tribe/extension.dart';

class OnGoingProjectScreen extends StatefulWidget {

  final int? orgId;

  const OnGoingProjectScreen({super.key, required this.orgId});

  @override
  State<OnGoingProjectScreen> createState() => _OnGoingProjectScreenState();
}

class _OnGoingProjectScreenState extends State<OnGoingProjectScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    broadcastUpdate();
  }

  broadcastUpdate() async {
    FBroadcast.instance().register("Key_Message", (value, callback) {
      var orgID = value;
      ApiConfig.getProjectDataByOrgID(context, orgID);
    });
  }


  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      ApiConfig.getProjectDataByOrgID(context, widget.orgId);
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
        child: FutureBuilder(
          future: ApiConfig.getProjectDataByOrgID(context, widget.orgId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: size.height * 0.21,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<ProjectListByOrgIdProvider>(
                  builder: (context, val, child) {
                    return val.getProjectListByOrgId.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.getProjectListByOrgId.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Card(
                            color: CustomColors.kWhiteColor,
                            elevation: 3,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                            margin: EdgeInsets.all(size.width * 0.01),
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: size.height * 0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${val.getProjectListByOrgId[index].projectName}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    val.getProjectListByOrgId[index].startDate != null && val.getProjectListByOrgId[index].endDate != null ? Text(
                                        'Duration : ${DateUtil().formattedDate(DateTime.parse(val.getProjectListByOrgId[index].startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(val.getProjectListByOrgId[index].endDate!).toLocal())}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')) : const Text('Duration : 00/00/0000 - 00/00/0000', style: TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    Text("Progress : ${val.getProjectListByOrgId[index].progress} %",
                                        style: const TextStyle(color: CustomColors.kBlueColor, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                    SizedBox(height: size.height * 0.01),
                                    LinearPercentIndicator(
                                      animation: true,
                                      lineHeight: size.height * 0.005,
                                      animationDuration: 2000,
                                      percent: val.getProjectListByOrgId[index].progress!.toDouble() / 100,
                                      barRadius: const Radius.circular(30),
                                      progressColor: CustomColors.kBlueColor,
                                    ),
                                    val.getProjectListByOrgId[index].isApproved == true ? Card(
                                      elevation: 1,
                                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: size.height * 0.005),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("Already Joined", style: TextStyle(fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                                            SizedBox(width: size.width * 0.005),
                                            SvgPicture.asset(ImagePath.danderIcon, height: size.height * 0.02),
                                          ],
                                        ),
                                      ),
                                    ) :
                                    val.getProjectListByOrgId[index].isApproved == false ? Card(
                                      elevation: 1,
                                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: size.height * 0.005),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("Already Applied", style: TextStyle(fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                                            SizedBox(width: size.width * 0.005),
                                            SvgPicture.asset(ImagePath.danderIcon, height: size.height * 0.02),
                                          ],
                                        ),
                                      ),
                                    ) : const SizedBox.shrink()
                                  ],
                                )),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectDetailsScreen(projectResponseModel: val.getProjectListByOrgId[index])));
                          },
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
              debugPrint("-----Project print future builder------");
            }
            return Container();
          },
        ),
      ),
    );
  }
}
