import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Utils/shared_preference.dart';
import 'home_screen.dart';
import 'package:versa_tribe/extension.dart';

class ManageOrganization extends StatefulWidget {

  const ManageOrganization({super.key});

  @override
  State<ManageOrganization> createState() => _ManageOrganizationState();
}

class _ManageOrganizationState extends State<ManageOrganization> with SingleTickerProviderStateMixin {

  final List<String> margList = [];
  List<String> finalList = [];
  List<String> orgAdminList = [];
  late OrgNameId oPData;
  late OrgNameId oAData;
  String? selectedValue;

  TextEditingController organizationNameController = TextEditingController();
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController requestNewDepartmentController = TextEditingController();

  late TabController _tabController;
  late int orgID;
  int? dpID;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kWhiteColor,
        leading: InkWell(
          child:
          const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
          onTap: () async {
            //Navigator.pop(context);
           await ApiConfig.getDataSwitching(context: context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
          },
        ),
        title: const Text(CustomString.manageOrganization, style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            organizationNameController.text="";
            departmentNameController.text="";
            requestNewDepartmentController.text="";
            joinOrganizationDialog(context: context, mHeight: size.height, mWidth: size.width);
            }, icon: const Icon(Icons.add,color: CustomColors.kBlackColor,))
        ],
      ),
      /// request Button for join org
 /*     floatingActionButton: FloatingActionButton.extended(
        label: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(Icons.add_circle_outline,
                  color: CustomColors.kWhiteColor),
            ),
            Text(
              CustomString.joinOrganization,
              style: TextStyle(color: CustomColors.kWhiteColor),
            )
          ],
        ),
        backgroundColor: CustomColors.kBlueColor,
        onPressed: () {
          joinOrganizationDialog(context: context, mHeight: size.height, mWidth: size.width);
        },
      ),*/
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.02, right: size.height * 0.02),
            child: Consumer<IndexProvider>(builder: (context, val, child) {
              return TabBar(
                onTap: (value) async {
                  val.setIndex(value);
                  if (value == 0) {
                    //ApiConfig.getManageOrgData(context: context, tabIndex: 0);
                  } else {
                    //ApiConfig.getManageOrgData(context: context, tabIndex: 1);
                  }
                },
                isScrollable:true,
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                controller: _tabController,
                labelColor: CustomColors.kBlueColor,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: CustomColors.kBlackColor,
                unselectedLabelStyle: const TextStyle(fontSize: 16, color: CustomColors.kBlackColor, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                tabs: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                          color: CustomColors.kGrayColor),
                      child: const Text(CustomString.requested,style: TextStyle(fontFamily: 'Poppins'))),
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                          color: CustomColors.kGrayColor),
                      child: const Text(CustomString.approved, style: TextStyle(fontFamily: 'Poppins'))),
                ],
              );
            }),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[

               ///Requested
               FutureBuilder(
                            future: ApiConfig.getManageOrgData(context: context, tabIndex: 0),
                            builder: (context,snapshot) {
                              if(snapshot.connectionState==ConnectionState.waiting){
                                return SizedBox(
                                  height: size.height*0.21,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }else if(snapshot.connectionState==ConnectionState.done){
                                return Consumer<DisplayManageOrgProvider>(
                                    builder: (context, val, child) {
                                      return val.requestOrgDataList.isNotEmpty ?
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: val.requestOrgDataList.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: size.height * 0.08,
                                              decoration: const BoxDecoration(
                                                  border: BorderDirectional(
                                                      bottom: BorderSide(width: 0.5),
                                                      top: BorderSide(width: 0.1))
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: size.width * 0.03,
                                                  vertical: size.height * 0.005),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: size.width * 0.7,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Flexible(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                  text: CustomString.requestedToJoin,style: DefaultTextStyle.of(context).style,
                                                                  children: [
                                                                    TextSpan(text: val.requestOrgDataList[index].orgName??"",style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
                                                                  ]
                                                              ),)
                                                        ),
                                                        SizedBox(height: size.height * 0.01),
                                                        Text("${CustomString.requestedDepartment} ${val.requestOrgDataList[index].deptName ?? val.requestOrgDataList[index].deptReq}",
                                                            style: const TextStyle(fontSize: 10, color: CustomColors.kLightGrayColor, fontFamily: 'Poppins')),
                                                      ],
                                                    ),
                                                  ),
                                                  ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CustomColors.kGrayColor),),
                                                      onPressed: () {
                                                        ApiConfig.deleteOrgRequest(context: context,orgID: val.requestOrgDataList[index].orgId,personID:val.requestOrgDataList[index].personId);
                                                      },
                                                      child: const Text(CustomString.cancel, style: TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'))),
                                                ],
                                              ),
                                            );
                                          }) : Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: size.height*0.02,),
                                            SizedBox(height: size.height*0.2,width: size.width/1.5,child: Image.asset(ImagePath.noData,fit: BoxFit.fill,)),
                                            SizedBox(height: size.height*0.2,),
                                            const Text(CustomString.noDataFound,style: TextStyle(color: CustomColors.kLightGrayColor),)
                                          ],),
                                      );
                                    }
                                );
                              }
                              return Container();
                            }
                          ),

               ///Approved
               FutureBuilder(
                      future: ApiConfig.getManageOrgData(context: context, tabIndex: 1),
                      builder: (context,snapshot) {
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return SizedBox(
                          height: size.height*0.21,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }else if(snapshot.connectionState==ConnectionState.done){
                        return Consumer<DisplayManageOrgProvider>(
                            builder: (context, val, child) {
                              return val.approveOrgDataList.isNotEmpty ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: val.approveOrgDataList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: size.height * 0.08,
                                      decoration: const BoxDecoration(
                                          border: BorderDirectional(
                                              bottom: BorderSide(width: 0.5),
                                              top: BorderSide(width: 0.1))
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.03,
                                          vertical: size.height * 0.005),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.7,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                    child: RichText(
                                                      text: TextSpan(
                                                          text: CustomString.requestApproved1,style: DefaultTextStyle.of(context).style,
                                                          children: [
                                                            TextSpan(text: val.approveOrgDataList[index].orgName??"",style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
                                                            const TextSpan(text: CustomString.requestApproved2,style: TextStyle( fontFamily: 'Poppins'))
                                                          ]
                                                      ),)
                                                ),
                                                SizedBox(height: size.height * 0.005),
                                                Text("${CustomString.department} ${val.approveOrgDataList[index].deptName ?? ""}",
                                                    style: const TextStyle(fontSize: 10, color: CustomColors.kLightGrayColor, fontFamily: 'Poppins')),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CustomColors.kGrayColor),),
                                              onPressed: () {
                                                ApiConfig.deleteOrgRequest(context: context,orgID: val.approveOrgDataList[index].orgId,personID:val.approveOrgDataList[index].personId);
                                              },
                                              child: const Text(CustomString.leave, style: TextStyle(color: CustomColors.kBlackColor,  fontFamily: 'Poppins'))),
                                        ],
                                      ),
                                    );
                                  }) : Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: size.height*0.02,),
                                    SizedBox(height: size.height*0.2,width: size.width/1.5,child: Image.asset(ImagePath.noData,fit: BoxFit.fill,)),
                                    SizedBox(height: size.height*0.2,),
                                    const Text(CustomString.noDataFound,style: TextStyle(color: CustomColors.kLightGrayColor),)
                                  ],),
                              );
                            }
                        );
                      }
                        return Container();
                      }
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  data(context) async {
    const String loginUrl = '${ApiConfig.baseUrl}/api/Person/MySessionInfo';
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(CustomString.accessToken);
    var response = await http.post(Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    pref.setJson("responseModel", jsonData);
  }

  Future<void> joinOrganizationDialog({context, mHeight, mWidth}) async {
    final orgProvider = Provider.of<SearchOrgProvider>(context,listen: false);
    final departmentProvider = Provider.of<SearchDepartmentProvider>(context,listen: false);
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Dialog(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    backgroundColor: CustomColors.kWhiteColor,
                    leading: InkWell(
                      child: const Icon(Icons.arrow_back_ios,
                          color: CustomColors.kBlackColor),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: const Text(CustomString.joinOrganization, style: TextStyle(color: CustomColors.kBlueColor,  fontFamily: 'Poppins')),
                    centerTitle: true,
                  ),

                  /// Organization Name text form field
                  Padding(
                    padding: EdgeInsets.only(
                        left: mWidth * 0.02,
                        right: mWidth * 0.02,
                        top: mHeight * 0.05,
                        bottom: mHeight * 0.01),
                    child: TextFormField(
                      controller: organizationNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return CustomString.organizationNameRequired;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if (value != "") {
                          ApiConfig.searchOrg(context: context, orgString: value);
                          orgProvider.orgList.clear();
                        }
                        orgProvider.orgList.clear();
                        orgProvider.setVisible(true);
                      },
                      decoration: InputDecoration(
                        suffixIcon: Padding(
                            padding: EdgeInsets.only(
                                right: mWidth * 0.004,
                                top: mHeight * 0.001,
                                bottom: mHeight * 0.001),
                            child: Image.asset(ImagePath.search, height: 10, width: 10)),
                        fillColor: CustomColors.kWhiteColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: CustomColors.kBlueColor, width: 1)),
                        hintText: CustomString.organizationName,
                        hintStyle: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14, fontFamily: 'Poppins'),
                      ),
                      style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                    ),
                  ),
                  Consumer<SearchOrgProvider>(builder: (context, val, child) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: val.orgList.length,
                        itemBuilder: (context, index) {
                          return val.visible == true? InkWell(
                            child: Card(
                              shadowColor: CustomColors.kBlueColor,
                              elevation: 3,
                              color: CustomColors.kGrayColor,
                              child: Container(
                                  padding: EdgeInsets.only(left: mWidth * 0.02),
                                  height: mHeight * 0.05,
                                  alignment: Alignment.centerLeft,
                                  child: Text('${val.orgList[index].orgName}', style: const TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))),
                            ),
                            onTap: () async {
                              orgID = val.orgList[index].orgId!;
                              organizationNameController.text = val.orgList[index].orgName ?? organizationNameController.text;
                              val.setVisible(false);
                            },
                          ): Container();
                        });
                  }),

                  /// Department Name text form field
                  Padding(
                    padding: EdgeInsets.only(
                        left: mWidth * 0.02,
                        right: mWidth * 0.02,
                        top: mHeight * 0.01,
                        bottom: mHeight * 0.01),
                    child: TextFormField(
                      controller:  departmentNameController,
                      onChanged: (value){
                        requestNewDepartmentController.text="";
                        if (value != "") {
                          ApiConfig.searchDepartment(context: context, orgId: orgID);
                          departmentProvider.departmentList.clear();
                        }
                        departmentProvider.departmentList.clear();
                        departmentProvider.setVisible(true);
                      },
                      validator: (value) {
                        if(requestNewDepartmentController.text == ""){
                          if (value!.isEmpty) {
                            return CustomString.departmentNameRequired;
                          } else {
                            return null;
                          }}else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: CustomColors.kWhiteColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                            const BorderSide(color: CustomColors.kBlueColor)),
                        labelText: CustomString.departmentName,
                        labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                      ),
                      style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                    ),
                  ),
                  Consumer<SearchDepartmentProvider>(builder: (context, val, child) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: val.departmentList.length,
                        itemBuilder: (context, index) {
                          return val.visible == true ? InkWell(
                            child: Card(
                              shadowColor: CustomColors.kBlueColor,
                              elevation: 3,
                              color: CustomColors.kGrayColor,
                              child: Container(
                                  padding:
                                  EdgeInsets.only(left: mWidth * 0.02),
                                  height: mHeight * 0.05,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      '${val.departmentList[index].deptName}',
                                      style: const TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))),
                            ),
                            onTap: () async {
                              dpID = val.departmentList[index].deptId!;
                              departmentNameController.text = val.departmentList[index].deptName ?? departmentNameController.text;
                              val.setVisible(false);
                            },
                          )
                              : Container();
                        });
                  }),

                  const Text('Or',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),

                  /// Request New Department text form field
                  Padding(
                    padding: EdgeInsets.only(
                        left: mWidth * 0.02,
                        right: mWidth * 0.02,
                        top: mHeight * 0.01,
                        bottom: mHeight * 0.01),
                    child: TextFormField(
                      controller: requestNewDepartmentController,
                      onTap: (){
                        departmentNameController.text = "";
                      },
                      decoration: InputDecoration(
                        fillColor: CustomColors.kWhiteColor,
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: CustomColors.kBlueColor),
                            borderRadius: BorderRadius.circular(5)),
                        labelText: CustomString.requestNewDepartment,
                        labelStyle: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 14,  fontFamily: 'Poppins'),
                      ),
                      style: const TextStyle(color: CustomColors.kBlackColor,  fontFamily: 'Poppins'),
                    ),
                  ),

                  /// Elevated Submit Button
                  Padding(
                    padding: EdgeInsets.only(
                        left: mWidth * 0.02,
                        right: mWidth * 0.02,
                        top: mHeight * 0.01,
                        bottom: mHeight * 0.01),
                    child: SizedBox(
                        width: double.infinity,
                        height: mHeight * 0.06,
                        child: ElevatedButton(
                          onPressed: () {
                            String? dpName = requestNewDepartmentController.text;
                            if(formKey.currentState!.validate()) {
                              ApiConfig.joinOrgRequest(context: context,orgID: orgID,dpID: dpID,dpName: dpName);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(CustomColors.kBlueColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(color: CustomColors.kBlueColor)))),
                          child: const Text(CustomString.requestToJoin, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                        )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
