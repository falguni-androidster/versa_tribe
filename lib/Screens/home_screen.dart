import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Providers/bottom_tab_provider.dart';
import 'package:versa_tribe/Providers/organization_provider.dart';
import 'package:versa_tribe/Providers/switch_provider.dart';
import 'package:versa_tribe/Screens/Home/dashboard_screen.dart';
import 'package:versa_tribe/Screens/Home/project_screen.dart';
import 'package:versa_tribe/Screens/Home/training_screen.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import '../Model/SwitchDataModel.dart';
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

  List<OrgAdminPersonList> finalPersonAdminList = [];

  String? selectedValue;
  int? orgId;
  bool? orgAdmin;

  @override
  initState() {
    setInitialValue();
    super.initState();
  }

  setInitialValue() async {
    final selectedOrgProvider =
        Provider.of<OrganizationProvider>(context, listen: false);
    final switchProvider = Provider.of<SwitchProvider>(context, listen: false);
    await ApiConfig.getDataSwitching(context: context);
    List<OrgAdminPersonList> adminPersonList =
        switchProvider.switchData.orgAdminPersonList!;
    selectedValue = adminPersonList[0].orgName!;
    orgId = adminPersonList[0].orgId!;
    orgAdmin = adminPersonList[0].isAdmin!;
    finalPersonAdminList = adminPersonList;
    await selectedOrgProvider.setSwitchOrganization(
        selectedValue, orgId, orgAdmin);
    return adminPersonList;
  }

  checkUser() async {
    final switchProvider = Provider.of<SwitchProvider>(context, listen: false);
    List<OrgAdminPersonList> adminPersonList =
        switchProvider.switchData.orgAdminPersonList!;
    //print("----->SWITCH DATA--->${adminPersonList[0].orgName}");
    selectedValue = adminPersonList[0].orgName!;
    orgId = adminPersonList[0].orgId!;
    orgAdmin = adminPersonList[0].isAdmin!;
    finalPersonAdminList = adminPersonList;
    return adminPersonList;
  }

  // Function to show the dialog
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * 0.075,
                child: Scaffold(
                  appBar: AppBar(
                    iconTheme: const IconThemeData(color: CustomColors.kBlackColor),
                    backgroundColor: CustomColors.kGrayColor,
                    elevation: 0,
                    title: const Text(
                      CustomString.switchOrganization,
                      style: TextStyle(color: CustomColors.kBlueColor),
                    ),
                  ),
                ),
              ),
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return ListView.builder(
                  itemCount: finalPersonAdminList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                            height: size.height * 0.05,
                            child: Card(
                                color: val.switchOrganization == finalPersonAdminList[index].orgName! ? CustomColors.kBlueColor : CustomColors.kGrayColor,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(" ${finalPersonAdminList[index].orgName!}",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: val.switchOrganization == finalPersonAdminList[index].orgName! ? CustomColors.kWhiteColor : null))
                                )
                            )
                        ),
                      onTap: () {
                        selectedValue = finalPersonAdminList[index].orgName!;
                        orgId = finalPersonAdminList[index].orgId!;
                        orgAdmin = finalPersonAdminList[index].isAdmin!;
                        val.setSwitchOrganization(
                            selectedValue, orgId, orgAdmin);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenIndexProvider = Provider.of<ManageBottomTabProvider>(context);
    int currentScreenIndex = screenIndexProvider.currentTab;
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text(CustomString.dialogTitle,
                  style: TextStyle(fontFamily: 'Poppins')),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  /// This parameter indicates this action is the default,
                  /// and turns the action's text to bold text.
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(CustomString.dialogNo,
                      style: TextStyle(fontFamily: 'Poppins')),
                ),
                CupertinoDialogAction(

                    /// This parameter indicates the action would perform
                    /// a destructive action such as deletion, and turns
                    /// the action's text color to red.
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text(CustomString.dialogYes,
                        style: TextStyle(fontFamily: 'Poppins'))),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shadowColor: CustomColors.kBlackColor,
          elevation: 6,
          backgroundColor: CustomColors.kWhiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return val.switchOrganization != null
                    ? InkWell(
                        child: Row(
                          children: [
                            Consumer<OrganizationProvider>(
                                builder: (context, val, child) {
                              return Text("${val.switchOrganization}  ",
                                  style: const TextStyle(
                                      color: CustomColors.kBlueColor,
                                      fontSize: 16,
                                      fontFamily: 'Poppins'));
                            }),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.transparent,
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
                      )
                    : TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageOrganization()));
                        },
                        child: const Text(CustomString.joinOrg,
                            style: TextStyle(
                                color: CustomColors.kBlueColor,
                                fontFamily: 'Poppins')));
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
                return val.isAdmin == true || orgAdmin == true
                    ? SVGIconButton(
                        svgPath: ImagePath.switchIcon,
                        size: 24.0,
                        color: CustomColors.kBlueColor,
                        // Replace with the path to your SVG asset
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAdminScreen(orgNAME: val.switchOrganization ?? selectedValue!, orgID: val.switchOrgId ?? orgId!)));
                        })
                    : Container();
              })
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: NavigationBar(
            onDestinationSelected: (int index) {
              screenIndexProvider.manageBottomTab(index);
            },
            elevation: 10,
            shadowColor: CustomColors.kBlackColor,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            backgroundColor: CustomColors.kWhiteColor,
            indicatorColor: CustomColors.kPrimaryColor,
            selectedIndex: currentScreenIndex,
            destinations: <Widget>[
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.dashboard, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.dashboard, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                  label: CustomString.dashboard),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.project, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.project, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                  label: CustomString.project),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.training, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.training, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                  label: CustomString.training),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.messenger, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.messenger, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                  label: CustomString.messenger),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                  label: CustomString.account),
            ],
          ),
        ),
        body: <Widget>[
          const DashboardScreen(),
          const ProjectScreen(),
          const TrainingScreen(),
          const ProjectScreen(),
          const AccountScreen()
        ][currentScreenIndex]
      ),
    );
  }
}
