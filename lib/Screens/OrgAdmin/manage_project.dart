import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';
import 'ManageProject/orgadmin_manage_project_screen.dart';

class ManageProjectScreen extends StatefulWidget {
  final int? orgId;
  const ManageProjectScreen({super.key, required this.orgId});
  @override
  State<ManageProjectScreen> createState() => _ManageProjectScreenState();
}

class _ManageProjectScreenState extends State<ManageProjectScreen> {
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
      backgroundColor: CustomColors.kWhiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.kGrayColor,
        leading: IconButton(
            onPressed: () {Navigator.pop(context);},
            icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor) //replace with our own icon data.
        ),
        centerTitle: true,
        title: const Text(CustomString.manageProject,
            style: TextStyle(color: CustomColors.kBlueColor,fontSize: 16, fontFamily: 'Poppins')),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: FutureBuilder(
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
              return Consumer<ProjectListByOrgIdProvider>(
                  builder: (context, val, child) {
                    return val.getProjectListByOrgId.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.getProjectListByOrgId.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Card(
                            color: CustomColors.kGrayColor,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6))),
                            margin: EdgeInsets.symmetric(horizontal:size.width * 0.03,vertical: size.height*0.005),
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${val.getProjectListByOrgId[index].projectName}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                                    // SizedBox(height: size.height * 0.01 / 2),
                                    // const Text(
                                    //     'Project Manager :------',
                                    //     style: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    val.getProjectListByOrgId[index].startDate != null && val.getProjectListByOrgId[index].endDate != null ?
                                    Text('Duration : ${DateUtil().formattedDate(DateTime.parse(val.getProjectListByOrgId[index].startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(val.getProjectListByOrgId[index].endDate!).toLocal())}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')) : const Text('Duration : 00/00/0000 - 00/00/0000', style: TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                    //SizedBox(height: size.height * 0.01),
                                   /* val.getProjectListByOrgId[index].isApproved==true?
                                    Card(
                                      elevation: 1,
                                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none),
                                      child:Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.01,vertical: size.height*0.005),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("Already Joined",style: TextStyle(fontFamily: 'Poppins'),),
                                            SvgPicture.asset(ImagePath.danderIcon,height: size.height*0.02,),
                                          ],
                                        ),
                                      ),
                                    ):val.getProjectListByOrgId[index].isApproved==false?
                                    Card(
                                      elevation: 1,
                                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none),
                                      child:Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.01,vertical: size.height*0.005),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("Already Applied",style: TextStyle(fontFamily: 'Poppins'),),
                                            SvgPicture.asset(ImagePath.danderIcon,height: size.height*0.02,),
                                          ],
                                        ),
                                      ),
                                    ):const SizedBox.shrink(),*/
                                    SizedBox(height: size.height * 0.005),
                                    LinearPercentIndicator(
                                      animation: true,
                                      lineHeight: size.height * 0.018,
                                      animationDuration: 2000,
                                      percent: val.getProjectListByOrgId[index].progress!.toDouble() / 100,
                                      center: Text("Progress: ${val.getProjectListByOrgId[index].progress} %",
                                          style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 10, fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                                      barRadius: const Radius.circular(5),
                                      progressColor: CustomColors.kBlueColor,
                                    )
                                  ],
                                )),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrgManageProjectDetailScreen(projectResponseModel: val.getProjectListByOrgId[index],orgID: widget.orgId!,)));
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
              debugPrint("-----Manage Project print future builder------");
            }
            return Container();
          },
        ),
      ),
    );
  }
}
