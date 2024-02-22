import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:versa_tribe/Model/CallCredentialModel.dart';
import 'package:versa_tribe/Screens/Home/dashboard_screen.dart';
import 'package:versa_tribe/Screens/Home/project_screen.dart';
import 'package:versa_tribe/Screens/Home/training_screen.dart';
import 'package:versa_tribe/Utils/notification_service.dart';
import '../Utils/svg_btn.dart';
import 'Home/account_screen.dart';
import 'org_admin_manage.dart';
import 'manage_organization_screen.dart';
import 'package:versa_tribe/extension.dart';

class HomeScreen extends StatefulWidget {
  final String? from;
  final bool? popUp;
  final SIPUAHelper? helper;
  const HomeScreen({super.key, this.from, this.popUp, this.helper});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> implements SipUaHelperListener{

  List<OrgAdminPersonList> orgAdminPersonList = [];
  String? selectedValue;
  int? orgId;
  bool? orgAdmin;
  late SharedPreferences pref;

  SIPUAHelper? get helper => widget.helper;
  @override
  initState() {
    // print("----------registered-------init-state--->${helper!.registered}---------|");
    // print("----------connecting-------init-state--->${helper!.connecting}---------|");
    // print("----------connected-------init-state--->${helper!.connected}-----------|");
    // print("----------runtimeType-------init-state--->${helper!.runtimeType}-------|");
    setInitialValue(context);
    super.initState();
    helper!.addSipUaHelperListener(this);
  }

  @override
  void dispose() {
    apiConfig.getCallCredential(orgID: orgId,action: "Remove");
    super.dispose();
  }
  @override
  void deactivate() {
    debugPrint("-----------------deactivate-------------");
    super.deactivate();
    helper!.removeSipUaHelperListener(this);
    apiConfig.getCallCredential(orgID: orgId,action: "Remove");
  }

  void _handleSave(BuildContext context, CallCredentialModel v) {
    UaSettings settings = UaSettings();
    settings.webSocketUrl = 'wss://${v.serverDomain}:4443/ws';
    settings.webSocketSettings.allowBadCertificate = true;
    settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';

    settings.uri = '${v.extensionSrvId}@${v.serverDomain}';
    settings.authorizationUser = v.extensionSrvId;
    settings.password = v.secret;
    settings.displayName = v.userName;
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;

    helper!.start(settings);
    debugPrint("Home Screen -------helper-connected:--->${helper!.connected}");
    debugPrint("Home Screen -------helper-registerState index:--->${helper!.registerState.state?.index}");
    debugPrint("Home Screen -------helper-registerState status-code:--->${helper!.registerState.cause?.status_code}");
    //debugPrint("Home Screen -------helper-registerState :--->${helper!.registerState.cause?.cause}");
    //debugPrint("Home Screen -------helper-registerState :--->${helper!.registerState.cause?.reason_phrase}");
    debugPrint("Home Screen -------helper-is connecting?:--->${helper!.connecting}");
    debugPrint("Home Screen -------helper-is registered?:--->${helper!.registered}");
  }

  setInitialValue(context) async {
    pref = await SharedPreferences.getInstance();
    final selectedOrgProvider = Provider.of<OrganizationProvider>(context, listen: false);
    final switchProvider = Provider.of<SwitchProvider>(context, listen: false);
    await apiConfig.getDataSwitching(context: context);
    List<OrgAdminPersonList> adminPersonList = switchProvider.switchData.orgAdminPersonList!;
    if(adminPersonList.isNotEmpty) {
      selectedValue = adminPersonList[0].orgName!;
      orgId = adminPersonList[0].orgId!;
      orgAdmin = adminPersonList[0].isAdmin!;
      orgAdminPersonList = adminPersonList;
      pref.getSharedPrefStringValue(key: CustomString.organizationName) == adminPersonList[0].orgName! || pref.getSharedPrefStringValue(key: CustomString.organizationName) == null ?
      await selectedOrgProvider.setSwitchOrganization(selectedValue, orgId, orgAdmin) :
      await selectedOrgProvider.setSwitchOrganization(pref.getSharedPrefStringValue(key: CustomString.organizationName), pref.getSharedPrefIntValue(key: CustomString.organizationId), pref.getSharedPrefBoolValue(key: CustomString.organizationAdmin));
      print("POPUP---<><><>-->${widget.popUp}");
      if(widget.popUp == true &&  selectedOrgProvider.switchOrganization != null){
        _showDialog();
      }
    }
    return adminPersonList;
  }
  checkUser() async {
    final switchProvider = Provider.of<SwitchProvider>(context, listen: false);
    List<OrgAdminPersonList> adminPersonList = switchProvider.switchData.orgAdminPersonList!;
    if(adminPersonList.isNotEmpty) {
      //selectedValue = adminPersonList[0].orgName!;
      orgId = adminPersonList[0].orgId!;
      orgAdmin = adminPersonList[0].isAdmin!;
      orgAdminPersonList = adminPersonList;
    }
    return adminPersonList;
  }
  manageOrganization({context, val, finalPersonAdminList}) async{
    await pref.setSharedPrefStringValue(key: CustomString.organizationName, finalPersonAdminList.orgName!);
    await pref.setSharedPrefBoolValue(key: CustomString.organizationAdmin, finalPersonAdminList.isAdmin!);
    await pref.setSharedPrefIntValue(key: CustomString.organizationId, finalPersonAdminList.orgId!);
    selectedValue = pref.getSharedPrefStringValue(key: CustomString.organizationName);
    orgAdmin = pref.getSharedPrefBoolValue(key: CustomString.organizationAdmin);
    orgId = pref.getSharedPrefIntValue(key: CustomString.organizationId);
    val.setSwitchOrganization(selectedValue, orgId, orgAdmin);
    Navigator.of(context).pop();

    FBroadcast.instance().broadcast("Key_Message", value: orgId);
  }

  /// Function to show the dialog
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * 0.055,
                child: Scaffold(
                  appBar: AppBar(
                    iconTheme: const IconThemeData(color: CustomColors.kBlackColor),
                    backgroundColor: CustomColors.kGrayColor,
                    elevation: 0,
                    toolbarHeight: 40,
                    title: const Text(
                      CustomString.switchOrganization,
                      style: TextStyle(color: CustomColors.kBlueColor,fontSize: 14,fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ),
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return Container(
                  color: CustomColors.kWhiteColor,
                  padding: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01, bottom: size.height * 0.01),
                  child: ListView.builder(
                    itemCount: orgAdminPersonList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          child: SizedBox(
                              height: size.height * 0.05,
                              child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  color: val.switchOrganization == orgAdminPersonList[index].orgName! ? CustomColors.kBlueColor : CustomColors.kGrayColor,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(" ${orgAdminPersonList[index].orgName!}",
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(fontFamily: 'Poppins', color: val.switchOrganization == orgAdminPersonList[index].orgName! ? CustomColors.kWhiteColor : null))
                                  )
                              )
                          ),
                        onTap: () => manageOrganization(context: context, val: val, finalPersonAdminList: orgAdminPersonList[index])
                      );
                    },
                  ),
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
    final size= MediaQuery.of(context).size;
    final screenIndexProvider = Provider.of<ManageBottomTabProvider>(context);
    int currentScreenIndex = screenIndexProvider.currentTab;
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text(CustomString.dialogTitle, style: TextStyle(fontFamily: 'Poppins')),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(CustomString.dialogNo, style: TextStyle(fontFamily: 'Poppins')),
                ),
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text(CustomString.dialogYes, style: TextStyle(fontFamily: 'Poppins'))),
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
                return val.switchOrganization?.length != null ? InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height * 0.01, bottom: size.height * 0.01, right: size.width * 0.01),
                    child: Row(
                      children: [
                        Text("${val.switchOrganization}  ",
                            style: const TextStyle(color: CustomColors.kBlueColor, fontSize: 16, fontFamily: 'Poppins')),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.transparent,
                          child: SVGIconButton(
                              svgPath: ImagePath.dropdownIcon, size: 6.0, color: CustomColors.kLightGrayColor,
                              onPressed: () async {
                                await apiConfig.getDataSwitching(context: context);
                                checkUser();
                                _showDialog();
                              }),
                        )],
                    ),
                  ),
                  onTap: () async {
                    await apiConfig.getDataSwitching(context: context);
                    checkUser();
                    _showDialog();
                    }) :
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageOrganization()));
                      },
                    child: const Text(CustomString.joinOrg,
                        style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')
                    )
                );
              }),
              const Spacer(),
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return val.isAdmin==true || orgAdmin== true
                    ? SVGIconButton(svgPath: ImagePath.switchIcon, size: 24.0, color: CustomColors.kBlueColor,
                        // Replace with the path to your SVG asset
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAdminScreen(orgNAME: val.switchOrganization ?? selectedValue!, orgID: val.switchOrgId ?? orgId!)));
                        })
                    : Container();
              }),
              SizedBox(width: size.width * 0.02),
              Consumer<CallSwitchProvider>(
                builder: (context,val,child) {
                  return CupertinoSwitch(
                    value: val.Switch,
                    onChanged: (value) async {
                      val.callSwitch(value);
                      if(val.Switch==true){
                        //NotificationServices().showNotification(title: "Calling", body: "1471471470");//testing purpose
                        apiConfig.getCallCredential(orgID: orgId,action: "").then((value) async {
                          _handleSave(context,value);
                          await Permission.microphone.request();
                          //await Permission.camera.request();
                        });
                        debugPrint("call-switch-value-->$value");
                        // _handleSave(context);
                      }
                      else{
                        //NotificationServices().removeNotification(0); //testing purpose
                        debugPrint("call-switch-value-->$value");
                        await apiConfig.getCallCredential(orgID: orgId,action: "Remove");
                        helper!.unregister(true);
                      }
                    },
                  );
                }
              ),
            ],
          ),
        ),
        ///Bottom navigation bar 1
        bottomNavigationBar: defaultTargetPlatform == TargetPlatform.iOS? NavigationBar(
          onDestinationSelected: (int index) {
            screenIndexProvider.manageBottomTab(index);
          },
          elevation: 10,
          height: size.height * 0.07,
          shadowColor: CustomColors.kLightGrayColor,
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
                selectedIcon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                icon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                label: CustomString.account),
          ],
        ):
        Card(
          elevation: 3,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(bottom: size.height * 0.02, left: size.width * 0.03, right: size.width * 0.03),
          child: NavigationBar(
            onDestinationSelected: (int index) {
              screenIndexProvider.manageBottomTab(index);
            },
            animationDuration: const Duration(seconds: 1),
            elevation: 3,
            height: size.height * 0.1,
            shadowColor: CustomColors.kLightGrayColor,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            backgroundColor: CustomColors.kWhiteColor,
            indicatorColor: CustomColors.kPrimaryColor,
            selectedIndex: currentScreenIndex,
            destinations: <Widget>[
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.dashboard, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.dashboard, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor, BlendMode.srcIn)),
                  label: CustomString.dashboard),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.project, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.project, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor, BlendMode.srcIn)),
                  label: CustomString.project),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.training, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.training, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor, BlendMode.srcIn)),
                  label: CustomString.training),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor, BlendMode.srcIn)),
                  label: CustomString.account),
            ],
          ),
        ),

        body: <Widget>[
          ///DashBoard(Home) TAB
          const DashboardScreen(),
          ///Project TAB
          Consumer<OrganizationProvider>(
            builder: (context,val,child) {
              return ProjectScreen(orgId: val.switchOrgId);
            }
          ),
          ///Training TAB
          Consumer<OrganizationProvider>(
          builder: (context,val,child) {
              return TrainingScreen(orgId: val.switchOrgId);
            }
          ),
          ///AccountScreen TAB
          const AccountScreen()
        ][currentScreenIndex]
      ),
    );
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    //print("RegistrationState:------------)->${state.state.hashCode}");
    debugPrint("RegistrationState:->status-code-----------)->${state.cause?.status_code}");
    debugPrint("RegistrationState:->cause-----------)->${state.cause}");
  }
  // @override
  // void callStateChanged(Call call, CallState callState) {
  //   debugPrint("---callAudioState--------------> ${callState.audio} <---");
  //   if(callState.state == CallStateEnum.CALL_INITIATION){
  //     debugPrint(">${callState.state}----Call-Incoming--------------->-->${CallStateEnum.CALL_INITIATION}");
  //     Navigator.pushNamed(context, '/callscreen', arguments: call);
  //     NotificationServices().showNotification(title: "Calling", body: call.remote_display_name);
  //   }
  //   else if(callState.state == CallStateEnum.ENDED){
  //   debugPrint(">>----Call Disconnected------------->-->${CallStateEnum.ENDED}");
  //   }
  // }

  @override
  void callStateChanged(Call call, CallState callState) {
    debugPrint("---callAudioState--------------> ${callState.audio} <---");

    // Check for incoming call initiation
    if(callState.state == CallStateEnum.CALL_INITIATION){
      debugPrint(">${callState.state}----Call-Incoming--------------->-->${CallStateEnum.CALL_INITIATION}");

      // Navigate to the call screen when an incoming call is detected
      Navigator.pushNamed(context, '/callscreen', arguments: call);

      // Show a notification for the incoming call
      NotificationServices().showNotification(title: "Incoming Call", body: call.remote_display_name);
    }

    // Check for call ended
    else if(callState.state == CallStateEnum.ENDED || callState.state == CallStateEnum.FAILED){
      debugPrint(">>----Call Disconnected------------->-->${CallStateEnum.ENDED}");
      NotificationServices().removeNotification(0);

      // Add any additional logic you want to perform when the call ends
    }

    // Add other conditions as needed for different call states

    // Optionally, you can handle other call states here with additional 'else if' conditions

    // For debugging, you can print the call state
    debugPrint(">>----Call State------------->-->${callState.state}");
  }


  @override
  void transportStateChanged(TransportState state) {
    debugPrint("TransportStateChanged->name----)->${state.state.name}");
    debugPrint("TransportStateChanged->state----)->${state.state}");
  }
  @override
  void onNewMessage(SIPMessageRequest msg) {
    debugPrint("SIPMessage-----)->$msg");
  }
  @override
  void onNewNotify(Notify notify) {
    debugPrint("onNewNotify-->call_id----)->${notify.request!.call_id}");
  }
}
