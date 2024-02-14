import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Screens/Project/accepted_project_screen.dart';
import 'package:versa_tribe/Screens/Project/ongoing_project_screen.dart';
import 'package:versa_tribe/Screens/Project/requested_project_screen.dart';
import 'package:versa_tribe/extension.dart';

import '../../Providers/dropmenu_provider.dart';
import '../Project/project_details_screen.dart';

class ProjectScreen extends StatefulWidget {
  final int? orgId;
  const ProjectScreen({super.key, required this.orgId});
  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dynamic dropMenuPro = Provider.of<DropMenuProvider>(context,listen: false);
    dropMenuPro.setDropMenu("All");
  }

  // List of items in our dropdown menu
  var menuItems = [
    'All',
    'Requested',
    'Joined',
    'Not joined',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Consumer<DropMenuProvider>(
                builder: (context,val,child) {
                  return val.dropMenu ==0? Container(
                    alignment: Alignment.centerRight,
                    child: DropdownButton(
                      dropdownColor: Colors.white,
                      //padding: EdgeInsets.symmetric(vertical: size.height*0.02,horizontal: size.width*0.02),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      alignment: Alignment.topRight,
                      // Initial Value
                      value: val.tpMenuItems,
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),
                      // Array list of items
                      items: menuItems.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will change button value to selected value
                      onChanged: (String? newValue) {
                        val.setDropMenu(newValue);
                        val.notify();
                      },
                    ),
                  ):const SizedBox.shrink();
                }
            ),

            Consumer<DropMenuProvider>(
              builder: (context,val,child) {
                return val.tpMenuItems=="All"?
                FutureBuilder(
                  future: ApiConfig.getProjectDataByOrgID(context, widget.orgId),
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
                            return val.getProjectListByOrgId.isNotEmpty ? Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: val.getProjectListByOrgId.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    child: Card(
                                      color: CustomColors.kWhiteColor,
                                      elevation: 3,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                                      margin: EdgeInsets.symmetric(horizontal:size.width * 0.03,vertical: size.height*0.005),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${val.getProjectListByOrgId[index].projectName}',
                                                style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                                            SizedBox(height: size.height * 0.01 / 2),
                                            /*const Text('Project Manager : _________',
                                                style: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                            SizedBox(height: size.height * 0.01 / 2),*/
                                            val.getProjectListByOrgId[index].startDate != null && val.getProjectListByOrgId[index].endDate != null ?
                                            Text('Duration : ${DateUtil().formattedDate(DateTime.parse(val.getProjectListByOrgId[index].startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(val.getProjectListByOrgId[index].endDate!).toLocal())}',
                                                style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')) :
                                            const Text('Duration : 00/00/0000 - 00/00/0000', style: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                            //SizedBox(height: size.height * 0.005),
                                            val.getProjectListByOrgId[index].isApproved==true?
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
                                            ):const SizedBox.shrink(),
                                            SizedBox(height: size.height * 0.005),
                                            LinearPercentIndicator(
                                              animation: true,
                                              lineHeight: size.height * 0.018,
                                              animationDuration: 2000,
                                              percent: val.getProjectListByOrgId[index].progress!.toDouble() / 100,
                                              center: Text("Progress: ${val.getProjectListByOrgId[index].progress} %",textAlign: TextAlign.center,
                                                  style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 10, fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                                              barRadius: const Radius.circular(5),
                                              progressColor: CustomColors.kBlueColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectDetailsScreen(projectResponseModel: val.getProjectListByOrgId[index],orgID: widget.orgId!,)));
                                    },
                                  );
                                },
                              ),
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
                ):
                val.tpMenuItems=="Requested"?
                FutureBuilder(
                  future: ApiConfig.getProjectDataByOrgID(context, widget.orgId),
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
                            final filteredList = val.getProjectListByOrgId.where((item) => item.isApproved==false).toList();
                            return filteredList.isNotEmpty ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Card(
                                    color: CustomColors.kWhiteColor,
                                    elevation: 3,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                                    margin: EdgeInsets.symmetric(horizontal:size.width * 0.03,vertical: size.height*0.005),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${filteredList[index].projectName}',
                                              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                                          SizedBox(height: size.height * 0.01 / 2),
                                          /*const Text('Project Manager : _________',
                                              style: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                          SizedBox(height: size.height * 0.01 / 2),*/
                                          filteredList[index].startDate != null && filteredList[index].endDate != null ?
                                          Text('Duration : ${DateUtil().formattedDate(DateTime.parse(filteredList[index].startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(val.getProjectListByOrgId[index].endDate!).toLocal())}',
                                              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')) :
                                          const Text('Duration : 00/00/0000 - 00/00/0000', style: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                          //SizedBox(height: size.height * 0.005),
                                          filteredList[index].isApproved==true?
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
                                          ):filteredList[index].isApproved==false?
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
                                          ):const SizedBox.shrink(),
                                          SizedBox(height: size.height * 0.005),
                                          LinearPercentIndicator(
                                            animation: true,
                                            lineHeight: size.height * 0.018,
                                            animationDuration: 2000,
                                            percent: filteredList[index].progress!.toDouble() / 100,
                                            center: Text("Progress: ${filteredList[index].progress} %",textAlign: TextAlign.center,
                                                style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 10, fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                                            barRadius: const Radius.circular(5),
                                            progressColor: CustomColors.kBlueColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectDetailsScreen(projectResponseModel: val.getProjectListByOrgId[index],orgID: widget.orgId!,)));
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
                ):
                val.tpMenuItems=="Joined"?
                FutureBuilder(
                  future: ApiConfig.getProjectDataByOrgID(context, widget.orgId),
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
                            final filteredList = val.getProjectListByOrgId.where((item) => item.isApproved==true).toList();
                            return filteredList.isNotEmpty ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Card(
                                    color: CustomColors.kWhiteColor,
                                    elevation: 3,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                                    margin: EdgeInsets.symmetric(horizontal:size.width * 0.03,vertical: size.height*0.005),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${filteredList[index].projectName}',
                                              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                                          SizedBox(height: size.height * 0.01 / 2),
                                          /*const Text('Project Manager : _________',
                                              style: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                          SizedBox(height: size.height * 0.01 / 2),*/
                                          filteredList[index].startDate != null && filteredList[index].endDate != null ?
                                          Text('Duration : ${DateUtil().formattedDate(DateTime.parse(filteredList[index].startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(val.getProjectListByOrgId[index].endDate!).toLocal())}',
                                              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')) :
                                          const Text('Duration : 00/00/0000 - 00/00/0000', style: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                          //SizedBox(height: size.height * 0.005),
                                          filteredList[index].isApproved==true?
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
                                          ):filteredList[index].isApproved==false?
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
                                          ):const SizedBox.shrink(),
                                          SizedBox(height: size.height * 0.005),
                                          LinearPercentIndicator(
                                            animation: true,
                                            lineHeight: size.height * 0.018,
                                            animationDuration: 2000,
                                            percent: filteredList[index].progress!.toDouble() / 100,
                                            center: Text("Progress: ${filteredList[index].progress} %",textAlign: TextAlign.center,
                                                style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 10, fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                                            barRadius: const Radius.circular(5),
                                            progressColor: CustomColors.kBlueColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectDetailsScreen(projectResponseModel: val.getProjectListByOrgId[index],orgID: widget.orgId!,)));
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
                ):
                FutureBuilder(
                  future: ApiConfig.getProjectDataByOrgID(context, widget.orgId),
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
                            final filteredList = val.getProjectListByOrgId.where((item) => item.isApproved==null).toList();
                            return filteredList.isNotEmpty ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Card(
                                    color: CustomColors.kWhiteColor,
                                    elevation: 3,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                                    margin: EdgeInsets.symmetric(horizontal:size.width * 0.03,vertical: size.height*0.005),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${filteredList[index].projectName}',
                                              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                                          SizedBox(height: size.height * 0.01 / 2),
                                          /*const Text('Project Manager : _________',
                                              style: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                          SizedBox(height: size.height * 0.01 / 2),*/
                                          filteredList[index].startDate != null && filteredList[index].endDate != null ?
                                          Text('Duration : ${DateUtil().formattedDate(DateTime.parse(filteredList[index].startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(val.getProjectListByOrgId[index].endDate!).toLocal())}',
                                              style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')) :
                                          const Text('Duration : 00/00/0000 - 00/00/0000', style: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                          //SizedBox(height: size.height * 0.005),
                                          filteredList[index].isApproved==true?
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
                                          ):filteredList[index].isApproved==false?
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
                                          ):const SizedBox.shrink(),
                                          SizedBox(height: size.height * 0.005),
                                          LinearPercentIndicator(
                                            animation: true,
                                            lineHeight: size.height * 0.018,
                                            animationDuration: 2000,
                                            percent: filteredList[index].progress!.toDouble() / 100,
                                            center: Text("Progress: ${filteredList[index].progress} %",textAlign: TextAlign.center,
                                                style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 10, fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                                            barRadius: const Radius.circular(5),
                                            progressColor: CustomColors.kBlueColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectDetailsScreen(projectResponseModel: val.getProjectListByOrgId[index],orgID: widget.orgId!,)));
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
                );
              }
            ),

            ///Tab Screens
            // Padding(
            //   padding: EdgeInsets.only(
            //       top: size.height * 0.02,
            //       left: size.width * 0.02,
            //       right: size.height * 0.02),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Expanded(
            //         child: TabBar(
            //           isScrollable: true,
            //           tabAlignment: TabAlignment.start,
            //           labelPadding: const EdgeInsets.symmetric(horizontal: 5),
            //           controller: _tabController,
            //           indicator: BoxDecoration(
            //             borderRadius: BorderRadius.circular(5),
            //             color: CustomColors.kBlueColor, // Change the color of the selected tab here
            //           ),
            //           indicatorSize: TabBarIndicatorSize.label,
            //           unselectedLabelStyle: const TextStyle(fontSize: 14, color: CustomColors.kBlackColor, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
            //           labelStyle: const TextStyle(fontSize: 14, color : CustomColors.kWhiteColor,fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
            //           tabs: <Widget>[
            //             Container(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: const Text(CustomString.onGoingProject)
            //             ),
            //             Container(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: const Text(CustomString.requested)
            //             ),
            //             Container(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: const Text(CustomString.accepted)
            //             )
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Expanded(
            //   child: TabBarView(
            //     controller: _tabController,
            //     physics: const NeverScrollableScrollPhysics(),
            //     children: <Widget>[
            //       OnGoingProjectScreen(orgId: widget.orgId),
            //       RequestedProjectScreen(orgID: widget.orgId),
            //       AcceptedProjectScreen(orgID: widget.orgId)
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

