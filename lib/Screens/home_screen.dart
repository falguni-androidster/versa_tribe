import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Providers/organization_provider.dart';
import 'package:versa_tribe/Providers/switch_provider.dart';
import 'package:versa_tribe/Screens/Home/dashboard_screen.dart';
import 'package:versa_tribe/Screens/Home/project_screen.dart';
import 'package:versa_tribe/Screens/Home/training_screen.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import '../Model/SwitchDataModel.dart';
import '../Providers/bottom_tab_provider.dart';
import '../Utils/custom_colors.dart';
import '../Utils/custom_string.dart';
import '../Utils/image_path.dart';
import '../Utils/svg_btn.dart';
import 'Home/account_screen.dart';
import 'OrgAdmin/admin_manage.dart';
import 'manage_organization_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? from;
  const HomeScreen({super.key, this.from});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageStorageBucket bucket = PageStorageBucket();

  //final List<String> margList = [];
  List<OrgAdminPersonList> finalPersonAdminList = [];
  List<String> orgAdminList = [];
  //late OrgNameId oPData;
  //late OrgNameId oAData;
   String? selectedValue;
   int? orgId;
   bool? orgAdmin;

  @override
  initState() {
    setInitialValue();
   // checkUser();
    super.initState();
  }
  setInitialValue() async {
    final selectedOrgProvider = Provider.of<OrganizationProvider>(context,listen: false);
    final switchProvider = Provider.of<SwitchProvider>(context,listen: false);
    await ApiConfig.getDataSwitching(context: context);
    List<OrgAdminPersonList> adminPersonList = switchProvider.switchData.orgAdminPersonList!;
    //print("----->SWITCH DATAInitial--->${adminPersonList[0].orgName}");
    selectedValue = adminPersonList[0].orgName!;
    orgId = adminPersonList[0].orgId!;
    orgAdmin = adminPersonList[0].isAdmin!;
    finalPersonAdminList=adminPersonList;
    await selectedOrgProvider.setSwitchOrganization(selectedValue, orgId, orgAdmin);
    return adminPersonList;
  }
  checkUser() async {
    final switchProvider = Provider.of<SwitchProvider>(context,listen: false);
    List<OrgAdminPersonList> adminPersonList = switchProvider.switchData.orgAdminPersonList!;
    //print("----->SWITCH DATA--->${adminPersonList[0].orgName}");
    selectedValue = adminPersonList[0].orgName!;
    orgId = adminPersonList[0].orgId!;
    orgAdmin = adminPersonList[0].isAdmin!;
    finalPersonAdminList=adminPersonList;
    return adminPersonList;
  }

 /* checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic>? responseList = prefs.getJson('responseModel');
    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(responseList);
    print("org person =====>${loginResponseModel.orgPerson}");
    print("org admin =====>${loginResponseModel.orgAdmin}");
    List<dynamic> oP = jsonDecode(loginResponseModel.orgPerson.toString());
    List<dynamic> oA = jsonDecode(loginResponseModel.orgAdmin.toString());

    final proManageVisibility = Provider.of<JoinBtnDropdownBtnProvider>(context,listen: false);
    final setProvider = Provider.of<OrganizationProvider>(context,listen: false);
    if(loginResponseModel.orgPerson!="[]"){
    oP.forEach((element) {
      oPData = OrgNameId.fromJson(element);
      print("orgPerson name---)>${oPData.orgName}");
      margList.add(oPData.orgName.toString());///Add orgPersonName List in margList
       selectedValue = margList[0];//Initial val for dropdown
      finalList = margList;
      proManageVisibility.setString(finalList);
      print("F1---------------->${finalList.length}");
    });}else{}

    if(loginResponseModel.orgAdmin!="[]"){
    oA.forEach((element) {
      oAData = OrgNameId.fromJson(element);
      print("\n orgAdmin name---)>${oAData.orgName}");
      margList.add(oAData.orgName.toString());
      orgAdminList.add(oAData.orgName.toString());

      var seen = Set<String>();
      finalList = margList.where((name) => seen.add(name)).toList();///Remove duplicate data and store in final list
      selectedValue = orgAdminList[0];
      if (selectedValue==orgAdminList[0]) {
        setProvider.setVisible(true);
      } else {
        setProvider.setVisible(false);
      }

      //Initial val for dropdown
      proManageVisibility.setString(finalList);
      print("F2---------------->${finalList.length}");
    });}else{}
    return loginResponseModel;
  }*/

  // Function to show the dialog
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child : Consumer<OrganizationProvider>(
              builder: (context, val, child) {
                return
                  /*DropdownButton<String>(
                  alignment: AlignmentDirectional.bottomEnd,
                  value: selectedValue,
                  items: finalList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontFamily: 'Poppins')),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    selectedValue = newValue!;
                    val.notify();
                    val.setSwitchOrganization(newValue);
                    if (orgAdminList.contains(newValue)) {
                      val.setVisible(true);
                      Navigator.of(context).pop();
                    } else {
                      val.setVisible(false);
                      Navigator.of(context).pop();
                    }
                  },
                );*/
                  ListView.builder(
                    itemCount: finalPersonAdminList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Consumer<OrganizationProvider>(
                            builder: (context,val,child) {
                            return Text(finalPersonAdminList[index].orgName!, style: TextStyle(fontFamily: 'Poppins',color: val.switchOrganization == finalPersonAdminList[index].orgName! ? CustomColors.kBlueColor : null));
                          }
                        ),
                        onTap: () {
                          selectedValue = finalPersonAdminList[index].orgName!;
                          orgId = finalPersonAdminList[index].orgId!;
                          orgAdmin = finalPersonAdminList[index].isAdmin!;
                          val.setSwitchOrganization(selectedValue, orgId, orgAdmin);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
              }
          ),
          /*actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],*/
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text(CustomString.dialogTitle, style: TextStyle(fontFamily: 'Poppins')),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  /// This parameter indicates this action is the default,
                  /// and turns the action's text to bold text.
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(CustomString.dialogNo, style: TextStyle(fontFamily: 'Poppins')),
                ),
                CupertinoDialogAction(
                  /// This parameter indicates the action would perform
                  /// a destructive action such as deletion, and turns
                  /// the action's text color to red.
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(CustomString.dialogYes, style: TextStyle(fontFamily: 'Poppins'))
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.kWhiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Consumer<OrganizationProvider>(
                builder: (context,val,child) {
                    return val.switchOrganization !=null?InkWell(
                      child: Row(
                          children: [
                            Consumer<OrganizationProvider>(
                              builder: (context,val,child) {
                                return Text("${val.switchOrganization}  ", style: const TextStyle(color: CustomColors.kBlueColor, fontSize: 16, fontFamily: 'Poppins'));
                              }
                          ),
                          CircleAvatar(
                            radius: 10,backgroundColor: Colors.transparent,
                            child: SVGIconButton(
                                svgPath: ImagePath.dropdownIcon,
                                size: 6.0,
                                color: CustomColors.kLightGrayColor,
                                onPressed: () async {
                                  await ApiConfig.getDataSwitching(context: context);
                                  checkUser();
                                  _showDialog();
                                }),
                          ),
                        ],
                      ),
                      onTap: () async {
                       await ApiConfig.getDataSwitching(context: context);
                        checkUser();
                      _showDialog();
                      },
                    ): TextButton(
                    onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageOrganization()));
                    }, child: const Text(CustomString.joinOrg, style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')));
                  }
                ),
              const Spacer(),
              /* Consumer<CallSwitchProvider>(builder: (context, val, child) {
                return Switch(value: val.visibleCall,
                  onChanged: (value) {
                    value = val.setVisible();
                  },
                );
              }),
              const SizedBox(width: 10),*/
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return val.isAdmin==true || orgAdmin==true?
                SVGIconButton(
                    svgPath: ImagePath.switchIcon,
                    size: 24.0,
                    color: CustomColors.kBlueColor,
                    // Replace with the path to your SVG asset
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAdminScreen(orgNAME: val.switchOrganization ?? selectedValue!, orgID:val.switchOrgId??orgId!)));
                    }):Container();
              })
            ],
          ),
        ),


       /* appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.kWhiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<JoinBtnDropdownBtnProvider>(builder: (context,val,child) {
                return val.string.isNotEmpty && selectedValue != null?
                InkWell(
                  child: Row(
                      children: [
                        Consumer<OrganizationProvider>(
                          builder: (context,val,child) {
                            return Text("$selectedValue  ",style: const TextStyle(color: CustomColors.kBlueColor,fontSize: 16),);
                          }
                        ),
                        CircleAvatar(
                          radius: 10,backgroundColor: Colors.transparent,
                          child: SVGIconButton(
                              svgPath: ImagePath.dropdownIcon,
                              size: 6.0,
                              color: CustomColors.kLightGrayColor,
                              onPressed: () {
                                _showDialog();
                              }),
                        ),
                      ],
                    ),
                  onTap: (){
                  _showDialog();
                  },
                )
                 : TextButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (
                      context) => const ManageOrganization()));
                }, child: const Text("join Org", style: TextStyle(color: CustomColors.kBlueColor),));
              }),
              const Spacer(),
              *//* Consumer<CallSwitchProvider>(builder: (context, val, child) {
                return Switch(value: val.visibleCall,
                  onChanged: (value) {
                    value = val.setVisible();
                  },
                );
              }),
              const SizedBox(width: 10),*//*
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return val.visible==true?
                SVGIconButton(
                    svgPath: ImagePath.switchIcon,
                    size: 24.0,
                    color: CustomColors.kBlueColor,
                    // Replace with the path to your SVG asset
                    onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManageAdminScreen(
                                title:
                                val.switchOrganization ?? finalList[0])));}):Container();
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAdminScreen(title: val.switchOrganization ?? finalList[0]))
                      );
                    }) : Container();
              })
            ],
          ),
        ),*/
        body: Consumer<ManageBottomTabProvider>(builder: (context, val, child) {
          return PageStorage(
            bucket: bucket,
            child: val.currentScreen,
          );
        }),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          decoration: const BoxDecoration(
            color: CustomColors.kLightColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //Tab bar icons
              materialButton(
                  screen: const DashboardScreen(),
                  context: context,
                  tab: 0,
                  tabTitle: CustomString.dashboard,
                  icon: Icons.dashboard),
              materialButton(
                  screen: const ProjectScreen(),
                  context: context,
                  tab: 1,
                  tabTitle: CustomString.project,
                  icon: Icons.text_snippet_sharp),
              materialButton(
                  screen: const TrainingScreen(),
                  context: context,
                  tab: 2,
                  tabTitle: CustomString.training,
                  icon: Icons.notes_sharp),
              materialButton(
                  screen: const AccountScreen(),
                  context: context,
                  tab: 4,
                  tabTitle: CustomString.account,
                  icon: Icons.person),
            ],
          ),
        ),
      ),
    );
  }
}

Widget materialButton({screen, tab, tabTitle, icon, context}) {
  final provider = Provider.of<ManageBottomTabProvider>(context, listen: false);
  return TextButton(
    onPressed: () {
      provider.manageBottomTab(screen, tab);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Consumer<ManageBottomTabProvider>(builder: (context, val, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: val.currentTab == tab
                    ? CustomColors.kBlueColor
                    : CustomColors.kLightGrayColor,
              ),
              Text(tabTitle,
                  style: TextStyle(
                      color: val.currentTab == tab ? CustomColors.kBlueColor : CustomColors.kLightGrayColor, fontSize: 10, fontFamily: 'Poppins'))
            ],
          );
        }),
      ],
    ),
  );
}
