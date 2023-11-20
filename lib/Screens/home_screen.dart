import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Model/OrgNaneId.dart';
import 'package:versa_tribe/Model/login_response.dart';
import 'package:versa_tribe/Providers/manage_visibility_btn.dart';
import 'package:versa_tribe/Providers/organization_provider.dart';
import 'package:versa_tribe/Screens/Home/dashboard_screen.dart';
import 'package:versa_tribe/Screens/Home/project_screen.dart';
import 'package:versa_tribe/Screens/Home/training_screen.dart';
import 'package:versa_tribe/Utils/shared_preference.dart';
import '../Providers/bottom_tab_provider.dart';
import '../Utils/custom_colors.dart';
import '../Utils/custom_string.dart';
import '../Utils/image_path.dart';
import '../Utils/svg_btn.dart';
import 'Home/account_screen.dart';
import 'OrgAdmin/admin_manage.dart';
import 'manage_organization_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final PageStorageBucket bucket = PageStorageBucket();

  final List<String> margList = [];
  List<String> finalList = [];
  List<String> orgAdminList = [];
  late OrgNameId oPData;
  late OrgNameId oAData;
  String? selectedValue;

  int currentPageIndex = 0;

  @override
  initState() {
    checkUser(context);
    super.initState();
  }

  checkUser(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic>? responseList = prefs.getJson('responseModel');
    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(responseList);
    print("org person =====>${loginResponseModel.orgPerson}");
    print("org admin =====>${loginResponseModel.orgAdmin}");

    List<dynamic> orgPerson = jsonDecode(loginResponseModel.orgPerson.toString()); //jsonDecode for remove string
    List<dynamic> orgAdmin = jsonDecode(loginResponseModel.orgAdmin.toString());

    final proManageVisibility = Provider.of<JoinBtnDropdownBtnProvider>(context, listen: false);
    final setProvider = Provider.of<OrganizationProvider>(context, listen: false);
    if (loginResponseModel.orgPerson != "[]") {
      for (var element in orgPerson) {
        oPData = OrgNameId.fromJson(element);
        print("orgPerson name---)>${oPData.orgName}");
        margList.add(
            oPData.orgName.toString()); //Add orgPersonName List in margList
        selectedValue = margList[0]; //Initial val for dropdown
        finalList = margList;
        proManageVisibility.setString(finalList);
        print("F1---------------->${finalList.length}");
      }
    }

    if (loginResponseModel.orgAdmin != "[]") {
      for (var element in orgAdmin) {
        oAData = OrgNameId.fromJson(element);
        print("\n orgAdmin name---)>${oAData.orgName}");
        margList.add(oAData.orgName.toString());
        orgAdminList.add(oAData.orgName.toString());

        var seen = <String>{};
        finalList = margList.where((name) => seen.add(name)).toList(); //Remove duplicate data and store in final list
        selectedValue = orgAdminList[0];
        if (selectedValue == orgAdminList[0]) {
          setProvider.setVisible(true);
        } else {
          setProvider.setVisible(false);
        }

        //Initial val for dropdown
        proManageVisibility.setString(finalList);
        print("F2---------------->${finalList.length}");
      }
    }

    return loginResponseModel;
  }

  // Function to show the dialog
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("KL===>$selectedValue");
        return AlertDialog(
          content:
              Consumer<OrganizationProvider>(builder: (context, val, child) {
            return DropdownButton<String>(
              alignment: AlignmentDirectional.bottomEnd,
              value: selectedValue,
              items: finalList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
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
            );
          }),
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
              Consumer<JoinBtnDropdownBtnProvider>(
                  builder: (context, val, child) {
                print("Test String join org----->${val.string}");
                return val.string.isNotEmpty && selectedValue != null
                    ? Row(
                        children: [
                          Consumer<OrganizationProvider>(
                              builder: (context, val, child) {
                            return Text(
                              "$selectedValue  ",
                              style: const TextStyle(
                                  color: CustomColors.kBlueColor, fontSize: 16, fontFamily: 'Poppins'),
                            );
                          }),
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.transparent,
                            child: SVGIconButton(
                                svgPath: ImagePath.dropdownIcon,
                                size: 6.0,
                                color: CustomColors.kLightGrayColor,
                                // Replace with the path to your SVG asset
                                onPressed: () {
                                  _showDialog();
                                }),
                          ),
                        ],
                      )
                    : TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManageOrganization()));
                        },
                        child: const Text(
                          CustomString.joinOrg,
                          style: TextStyle(color: CustomColors.kBlueColor, fontSize: 16, fontFamily: 'Poppins'),
                        ));
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
                return val.visible == true
                    ? SVGIconButton(
                        svgPath: ImagePath.switchIcon,
                        size: 24.0,
                        color: CustomColors.kBlueColor,
                        // Replace with the path to your SVG asset
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ManageAdminScreen(
                                      title: val.switchOrganization ??
                                          finalList[0])));
                        })
                    : Container();
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
                  screen: const AccountScreen(),
                  context: context,
                  tab: 4,
                  tabTitle: CustomString.account,
                  icon: Icons.person),
            ],
          ),
        ),
        /*bottomNavigationBar: Card(
          margin: const EdgeInsets.all(10.0),
          elevation: 5,
          child: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            height: 70,
            backgroundColor: CustomColors.kWhiteColor,
            indicatorColor: CustomColors.kGrayColor,
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.dashboard_customize,color: CustomColors.kBlueColor),
                icon: Icon(Icons.dashboard_customize_outlined,color: CustomColors.kLightGrayColor),
                label: CustomString.dashboard,
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.text_snippet_sharp,color: CustomColors.kBlueColor),
                icon: Icon(Icons.text_snippet_outlined,color: CustomColors.kLightGrayColor),
                label: CustomString.project,
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.notes_sharp,color: CustomColors.kBlueColor),
                icon: Icon(Icons.notes_outlined,color: CustomColors.kLightGrayColor),
                label: CustomString.training,
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.person,color: CustomColors.kBlueColor),
                icon: Icon(Icons.person_outline,color: CustomColors.kLightGrayColor),
                label: CustomString.training,
              ),
            ],
          ),
        ),
        body: <Widget>[
          const DashboardScreen(),
          const ProjectScreen(),
          const TrainingScreen(),
          const AccountScreen()
        ][currentPageIndex],*/
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
              Icon(icon, color: val.currentTab == tab ? CustomColors.kBlueColor : CustomColors.kLightGrayColor),
              Text(tabTitle, style: TextStyle(color: val.currentTab == tab ? CustomColors.kBlueColor : CustomColors.kLightGrayColor, fontSize: 10, fontFamily: 'Poppins'))
            ],
          );
        }),
      ],
    ),
  );
}
