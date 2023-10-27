import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Utils/api_config.dart';
import '../Providers/manage_org_index_provider.dart';
import '../Utils/custom_colors.dart';
import '../Utils/custom_string.dart';
import '../Utils/image_path.dart';

class ManageOrganization extends StatefulWidget {
  const ManageOrganization({super.key});
  @override
  State<ManageOrganization> createState() => _ManageOrganizationState();
}

class _ManageOrganizationState extends State<ManageOrganization>with SingleTickerProviderStateMixin {

  TextEditingController organizationNameController = TextEditingController();
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController requestNewDepartmentController = TextEditingController();

  // define your tab controller here
  late TabController _tabController;

  @override
  void initState() {
    // initialise your tab controller here
    _tabController = TabController(length: 4, vsync: this);
    ApiConfig.getManageOrgData(context: context, tabIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery
        .of(context)
        .size
        .height;
    final mWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kWhiteColor,
        leading: InkWell(
          child:
          const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(CustomString.manageOrganization,
            style: TextStyle(color: CustomColors.kBlueColor)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
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
          joinOrganizationDialog(
              context: context, mHeight: mHeight, mWidth: mWidth);
        },
      ),
      body: Column(
        children: <Widget>[
          Padding(
            //padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            padding: EdgeInsets.only(
                top: mHeight * 0.02,
                left: mWidth * 0.02,
                right: mHeight * 0.02),
            child: Consumer<IndexProvider>(builder: (context, val, child) {
              return TabBar(
                onTap: (value) {
                  val.setIndex(value);
                  if (value == 0) {
                    ApiConfig.getManageOrgData(context: context, tabIndex: 0);
                  } else if (value == 1) {
                    ApiConfig.getManageOrgData(context: context, tabIndex: 1);
                  } else if (value == 2) {
                    ApiConfig.getManageOrgData(context: context, tabIndex: 2);
                  } else if (value == 3) {
                    ApiConfig.getManageOrgData(context: context, tabIndex: 3);
                  }
                },
                isScrollable:true,
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                controller: _tabController,
                labelColor: CustomColors.kBlueColor,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: CustomColors.kBlackColor,
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  color: CustomColors.kBlackColor,
                  fontWeight: FontWeight.w400,
                ),
                labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                tabs: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                          color: CustomColors.kGrayColor),
                      child: const Text(CustomString.requested)),
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                          color: CustomColors.kGrayColor),
                      child: const Text(CustomString.approved)),
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                          color: CustomColors.kGrayColor),
                      child: const Text(CustomString.rejected)),
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                          color: CustomColors.kGrayColor),
                      child: const Text(CustomString.removed)),
                ],
              );
            }),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[

                ///Requested
                Consumer<DisplayManageOrgProvider>(
                    builder: (context, val, child) {
                      return val.manageOrgDataList.isNotEmpty ? ListView
                          .builder(
                          shrinkWrap: true,
                          itemCount: val.manageOrgDataList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: mHeight * 0.08,
                              decoration: const BoxDecoration(
                                  border: BorderDirectional(
                                      bottom: BorderSide(width: 0.5),
                                      top: BorderSide(width: 0.1))
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: mWidth * 0.03,
                                  vertical: mHeight * 0.005),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Text(CustomString.requestedToJoin),
                                          Text(val.manageOrgDataList[index].orgName ?? "",
                                              style: const TextStyle(
                                                  color: CustomColors
                                                      .kBlueColor)),
                                        ],
                                      ),
                                      SizedBox(height: mHeight * 0.01,),
                                      Text("${CustomString
                                          .requestedDepartment} ${val
                                          .manageOrgDataList[index].deptReq ?? ""}", style: const TextStyle(
                                          fontSize: 10,
                                          color: CustomColors.kLightGrayColor)),
                                    ],
                                  ),
                                  ElevatedButton(style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        CustomColors.kGrayColor),
                                  ),
                                      onPressed: () {},
                                      child: const Text(CustomString.cancel,
                                          style: TextStyle(color: CustomColors.kBlackColor))),
                                ],
                              ),
                            );
                          }) : Center(child: Image.asset(ImagePath.noData));
                    }
                ),

                ///Approved
                Consumer<DisplayManageOrgProvider>(
                    builder: (context, val, child) {
                      return val.manageOrgDataList.isNotEmpty? ListView
                          .builder(
                          shrinkWrap: true,
                          itemCount: val.manageOrgDataList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: mHeight * 0.08,
                              decoration: const BoxDecoration(
                                  border: BorderDirectional(
                                      bottom: BorderSide(width: 0.5),
                                      top: BorderSide(width: 0.1))
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: mWidth * 0.03,
                                  vertical: mHeight * 0.005),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(CustomString.requestApproved1),
                                      Text(
                                        val.manageOrgDataList[index].orgName ??
                                            "", style: const TextStyle(
                                          color: CustomColors.kBlueColor),),
                                      const Text(CustomString.requestApproved2),
                                    ],
                                  ),
                                  SizedBox(height: mHeight * 0.01,),
                                  Text("${CustomString.department} ${val
                                      .manageOrgDataList[index].deptName ??
                                      ""}", style: const TextStyle(fontSize: 10,
                                      color: CustomColors.kLightGrayColor)),
                                ],
                              ),
                            );
                          }) : Center(child: Image.asset(ImagePath.noData));
                    }
                ),

                ///Rejected
                Consumer<DisplayManageOrgProvider>(
                    builder: (context, val, child) {
                      return val.manageOrgDataList.isNotEmpty ? ListView
                          .builder(
                          shrinkWrap: true,
                          itemCount: val.manageOrgDataList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: mHeight * 0.08,
                              decoration: const BoxDecoration(
                                  border: BorderDirectional(
                                      bottom: BorderSide(width: 0.5),
                                      top: BorderSide(width: 0.1))
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: mWidth * 0.03,
                                  vertical: mHeight * 0.005),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(CustomString.requestApproved1),
                                      Text(
                                        val.manageOrgDataList[index].orgName ??
                                            "", style: const TextStyle(
                                          color: CustomColors.kBlueColor),),
                                      const Text(CustomString.requestApproved2),
                                    ],
                                  ),
                                  SizedBox(height: mHeight * 0.01,),
                                  Text("${CustomString.department} ${val
                                      .manageOrgDataList[index].deptName ??
                                      ""}", style: const TextStyle(fontSize: 10,
                                      color: CustomColors.kLightGrayColor)),
                                ],
                              ),
                            );
                          }) : Center(child: Image.asset(ImagePath.noData));
                    }
                ),
                Center(child:  Image.asset(ImagePath.noData)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void joinOrganizationDialog({context, mHeight, mWidth}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Dialog(
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
                  title: const Text(CustomString.joinOrganization,
                      style: TextStyle(color: CustomColors.kBlueColor)),
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
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                          padding: EdgeInsets.only(
                              right: mWidth * 0.004,
                              top: mHeight * 0.001,
                              bottom: mHeight * 0.001),
                          child: Image.asset(
                            ImagePath.search,
                            height: 10,
                            width: 10,
                          )),
                      fillColor: CustomColors.kWhiteColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                          const BorderSide(color: CustomColors.kBlueColor,
                              width: 1)),
                      hintText: CustomString.organizationName,
                      hintStyle: const TextStyle(
                          color: CustomColors.kLightGrayColor, fontSize: 14),
                    ),
                    style: const TextStyle(color: CustomColors.kBlackColor),
                    onTap: () {
                      //API
                      //organizationListDialog(context);
                    },
                  ),
                ),

                /// Department Name text form field
                Padding(
                  padding: EdgeInsets.only(
                      left: mWidth * 0.02,
                      right: mWidth * 0.02,
                      top: mHeight * 0.01,
                      bottom: mHeight * 0.01),
                  child: TextFormField(
                    controller: departmentNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return CustomString.departmentNameRequired;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: CustomColors.kWhiteColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: CustomColors.kBlueColor)),
                      labelText: CustomString.departmentName,
                      labelStyle: const TextStyle(fontSize: 14),
                    ),
                    style: const TextStyle(color: CustomColors.kBlackColor),
                  ),
                ),
                const Text('Or',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: CustomColors.kBlueColor)),

                /// Request New Department text form field
                Padding(
                  padding: EdgeInsets.only(
                      left: mWidth * 0.02,
                      right: mWidth * 0.02,
                      top: mHeight * 0.01,
                      bottom: mHeight * 0.01),
                  child: TextFormField(
                    controller: requestNewDepartmentController,
                    decoration: InputDecoration(
                      fillColor: CustomColors.kWhiteColor,
                      border: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: CustomColors.kBlueColor),
                          borderRadius: BorderRadius.circular(5)),
                      labelText: CustomString.requestNewDepartment,
                      labelStyle: const TextStyle(
                          color: CustomColors.kLightGrayColor, fontSize: 14),
                    ),
                    style: const TextStyle(color: CustomColors.kBlackColor),
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
                      height: mHeight * 0.08,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                CustomColors.kBlueColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                        color: CustomColors.kBlueColor)))),
                        child: const Text(CustomString.requestToJoin,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
