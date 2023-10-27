import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Providers/organization_provider.dart';
import 'package:versa_tribe/Screens/Home/dashboard_screen.dart';
import 'package:versa_tribe/Screens/Home/project_screen.dart';
import 'package:versa_tribe/Screens/Home/training_screen.dart';

import '../Providers/bottom_tab_provider.dart';
import '../Providers/call_switch_provider.dart';
import '../Utils/custom_colors.dart';
import '../Utils/custom_string.dart';
import 'Home/account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final PageStorageBucket bucket = PageStorageBucket();

  final List<String> _organizationList = ['ParaFox','CRM-IT','ABIDE']; // Option 2
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
                    Navigator.pop(context,false);
                  },
                  child: const Text(CustomString.dialogNo),
                ),
                CupertinoDialogAction(
                  /// This parameter indicates the action would perform
                  /// a destructive action such as deletion, and turns
                  /// the action's text color to red.
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context,true);
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
          leadingWidth: 0,
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.kWhiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return DropdownButtonHideUnderline(
                  child : ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      iconEnabledColor: CustomColors.kBlueColor,
                      iconDisabledColor: CustomColors.kBlueColor,
                      value: val.switchOrganization,
                      items: _organizationList.map((organization) {
                        return DropdownMenuItem(
                          value: organization,
                          child: Text(organization,style: const TextStyle(color: CustomColors.kBlueColor,fontSize: 20,fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        print("-------)> $newValue");
                        val.setSwitchOrganization(newValue);
                      },
                      hint: Text(val.switchOrganization,style: const TextStyle(color: CustomColors.kBlueColor,fontSize: 20,fontWeight: FontWeight.bold)),
                    ),
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
              InkWell(
                child: const Icon(Icons.account_balance,
                    color: CustomColors.kBlueColor),
                onTap: (){},
              )
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
          height: 60,
          decoration: const BoxDecoration(
            color: CustomColors.kLightColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: const EdgeInsets.all(20),
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
              Icon(icon,
                color: val.currentTab == tab
                    ? CustomColors.kBlueColor
                    : CustomColors.kLightGrayColor,
              ),
              Text(tabTitle,style: TextStyle(color: val.currentTab == tab
              ? CustomColors.kBlueColor
                  : CustomColors.kLightGrayColor,fontSize: 10))
            ],
          );
        }),
      ],
    ),
  );
}
