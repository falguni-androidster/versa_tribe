import 'package:flutter/material.dart';

import '../Utils/custom_colors.dart';
import '../Utils/custom_string.dart';

class ManageOrganization extends StatefulWidget {
  const ManageOrganization({super.key});

  @override
  State<ManageOrganization> createState() => _ManageOrganizationState();
}

class _ManageOrganizationState extends State<ManageOrganization>  with SingleTickerProviderStateMixin{

  TextEditingController organizationNameController = TextEditingController();
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController requestNewDepartmentController = TextEditingController();

  // define your tab controller here
  late TabController _tabController;

  @override
  void initState() {
    // initialise your tab controller here
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
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
                child: Icon(Icons.add_circle_outline,color: CustomColors.kWhiteColor),
              ),
              Text(
                CustomString.joinOrganization,
                style: TextStyle(color: CustomColors.kWhiteColor),
              )
            ],
          ),
          backgroundColor: CustomColors.kBlueColor,
          onPressed: () {
            joinOrganizationDialog(context);
          },
        ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              isScrollable: true,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: CustomColors.kLightGrayColor,
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                color: CustomColors.kLightGrayColor,
                fontWeight: FontWeight.w700,
              ),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700
              ),
              tabs: <Widget>[
                Container(padding: const EdgeInsets.all(10),decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),color: CustomColors.kGrayColor), child: const Text('All')),
                Container(padding: const EdgeInsets.all(10),decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),color: CustomColors.kGrayColor), child: const Text('Requested')),
                Container(padding: const EdgeInsets.all(10),decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),color: CustomColors.kGrayColor), child: const Text('Approved')),
                Container(padding: const EdgeInsets.all(10),decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),color: CustomColors.kGrayColor), child: const Text('Rejected')),
                Container(padding: const EdgeInsets.all(10),decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),color: CustomColors.kGrayColor), child: const Text('Removed')),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                Center(
                  child: Text(
                    'All',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: Text(
                    'Requested',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: Text(
                    'Approved',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: Text(
                    'Rejected',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: Text(
                    'Removed',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }

  void joinOrganizationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                backgroundColor: CustomColors.kWhiteColor,
                leading: InkWell(
                  child:
                  const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                title: const Text(CustomString.joinOrganization,
                    style: TextStyle(color: CustomColors.kBlueColor)),
                centerTitle: true,
              ),
              const SizedBox(height: 10),

              /// Organization Name text form field
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: organizationNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return CustomString.organizationNameRequired;
                    } else {
                      return null;
                    }
                  },
                  readOnly: true,
                  decoration: const InputDecoration(
                      labelText: CustomString.organizationName,
                      labelStyle: TextStyle(
                          color: CustomColors.kLightGrayColor,
                          fontSize: 14),
                  ),
                  style: const TextStyle(color: CustomColors.kBlackColor),
                  onTap: (){
                    organizationListDialog(context);
                  },
                ),
              ),

              /// Department Name text form field
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: departmentNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return CustomString.departmentNameRequired;
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: CustomString.departmentName,
                    labelStyle: TextStyle(
                        color: CustomColors.kLightGrayColor,
                        fontSize: 14),
                  ),
                  style: const TextStyle(color: CustomColors.kBlackColor),
                ),
              ),
              const Text('Or',textAlign: TextAlign.center,style: TextStyle(color: CustomColors.kBlueColor)),

              /// Request New Department text form field
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: requestNewDepartmentController,
                  decoration: const InputDecoration(
                    labelText: CustomString.requestNewDepartment,
                    labelStyle: TextStyle(
                        color: CustomColors.kLightGrayColor,
                        fontSize: 14),
                  ),
                  style: const TextStyle(color: CustomColors.kBlackColor),
                ),
              ),

              /// Elevated Submit Button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.05,
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(CustomColors.kBlueColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: CustomColors.kBlueColor)))),
                      child: const Text(CustomString.requestToJoin, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    )
                ),
              ),

            ],
          ),
        );
      },
    );
  }

  /// Show Organization list Dialog
  void organizationListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                backgroundColor: CustomColors.kWhiteColor,
                leading: InkWell(
                  child:
                  const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                title: const Text(CustomString.selectOrganization,
                    style: TextStyle(color: CustomColors.kBlueColor)),
                centerTitle: true,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.05,
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(CustomColors.kBlueColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: CustomColors.kBlueColor)))),
                      child: const Text(CustomString.buttonContinue, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    )
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


