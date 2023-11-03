import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Model/OrgNaneId.dart';
import 'package:versa_tribe/Model/login_response.dart';
import 'package:versa_tribe/Providers/organization_provider.dart';
import 'package:versa_tribe/Screens/Home/dashboard_screen.dart';
import 'package:versa_tribe/Screens/Home/project_screen.dart';
import 'package:versa_tribe/Screens/Home/training_screen.dart';
import '../Providers/bottom_tab_provider.dart';
import '../Providers/login_data_provider.dart';
import '../Utils/custom_colors.dart';
import '../Utils/custom_string.dart';
import 'Home/account_screen.dart';
import 'OrgAdmin/admin_manage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageStorageBucket bucket = PageStorageBucket();

  final List<String> orgAd = [];
  final List<String> margList = [];
  List<String> finalList = [];
  dynamic pro;
  late LoginResponseModel loginData;
  late OrgNameId oPData;
  late OrgNameId oAData;
  late String selectedOrg;

  @override
  void initState() {
    // TODO: implement initState
    pro = Provider.of<LoginDataProvider>(context, listen: false);
    loginData = pro.loginData;
    List<dynamic> oP = jsonDecode(loginData.orgPerson.toString());
    List<dynamic> oA = jsonDecode(loginData.orgAdmin.toString());
    oP.forEach((element) {
      oPData = OrgNameId.fromJson(element);
      print("orgPerson name---)>${oPData.orgName}");
      margList.add(oPData.orgName.toString());///Add orgPersonName List in margList
    });
    oA.forEach((element) {
      oAData = OrgNameId.fromJson(element);
      print("\norgAdmin name---)>${oAData.orgName}");
      margList.add(oAData.orgName.toString());
      orgAd.add(oAData.orgName.toString());///Add orgAdminName List in margList

      var seen = Set<String>();
      finalList = margList.where((name) => seen.add(name)).toList();

      ///Remove duplicate data and store in final list
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*   print("CHECK------->${loginData.orgPerson.runtimeType}");
    List<dynamic> oP=jsonDecode(loginData.orgPerson.toString());
    oP.forEach((element) {
      data = OrgNameId.fromJson(element);
      print("single name---)>${data.orgName}");
    });
    print("type---)>${oP[1].runtimeType}");
    print("org person list---)>$oP");
    print("single name---)>${oP[1]["Org_Name"]}");*/
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text(CustomString.dialogTitle),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  /// This parameter indicates this action is the default,
                  /// and turns the action's text to bold text.
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(CustomString.dialogNo),
                ),
                CupertinoDialogAction(
                  /// This parameter indicates the action would perform
                  /// a destructive action such as deletion, and turns
                  /// the action's text color to red.
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(CustomString.dialogYes),
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
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton(
                    alignment: Alignment.centerLeft,
                    iconEnabledColor: CustomColors.kBlueColor,
                    iconDisabledColor: CustomColors.kBlackColor,
                    value: val.switchOrganization ?? finalList[0],
                    items: finalList.map((organization) {
                      selectedOrg = finalList[0];
                      return DropdownMenuItem(
                        value: organization,
                        child: Text(organization,
                            style: const TextStyle(
                                color: CustomColors.kBlueColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      selectedOrg = newValue!;
                      debugPrint("selected-------)> $newValue");
                      val.setSwitchOrganization(newValue);
                      if (orgAd.contains(newValue)) {
                        val.setVisible(true);
                      } else {
                        val.setVisible(false);
                      }
                    },
                    hint: Text(val.switchOrganization ?? finalList[0],
                        style: const TextStyle(
                            color: CustomColors.kBlueColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              }),
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
                return val.visible==true?IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageAdminScreen(
                                  title:
                                      val.switchOrganization ?? finalList[0])));
                    },
                    icon: const Icon(Icons.account_balance),
                    color: CustomColors.kBlueColor):Container();
              })
            ],
          ),
        ),
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
          // margin: const EdgeInsets.all(20),
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
                  screen: const ProjectScreen(),
                  context: context,
                  tab: 3,
                  tabTitle: CustomString.message,
                  icon: Icons.message_outlined),
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
                      color: val.currentTab == tab
                          ? CustomColors.kBlueColor
                          : CustomColors.kLightGrayColor,
                      fontSize: 10))
            ],
          );
        }),
      ],
    ),
  );
}
